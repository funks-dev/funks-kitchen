import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:core';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  File? _imageFile;
  String? _currentImageBase64;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user != null) {
        // Fetch user profile data from Supabase
        final response = await supabase
            .from('users')
            .select()
            .eq('id', user.id)
            .single();

        setState(() {
          _nameController.text = response['full_name'] ?? '';
          _emailController.text = user.email ?? '';
          _mobileController.text = response['mobile_number'] ?? '';
          _currentImageBase64 = response['profile_image'];
        });
      } else {
        _showErrorSnackBar('No user logged in');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error loading user data: $e");
      }
      _showErrorSnackBar('Error loading user data');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 50,
      );

      if (pickedFile != null) {
        final File file = File(pickedFile.path);
        final result = await FlutterImageCompress.compressWithFile(
          file.absolute.path,
          minWidth: 500,
          minHeight: 500,
          quality: 50,
        );

        if (result != null) {
          setState(() {
            _imageFile = file;
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error picking image: $e");
      }
      _showErrorSnackBar('Error selecting image');
    }
  }

  Future<String> _getBase64Image() async {
    if (_imageFile == null) return '';

    try {
      final bytes = await _imageFile!.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      if (kDebugMode) {
        print("Error converting image to base64: $e");
      }
      throw Exception('Failed to convert image');
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _saveProfile() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('Gaada user yang login kocak');

      final updateData = {
        'id': user.id, // Include the user ID in the update data
        'full_name': _nameController.text.trim(),
        'mobile_number': _mobileController.text.trim(),
      };

      if (_imageFile != null) {
        final base64Image = await _getBase64Image();
        if (base64Image.isNotEmpty) {
          final sizeInBytes = base64Image.length;
          final sizeInMB = sizeInBytes / (1024 * 1024);

          if (sizeInMB > 0.5) {
            throw Exception('Image size too large (max 500KB)');
          }

          updateData['profile_image'] = base64Image;
        }
      }

      // Update user profile in Supabase
      await supabase
          .from('users')
          .upsert(updateData);

      if (!mounted) return;

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anjay berhasil update profile bos')),
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error updating profile: $e");
      }
      _showErrorSnackBar(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _getProfileImage(),
                  backgroundColor: Colors.grey[300],
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFDA1E1E),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    onPressed: _pickImage,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            const Text(
              "Change Photo Profile",
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Inter',
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _emailController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _mobileController,
              decoration: const InputDecoration(
                labelText: 'Mobile Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDA1E1E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider<Object> _getProfileImage() {
    if (_imageFile != null) {
      return FileImage(_imageFile!);
    }
    if (_currentImageBase64 != null && _currentImageBase64!.isNotEmpty) {
      return MemoryImage(base64Decode(_currentImageBase64!));
    }
    return const AssetImage('assets/images/profile.png');
  }
}
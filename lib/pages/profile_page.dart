import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'package:shimmer/shimmer.dart';

import '../components/footer.dart';
import '../components/header.dart';
import '../components/sidebar.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late int _selectedIndex = 3;
  bool isLoading = true;
  bool _mounted = true;
  String? fullName;
  String? email;
  String? mobileNumber;
  String? _profileImageBase64;

  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    try {
      setState(() => isLoading = true);

      final User? user = _supabase.auth.currentUser;
      if (user != null) {
        final response = await _supabase
            .from('users')
            .select('full_name, email, mobile_number, profile_image')
            .eq('id', user.id)
            .single();

        if (mounted && response != null) {  // Tambahkan pengecekan mounted
          setState(() {
            fullName = response['full_name'];
            email = user.email;
            mobileNumber = response['mobile_number'];
            _profileImageBase64 = response['profile_image'];
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching user data: $e");
      }
    } finally {
      if (mounted) {  // Pastikan widget masih mounted
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Jalankan fetch setelah build selesai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUserData();
    });
  }

  Future<void> _refreshProfile() async {
    await _fetchUserData();
  }

  void _onItemTapped(int index) {
    if (!mounted) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  // Shimmer untuk profile section
  Widget _buildLoadingProfileSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Profile image shimmer
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Profile info shimmer
        Expanded(
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 120,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 100,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ),
          ),
        ),
        const IconButton(
          icon: Icon(Icons.settings, color: Colors.grey),
          onPressed: null,
        ),
      ],
    );
  }

  Widget _buildProfileOption(IconData icon, String text) {
    return InkWell(
      onTap: () {
        // Handle onTap event
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFDA1E1E)),
            const SizedBox(width: 16),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    ImageProvider imageProvider;

    if (_profileImageBase64 != null && _profileImageBase64!.isNotEmpty) {
      try {
        final imageBytes = base64Decode(_profileImageBase64!);
        imageProvider = MemoryImage(imageBytes);
      } catch (e) {
        if (kDebugMode) {
          print("Error decoding base64 image: $e");
        }
        imageProvider = const AssetImage('assets/images/profile.png');
      }
    } else {
      imageProvider = const AssetImage('assets/images/profile.png');
    }

    return CircleAvatar(
      radius: 36,
      backgroundImage: imageProvider,
      backgroundColor: Colors.grey[300],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      drawer: const Sidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 16),

            // Profile section dengan conditional shimmer
            isLoading ? _buildLoadingProfileSection() : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildProfileImage(),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName ?? "Gaada Nama lu kocak",
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email ?? "Gimana bisa email lu gaada cuk",
                        style: const TextStyle(
                          fontSize: 10,
                          fontFamily: 'Inter',
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        mobileNumber ?? "Halo nomor wa mu berapa hehe",
                        style: const TextStyle(
                          fontSize: 10,
                          fontFamily: 'Inter',
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditProfilePage()),
                    );
                    _refreshProfile();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),

            // Menu options tanpa shimmer
            _buildProfileOption(Icons.location_on_outlined, 'Location'),
            _buildProfileOption(Icons.history, 'Activity'),
            _buildProfileOption(Icons.rate_review_outlined, 'Review'),
            const Divider(),
            const SizedBox(height: 10),
            _buildProfileOption(Icons.report_gmailerrorred_outlined, 'Pesanan Dikomplain'),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        isBackgroundVisible: true,
      ),
    );
  }
}

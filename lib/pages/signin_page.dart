import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _supabase = Supabase.instance.client;
  bool _isLoading = false;
  bool _isPasswordVisible = false; // To toggle password visibility

  void _signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Sign in the user with email and password
        final response = await _supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );

        if (response.user != null) {
          // Clear the text fields
          _emailController.clear();
          _passwordController.clear();

          if (mounted) {
            // Show success dialog before navigating
            _showSuccessDialog();
          }
        }
      } on AuthException catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Unexpected error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukin email sama passwordmu kocak.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutterquickstart://login-callback/',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error signing in with Google: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Function to show the success dialog
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissal when tapped outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Mantap bos berhasil login Mobile Legend!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacementNamed(context, '/home_page');
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/images/funks_logo_header.png',
                width: 145,
                height: 158,
              ),
              const SizedBox(height: 20),

              // Login Text
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),

              // Email Address Field
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 15),

              // Password Field
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible, // Toggle visibility
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible; // Toggle the password visibility
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Sign In Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDA1E1E),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: _isLoading ? null : _signIn,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Inter',
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Divider with Text
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'Or Sign In With',
                      style: TextStyle(fontFamily: 'Inter'),
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 20),

              // Social Media Login Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: Colors.grey[200],
                    child: IconButton(
                      icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red),
                      onPressed: _signInWithGoogle,
                    ),
                  ),
                  const SizedBox(width: 20),
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: Colors.grey[200],
                    child: IconButton(
                      icon: const Icon(Icons.facebook, color: Colors.blue),
                      onPressed: () {
                        // TODO: Implement Facebook login
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: Colors.grey[200],
                    child: IconButton(
                      icon: const Icon(Icons.apple, color: Colors.black),
                      onPressed: () {
                        // TODO: Implement Apple login
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Sign Up Link Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don\'t have an account?',
                    style: TextStyle(fontFamily: 'Inter'),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/signup_page');
                    },
                    child: const Text(
                      ' Sign Up',
                      style: TextStyle(
                        color: Color(0xFFDA1E1E),
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

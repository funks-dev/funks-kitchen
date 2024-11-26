import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false, // Disable extend body behind the AppBar
      body: SingleChildScrollView(  // Wrap everything in a SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/images/funks_logo_header.png',  // Update with your actual image path
                width: 145,
                height: 158,
              ),
              const SizedBox(height: 20),

              // Create an Account Text
              const Text(
                'Create an Account',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),

              // Email Address Field
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 15),

              // Full Name Field
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 15),

              // Mobile Number Field
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 15),

              // Password Field
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 15),

              // Confirm Password Field
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 20),

              // Sign Up Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDA1E1E),  // Red color
                  minimumSize: const Size(double.infinity, 50),  // Full width
                ),
                onPressed: () {
                  // Implement sign-up logic here
                },
                child: const Text(
                  'Sign Up',
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
                    child: Text('Or Sign Up With',
                    style: TextStyle(
                      fontFamily: 'Inter'
                    ),),
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
                      onPressed: () {
                        // Implement Google login here
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: Colors.grey[200],
                    child: IconButton(
                      icon: const Icon(Icons.facebook, color: Colors.blue),
                      onPressed: () {
                        // Implement Facebook login here
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
                        // Implement Apple login here
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Already have an account? Link Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?',
                  style: TextStyle(
                    fontFamily: 'Inter'
                  ),),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Close the drawer
                      Navigator.pushNamed(
                        context,
                        '/signin_page',
                      );
                    },
                    child: const Text(
                      ' Sign In',
                      style: TextStyle(
                          color: Color(0xFFDA1E1E),
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

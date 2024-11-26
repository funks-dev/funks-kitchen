import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

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
                'assets/images/funks_logo_header.png',  // Update with your actual image path
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
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
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
              const SizedBox(height: 20),

              // Sign In Button
              GestureDetector(
                onTap: () {
                  // Implement sign-in logic here
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDA1E1E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Inter',
                      color: Colors.white,
                    ),
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
                    child: Text('Or Sign In With',
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
                  GestureDetector(
                    onTap: () {
                      // Implement Google login here
                    },
                    child: CircleAvatar(
                      radius: 34,
                      backgroundColor: Colors.grey[200],
                      child: const FaIcon(FontAwesomeIcons.google, color: Colors.red),
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Close the drawer
                      Navigator.pushNamed(context, '/signup_page'); // Navigate to Sign Up page
                    },
                    child: CircleAvatar(
                      radius: 34,
                      backgroundColor: Colors.grey[200],
                      child: const Icon(Icons.facebook, color: Colors.blue),
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      // Implement Apple login here
                    },
                    child: CircleAvatar(
                      radius: 34,
                      backgroundColor: Colors.grey[200],
                      child: const Icon(Icons.apple, color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Sign Up Link Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?',
                  style: TextStyle(
                    fontFamily: 'Inter'
                  ),),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Close the drawer
                      Navigator.pushNamed(
                        context,
                        '/signup_page',
                      );
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
}

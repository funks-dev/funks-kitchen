import 'package:flutter/material.dart';
import 'pages/about_us_page.dart';
import 'pages/home_page.dart';
import 'pages/menu_page.dart';
import 'pages/news_page.dart';
import 'pages/starting_page.dart';
import 'pages/signin_page.dart';
import 'pages/signup_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Funks Kitchen',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const StartingPage(),
      routes: {
        '/about_us_page': (context) => const AboutUsPage(),
        '/news_page': (context) => const NewsPage(),
        '/home_page': (context) => const HomePage(),
        '/signin_page': (context) => const SignInPage(),
        '/signup_page': (context) => const SignUpPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/menu_page') {
          // Extract the initial selection argument (true for Food, false for Drinks)
          final bool initialIsFoodSelected = settings.arguments as bool? ?? true;

          return MaterialPageRoute(
            builder: (context) => MenuPage(initialIsFoodSelected: initialIsFoodSelected),
          );
        }
        return null; // Return null for undefined routes
      },
    );
  }
}

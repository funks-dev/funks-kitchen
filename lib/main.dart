import 'package:Funks_Kitchen/pages/order_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/checkout_page.dart';
import 'pages/about_us_page.dart';
import 'pages/home_page.dart';
import 'pages/menu_page.dart';
import 'pages/news_page.dart';
import 'pages/starting_page.dart';
import 'pages/signin_page.dart';
import 'pages/signup_page.dart';
import 'pages/profile_page.dart';
import 'pages/edit_profile_page.dart';

Future<void> main() async {
  // Pastikan binding widget terinisialisasi terlebih dahulu
  WidgetsFlutterBinding.ensureInitialized();

  // Muat file .env secara asinkron dan tunggu sampai selesai
  await dotenv.load();

  // Ambil URL dan API key dari .env
  final String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  final String supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  // Debugging: Periksa apakah URL dan key sudah benar
  if (kDebugMode) {
    print('Supabase URL: $supabaseUrl');
    print('Supabase Anon Key: $supabaseAnonKey');
  }

  // Jika URL dan Key kosong, pastikan Anda memuat file .env dengan benar
  if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
    throw Exception('Supabase credentials are missing. Please check your .env file.');
  }

  // Inisialisasi Supabase
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
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
        '/profile_page': (context) => const ProfilePage(),
        '/edit_profile_page': (context) => const EditProfilePage(),
        '/order_page': (context) => const OrderPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/menu_page') {
          final bool initialIsFoodSelected = settings.arguments as bool? ?? true;
          return MaterialPageRoute(
            builder: (context) => MenuPage(initialIsFoodSelected: initialIsFoodSelected),
          );
        }
        if (settings.name == '/checkout_page') {
          final Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => CheckoutPage(
                cartItems: args['cartItems'],
                totalPrice: args['totalPrice']
            ),
          );
        }
        return null; // Return null for undefined routes
      },
    );
  }
}
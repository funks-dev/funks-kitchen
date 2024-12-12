import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String mobileNumber,
    String? profileImage, // Menambahkan opsional untuk gambar profil
  }) async {
    try {
      // Buat akun pengguna di Supabase Authentication
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        if (kDebugMode) {
          print('User created in Auth with ID: ${response.user!.id}');
        } // tambah log

        try {
          // Simpan data pengguna ke tabel 'users'
          final result = await _supabaseClient.from('users').insert({
            'id': response.user!.id,
            'email': email,
            'full_name': fullName,
            'mobile_number': mobileNumber,
            'profile_image': profileImage ?? '',  // Default kosong jika tidak ada gambar profil
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          }).select();

          if (kDebugMode) {
            print('Data berhasil disimpan ke tabel users');
          } // tambah log
          if (kDebugMode) {
            print('Result: $result');
          } // tambah log
        } catch (dbError) {
          if (kDebugMode) {
            print('Error menyimpan ke database: $dbError');
          } // tambah log spesifik untuk error database
        }

        if (kDebugMode) {
          print('User registered successfully');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error registering user: $e');
      }
      rethrow;
    }
  }
}
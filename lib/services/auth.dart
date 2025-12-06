import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  // HASH PASSWORD
  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id') != null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> saveSession(
    String userId,
    String email,
    String fullName, {
    String? weight,
    String? height,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('user_id', userId);
    await prefs.setString('email', email);
    await prefs.setString('full_name', fullName);
    await prefs.setString('weight', weight!);
    await prefs.setString('height', height!);
  }

// REGISTER
  Future<String?> register(String name, String email, String password) async {
    try {
      final hashed = hashPassword(password);

      // Cek apakah email sudah terdaftar
      final exists = await supabase
          .from('users')
          .select()
          .eq('email', email)
          .maybeSingle();

      if (exists != null) {
        return "Email sudah terdaftar!";
      }

      // Insert user baru dengan berat dan tinggi default 0
      await supabase.from('users').insert({
        'full_name': name,
        'email': email,
        'password': hashed,
        'weight': 0, // default
        'height': 0, // default
      });

      return null; // sukses
    } catch (e) {
      return "Gagal register: $e";
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      final hashed = hashPassword(password);

      final user = await supabase
          .from('users')
          .select()
          .eq('email', email)
          .eq('password', hashed)
          .maybeSingle();

      if (user == null) {
        return "Email atau password salah!";
      }

      // SIMPAN SESSION LOCAL
      await saveSession(
        user['id'],
        user['email'],
        user['full_name'],
        weight: user['weight'],
        height: user['height'],
      );

      return null; // sukses
    } catch (e) {
      return "Login error: $e";
    }
  }

  Future<void> updateSession(
      String fullName, double weight, double height) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('full_name', fullName);
    await prefs.setDouble('weight', weight);
    await prefs.setDouble('height', height);
  }
}

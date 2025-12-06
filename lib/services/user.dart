import 'package:supabase_flutter/supabase_flutter.dart';

class UserServices {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> getUserById(String userId) async {
    return await supabase.from('users').select().eq('id', userId).maybeSingle();
  }

  Future<bool> updateUser(
      String userId, String fullName, double weight, double height) async {
    try {
      await supabase.from('users').update({
        'full_name': fullName,
        'weight': weight,
        'height': height,
      }).eq('id', userId);

      return true;
    } catch (e) {
      print("Update gagal: $e");
      return false;
    }
  }
}

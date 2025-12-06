import 'package:supabase_flutter/supabase_flutter.dart';

class ServicesFoodDrink {
  final supabase = Supabase.instance.client;

  // CREATE
  Future<bool> addFood({
    required String name,
    required String category,
    required int iconCode,
    required double calories,
    String? description,
    String? imageUrl,
  }) async {
    try {
      await supabase.from('foods').insert({
        'name': name,
        'category': category,
        'icon_code': iconCode,
        'calories': calories,
        'description': description,
        'image_url': imageUrl,
      });

      print("✅ Insert berhasil!");
      return true;
    } catch (e) {
      print("❌ Error insert: $e");
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getMinuman() async {
    try {
      final response = await supabase
          .from('foods') // tabel di Supabase
          .select() // ambil semua kolom
          .eq('category', 'minuman') // filter kategori minuman
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("❌ Error get minuman: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getMakanan() async {
    try {
      final response = await supabase
          .from('foods') // tabel di Supabase
          .select() // ambil semua kolom
          .eq('category', 'makanan') // filter kategori minuman
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("❌ Error get minuman: $e");
      return [];
    }
  }

  // UPDATE
  Future<bool> updateFood({
    required String foodId,
    required String name,
    required String category,
    required int iconCode,
    required double calories,
    String? description,
    String? imageUrl,
  }) async {
    try {
      await supabase.from('foods').update({
        'name': name,
        'category': category,
        'icon_code': iconCode,
        'calories': calories,
        'description': description,
        'image_url': imageUrl,
      }).eq('id', foodId);

      print("✅ Update berhasil!");
      return true;
    } catch (e) {
      print("❌ Error update: $e");
      return false;
    }
  }

  // DELETE
  Future<bool> deleteFood(String foodId, {String? imageUrl}) async {
    try {
      // Hapus foto dulu kalau ada
      if (imageUrl != null && imageUrl.isNotEmpty) {
        try {
          final uri = Uri.parse(imageUrl);
          final path = uri.pathSegments
              .sublist(5)
              .join('/'); // Ambil path setelah /storage/v1/object/public/foods/
          await supabase.storage.from('foods').remove([path]);
          print("✅ Foto dihapus");
        } catch (e) {
          print("⚠️ Gagal hapus foto: $e");
        }
      }

      // Hapus data
      await supabase.from('foods').delete().eq('id', foodId);
      print("✅ Data dihapus!");
      return true;
    } catch (e) {
      print("❌ Error delete: $e");
      return false;
    }
  }
}

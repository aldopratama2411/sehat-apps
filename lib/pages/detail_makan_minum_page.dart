import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../services/fooddrink.dart';

class DetailMakanMinumPage extends StatelessWidget {
  final Map<String, dynamic>? item;
  final VoidCallback? onDeleteSuccess; // Callback setelah berhasil delete

  const DetailMakanMinumPage({super.key, this.item, this.onDeleteSuccess});

  Future<void> _handleDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Item"),
        content: const Text("Apakah anda yakin ingin menghapus item ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const Center(child: CircularProgressIndicator()),
      );

      // Panggil service delete
      final service = ServicesFoodDrink();
      final success = await service.deleteFood(
        item!['id'].toString(),
        imageUrl: item!['image_url'],
      );

      // Close loading
      Navigator.pop(context);

      if (success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Item berhasil dihapus"),
            backgroundColor: Colors.green,
          ),
        );

        // Callback ke halaman sebelumnya
        if (onDeleteSuccess != null) {
          onDeleteSuccess!();
        }

        // Kembali ke halaman sebelumnya
        Navigator.pop(context);
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal menghapus item"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (item == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Detail")),
        body: const Center(child: Text("Data tidak tersedia")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _handleDelete(context),
          ),
        ],
        backgroundColor: Colors.blueAccent.shade700,
        elevation: 0,
        title: Text(
          item!['name'] ?? 'Detail',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar
            if (item!['image_url'] != null)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Image.network(
                  item!['image_url'],
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: Colors.grey.shade200, height: 250),
                ),
              )
            else
              Container(
                color: Colors.grey.shade200,
                height: 250,
                child: Center(
                  child: Lottie.asset(
                    'assets/images/loading.json',
                    height: 50,
                    width: 50,
                  ),
                ),
              ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama
                  Text(
                    item!['name'] ?? '-',
                    style: GoogleFonts.montserrat(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Kalori
                  Row(
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${item!['calories'] ?? 0} kkal",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Deskripsi
                  Text(
                    "Deskripsi",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item!['description'] ?? "Tidak ada deskripsi",
                    style: GoogleFonts.montserrat(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/fooddrink.dart';

class InputMakanMinumPage extends StatefulWidget {
  const InputMakanMinumPage({super.key});

  @override
  State<InputMakanMinumPage> createState() => _InputMakanMinumPageState();
}

class _InputMakanMinumPageState extends State<InputMakanMinumPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController kaloriController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

  XFile? pickedImage;
  String? selectedCategory;
  IconData? selectedIcon;
  bool isLoading = false;

  final List<String> kategori = ["makanan", "minuman"];

  final List<IconData> pilihanIcon = [
    Icons.fastfood,
    Icons.local_pizza,
    Icons.rice_bowl,
    Icons.lunch_dining,
    Icons.local_dining,
    Icons.set_meal,
    Icons.ramen_dining,
    Icons.kebab_dining,
    Icons.soup_kitchen,
    Icons.egg,
    Icons.breakfast_dining,
    Icons.dinner_dining,
    Icons.icecream,
    Icons.cookie,
    Icons.cake,
    Icons.bakery_dining,
    Icons.brunch_dining,
    Icons.local_drink,
    Icons.local_cafe,
    Icons.coffee,
    Icons.emoji_food_beverage,
    Icons.local_bar,
    Icons.wine_bar,
    Icons.water_drop,
  ];

  Future<void> pilihFoto() async {
    final ImagePicker picker = ImagePicker();
    final foto = await picker.pickImage(source: ImageSource.gallery);

    if (foto != null) {
      setState(() {
        pickedImage = foto;
      });
    }
  }

  Future<void> simpan() async {
    // Validasi
    if (namaController.text.trim().isEmpty ||
        kaloriController.text.trim().isEmpty ||
        selectedIcon == null ||
        selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harap isi semua kolom wajib")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Ambil user_id dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id') ?? 'default_user';

      final supabase = Supabase.instance.client;

      // Upload foto jika ada
      String? imageUrl;
      if (pickedImage != null) {
        final file = File(pickedImage!.path);
        final fileExt = path.extension(file.path);
        final fileName = "${DateTime.now().millisecondsSinceEpoch}$fileExt";
        final filePath = "$userId/$fileName";

        await supabase.storage.from("foods").upload(filePath, file);
        imageUrl = supabase.storage.from("foods").getPublicUrl(filePath);
      }

      // Simpan ke database
      final service = ServicesFoodDrink();
      final success = await service.addFood(
        name: namaController.text.trim(),
        category: selectedCategory!,
        iconCode: selectedIcon!.codePoint,
        calories: double.tryParse(kaloriController.text) ?? 0,
        description: deskripsiController.text.trim().isEmpty
            ? null
            : deskripsiController.text.trim(),
        imageUrl: imageUrl,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Berhasil disimpan!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Gagal menyimpan")),
        );
      }
    } catch (e) {
      print("Error simpan: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent.shade700,
      body: Column(
        children: [
          const Gap(30),

          // HEADER
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              ),
              const Gap(20),
              Text(
                "Input Makanan / Minuman",
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const Gap(50),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(25),

                    // ICON PICKER
                    Text(
                      "Pilih Icon",
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(10),

                    SizedBox(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: pilihanIcon.length,
                        itemBuilder: (context, index) {
                          final icon = pilihanIcon[index];
                          final bool aktif = icon == selectedIcon;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIcon = icon;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 12),
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                color: aktif
                                    ? Colors.blueAccent.shade700
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: aktif
                                      ? Colors.blueAccent.shade700
                                      : Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                icon,
                                color: aktif ? Colors.white : Colors.grey,
                                size: 28,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const Gap(25),
                    Text(
                      "Kategori",
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(10),

                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: kategori
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e.toUpperCase(),
                                  style: GoogleFonts.montserrat(),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),

                    const Gap(20),

                    TextField(
                      controller: namaController,
                      decoration: InputDecoration(
                        labelText: "Nama Makanan / Minuman",
                        prefixIcon:
                            selectedIcon != null ? Icon(selectedIcon) : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const Gap(20),

                    TextField(
                      controller: kaloriController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Jumlah Kalori per 1 porsi / ml",
                        prefixIcon: const Icon(Icons.local_fire_department),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const Gap(20),

                    TextField(
                      controller: deskripsiController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "Deskripsi (opsional)",
                        alignLabelWithHint: true,
                        prefixIcon: const Icon(Icons.description),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const Gap(25),

                    Text(
                      "Upload Foto",
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const Gap(12),

                    GestureDetector(
                      onTap: pilihFoto,
                      child: Container(
                        height: 170,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey.shade100,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: pickedImage == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo_rounded,
                                      size: 40, color: Colors.grey.shade600),
                                  const Gap(10),
                                  Text(
                                    "Pilih Foto",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  )
                                ],
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.file(
                                  File(pickedImage!.path),
                                  width: double.infinity,
                                  height: 170,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),

                    const Gap(35),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : simpan,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                "Simpan",
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    const Gap(20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

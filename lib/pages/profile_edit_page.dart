import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../routes/name_routes.dart';
import '../services/auth.dart';
import '../services/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController beratController = TextEditingController();
  final TextEditingController tinggiController = TextEditingController();

  String? userId;

  @override
  void initState() {
    super.initState();
    loadSession();
  }

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();

    userId = prefs.getString('user_id');

    namaController.text = prefs.getString('full_name') ?? "";
    beratController.text = (prefs.getDouble('weight') ?? 0).toString();
    tinggiController.text = (prefs.getDouble('height') ?? 0).toString();

    setState(() {});
  }

  Future<void> simpan() async {
    if (userId == null) return;

    final fullName = namaController.text.trim();
    final weight = double.tryParse(beratController.text) ?? 0;
    final height = double.tryParse(tinggiController.text) ?? 0;

    final userService = UserServices();
    final success = await userService.updateUser(
      userId!,
      fullName,
      weight,
      height,
    );

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menyimpan perubahan")),
      );
      return;
    }

    // UPDATE SESSION
    final auth = AuthService();
    await auth.updateSession(fullName, weight, height);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Berhasil disimpan")),
    );

    Navigator.pop(context);
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
                "Edit Profile",
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const Gap(40),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: namaController,
                    decoration: InputDecoration(
                      labelText: "Nama Lengkap",
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const Gap(20),
                  TextField(
                    controller: beratController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Berat Badan (kg)",
                      prefixIcon: const Icon(Icons.monitor_weight),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const Gap(20),
                  TextField(
                    controller: tinggiController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Tinggi Badan (cm)",
                      prefixIcon: const Icon(Icons.height),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const Gap(30),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: simpan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Simpan Perubahan",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AuthService().logout();
          context.goNamed(NameRoutes.login);
        },
        child: const Icon(Icons.logout),
      ),
    );
  }
}

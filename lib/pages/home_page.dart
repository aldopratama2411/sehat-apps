import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/name_routes.dart';
import '../services/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Map<String, dynamic>?>? userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = loadUser();
  }

  Future<Map<String, dynamic>?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("user_id");

    if (userId == null) return null;

    return UserServices().getUserById(userId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/images/loading.json',
                  width: 100,
                ),
                ElevatedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                      context.goNamed(NameRoutes.login);
                    },
                    child: Text("Cancel"))
              ],
            )),
          );
        }

        final user = snapshot.data!;
        final nama = user['full_name'] ?? "-";
        final berat = user['weight']?.toString() ?? "-";
        final tinggi = user['height']?.toString() ?? "-";

        return Scaffold(
          backgroundColor: Colors.blueAccent.shade700,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Gap(40),

              // HEADER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    Text(
                      "Health Apps",
                      style: GoogleFonts.montserrat(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () async {
                        // buka halaman edit
                        await context.pushNamed(NameRoutes.profileEdit);

                        // setelah kembali → refresh data user
                        setState(() {
                          userFuture = loadUser();
                        });
                      },
                      icon: const Icon(Icons.edit, color: Colors.white),
                    )
                  ],
                ),
              ),

              const Gap(20),

              const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 70,
                child: Icon(Icons.person, size: 70),
              ),

              const Gap(20),

              Text(
                nama,
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const Gap(20),

              // LABEL
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  label("Berat Badan"),
                  label("Tinggi Badan"),
                ],
              ),

              const Gap(5),

              // VALUE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  value("$berat kg"),
                  value("$tinggi cm"),
                ],
              ),

              const Gap(40),

              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: [
                        _menuCard(
                          title: "Makanan Kalori",
                          icon: Icons.restaurant_menu_rounded,
                          color: Colors.orange,
                          onTap: () =>
                              context.goNamed(NameRoutes.makananKalori),
                        ),
                        _menuCard(
                          title: "Minuman Kalori",
                          icon: Icons.local_drink_rounded,
                          color: Colors.lightBlue,
                          onTap: () =>
                              context.goNamed(NameRoutes.minumanKalori),
                        ),
                        _menuCard(
                          title: "Kalkulator BMI",
                          icon: Icons.fitness_center_rounded,
                          color: Colors.green,
                          onTap: () =>
                              context.goNamed(NameRoutes.calculatorBMI),
                        ),
                        _menuCard(
                          title: "Kalkulator Kalori",
                          icon: Icons.local_fire_department_rounded,
                          color: Colors.redAccent,
                          onTap: () =>
                              context.goNamed(NameRoutes.calculatorKalori),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget label(String text) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
        fontSize: 17,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget value(String text) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _menuCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 15),
            Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}

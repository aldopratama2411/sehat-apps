import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../services/auth.dart';
import '../routes/name_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final auth = AuthService();

  @override
  void initState() {
    super.initState();
    // Delay 3 detik
    Timer(const Duration(seconds: 5), () {
      checkSession();
    });
  }

  void checkSession() async {
    bool loggedIn = await auth.isLoggedIn();

    if (loggedIn) {
      context.goNamed(NameRoutes.home);
    } else {
      context.goNamed(NameRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Gap(20),
            Lottie.asset('assets/images/diet.json'),
            Gap(10),
            Text(
              "Healthy Apps",
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Loading animation
            Gap(50),
            Lottie.asset('assets/images/loading.json', height: 40, width: 40),
          ],
        ),
      ),
    );
  }
}

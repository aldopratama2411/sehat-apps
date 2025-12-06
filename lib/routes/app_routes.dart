import 'package:go_router/go_router.dart';

import '../pages/calculator_bmi_page.dart';
import '../pages/calculator_kalori_page.dart';
import '../pages/detail_makan_minum_page.dart';
import '../pages/home_page.dart';
import '../pages/input_makan_minum_page.dart';
import '../pages/login_page.dart';
import '../pages/makanan_kalori_page.dart';
import '../pages/minuman_kalori_page.dart';
import '../pages/profile_edit_page.dart';
import '../pages/register_page.dart';
import '../pages/splash_page.dart';
import 'name_routes.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: NameRoutes.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/login',
      name: NameRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      name: NameRoutes.register,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/home',
      name: NameRoutes.home,
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'calculator-bmi',
          name: NameRoutes.calculatorBMI,
          builder: (context, state) => const CalculatorBMIPage(),
        ),
        GoRoute(
          path: 'makanan-kalori',
          name: NameRoutes.makananKalori,
          builder: (context, state) => const MakananKaloriPage(),
        ),
        GoRoute(
          path: 'minuman-kalori',
          name: NameRoutes.minumanKalori,
          builder: (context, state) => const MinumanKaloriPage(),
        ),
        GoRoute(
          path: 'input-makan-minum',
          name: NameRoutes.addMakananDanMinumKalori,
          builder: (context, state) => const InputMakanMinumPage(),
        ),
        GoRoute(
          path: 'calculator-kalori',
          name: NameRoutes.calculatorKalori,
          builder: (context, state) => const CalculatorKaloriPage(),
        ),
        GoRoute(
          path: 'profile-edit',
          name: NameRoutes.profileEdit,
          builder: (context, state) => const ProfileEditPage(),
        ),
        GoRoute(
          name: NameRoutes.detailMakananDanMinuman,
          path: '/detail-makanan-minuman',
          builder: (context, state) {
            final item = state.extra as Map<String, dynamic>?;
            return DetailMakanMinumPage(item: item);
          },
        ),
      ],
    ),
  ],
);

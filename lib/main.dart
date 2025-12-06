import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'routes/app_routes.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://jwimxfyrvqbxrcvwnqfo.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp3aW14ZnlydnFieHJjdnducWZvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ2ODM2OTEsImV4cCI6MjA4MDI1OTY5MX0.scwwH9pacFXu1RQEkUamkcT5OvARN72NEJLSktTCrZg',
  );

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: false),
      routerConfig: router,
    );
  }
}

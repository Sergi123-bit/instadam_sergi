import 'package:flutter/material.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const SplashScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navega automàticament al Login després de 3 segons
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LoginPage(
              isDarkMode: widget.isDarkMode,
              onThemeChanged: widget.onThemeChanged,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1565C0), // Color primari accessible
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            //  S1: Logo amb Semantics → TalkBack anuncia el nom de l'app
            // No anuncia "Imatge" sense descripció
            Semantics(
              label: 'InstaDAM, logotip de l\'aplicació',
              image: true,
              child: const Icon(
                Icons.photo_camera,
                size: 100,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 24),

            // S1: Nom de l'app llegible per TalkBack
            const Text(
              'InstaDAM',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 48),

            // S1: Indicador de càrrega amb liveRegion → TalkBack anuncia "Carregant aplicació"
            Semantics(
              liveRegion: true,
              label: 'Carregant aplicació',
              child: Column(
                children: const [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'Carregant aplicació...',
                    style: TextStyle(color: Colors.white, fontSize: 16),
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

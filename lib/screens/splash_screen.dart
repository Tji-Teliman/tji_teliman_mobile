import 'package:flutter/material.dart';
import 'splash_screen_role.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<Offset> _slide1;
  late Animation<Offset> _slide2;
  late Animation<Offset> _slide3;
  late Animation<Offset> _slide4;

  late Animation<double> _fade1;
  late Animation<double> _fade2;
  late Animation<double> _fade3;
  late Animation<double> _fade4;

  static const _totalDuration = Duration(seconds: 6);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: _totalDuration,
      vsync: this,
    );

    // Chaque élément tombe légèrement du haut vers sa position finale,
    // avec un décalage dans le temps pour créer l'effet 1 par 1.
    _slide1 = Tween<Offset>(
      begin: const Offset(0, -1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOutBack),
      ),
    );

    _slide2 = Tween<Offset>(
      begin: const Offset(0, -1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.20, 0.55, curve: Curves.easeOutBack),
      ),
    );

    _slide3 = Tween<Offset>(
      begin: const Offset(0, -1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.40, 0.75, curve: Curves.easeOutBack),
      ),
    );

    _slide4 = Tween<Offset>(
      begin: const Offset(0, -1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.60, 1.0, curve: Curves.easeOutBack),
      ),
    );

    _fade1 = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.35, curve: Curves.easeIn),
    );
    _fade2 = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.20, 0.55, curve: Curves.easeIn),
    );
    _fade3 = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.40, 0.75, curve: Curves.easeIn),
    );
    _fade4 = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.60, 1.0, curve: Curves.easeIn),
    );

    _controller.forward();

    // Navigation automatique à la fin de l'animation
    Future.delayed(_totalDuration, () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const SplashScreenRole(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        // Utilisation d'une Column pour placer le logo au-dessus et le texte en-dessous
        child: Column(
          mainAxisSize: MainAxisSize.min, // Pour centrer verticalement le tout
          children: [
            // --- PARTIE HAUTE : LE LOGO (IMAGES 1, 2, 3) ---
            SizedBox(
              width: 180,
              height: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 1. Fond orange (Demarrage1)
                  SlideTransition(
                    position: _slide1,
                    child: FadeTransition(
                      opacity: _fade1,
                      child: Image.asset(
                        'assets/images/Demarrage1.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  // 2. Carte verte (Demarrage2)
                  SlideTransition(
                    position: _slide2,
                    child: FadeTransition(
                      opacity: _fade2,
                      child: Image.asset(
                        'assets/images/Demarrage2.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  // 3. Texte "Tji" (Demarrage3)
                  SlideTransition(
                    position: _slide3,
                    child: FadeTransition(
                      opacity: _fade3,
                      child: Image.asset(
                        'assets/images/Demarrage3.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // --- ESPACE ENTRE LOGO ET TEXTE ---
            const SizedBox(height: 20), // Ajustez cette valeur pour l'espacement voulu

            // --- PARTIE BASSE : LE TEXTE "Teliman" (IMAGE 4) ---
            SlideTransition(
              position: _slide4,
              child: FadeTransition(
                opacity: _fade4,
                child: SizedBox(
                  // Vous pouvez définir une hauteur spécifique pour le texte si nécessaire
                  height: 80, 
                  child: Image.asset(
                    'assets/images/Demarrage4.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

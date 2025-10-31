import 'package:flutter/material.dart';
import 'splash_screen_role.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    // ⚠️ Durée ajustée à 5 secondes (au lieu de 5 minutes)
    _animationController = AnimationController(
      duration: const Duration(seconds: 5), 
      vsync: this,
    );

    // Animation de fade (apparition)
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.3, curve: Curves.easeInOut),
    ));

    // Animation de scale (agrandissement)
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
    ));

    // Animation de rotation (légère rotation)
    _rotationAnimation = Tween<double>(
      begin: -0.1,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.6, curve: Curves.easeOutBack),
    ));

    // Animation de pulse (pulsation continue)
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeInOut), // Pulse à la fin
    ));

    _animationController.repeat(reverse: true); // Fait pulser en boucle pendant 5s

    // Navigation après 5 secondes vers l'écran de sélection de rôle
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        // Remplacement de la navigation nommée par la navigation directe
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const SplashScreenRole(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: Transform.scale(
                    // Utilisation de _pulseAnimation pour le scale final
                    scale: _pulseAnimation.value,
                    child: Image.asset(
                      // ⚠️ Assurez-vous que ce chemin est correct :
                      'assets/images/LOGO_TJI_TELIMAN.png', 
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

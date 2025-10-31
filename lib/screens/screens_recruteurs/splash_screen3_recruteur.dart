import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'splash_sreen4_recruteur.dart';
import 'register_recruteur.dart';

class SplashScreen3Recruteur extends StatefulWidget {
  const SplashScreen3Recruteur({super.key});

  @override
  State<SplashScreen3Recruteur> createState() => _SplashScreen3RecruteurState();
}

class _SplashScreen3RecruteurState extends State<SplashScreen3Recruteur> with SingleTickerProviderStateMixin {
  late AnimationController _bgController;
  late Animation<double> _bgScale;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _bgScale = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _bgController, curve: Curves.easeOut),
    );
    _bgController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted || _navigated) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          // Utilisation directe du nom de la classe de la page
          builder: (context) => const SplashScreen4Recruteur(), 
        ),
      );
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated zooming background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _bgController,
              builder: (context, _) {
                return Transform.scale(
                  scale: _bgScale.value,
                  child: Image.asset(
                     'assets/images/splash_screen3_recruteur.png',
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                // Main content column (unchanged layout)
                Column(
                  children: [
                    // Section du haut avec le texte (prend toute la largeur)
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 60.0),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              'DÉCOUVREZ DES MISSIONS RAPIDES PRÈS DE CHEZ VOUS',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 18, // Taille réduite
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.2,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Section centrale (espace pour l'image de fond)
                    const Expanded(
                      flex: 3,
                      child: SizedBox.shrink(),
                    ),

                    // Section du bas avec le bouton et les indicateurs
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Texte "Tji teliman" avec la nouvelle couleur
                            Text(
                              'Tji teliman',
                              style: GoogleFonts.inter(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2563EB), // Nouvelle couleur #2563EB
                                shadows: [
                                  Shadow(color: Colors.black.withOpacity(0.55), blurRadius: 6, offset: const Offset(0, 2)),
                                  Shadow(color: Colors.black.withOpacity(0.45), blurRadius: 6, offset: const Offset(2, 0)),
                                  Shadow(color: Colors.black.withOpacity(0.45), blurRadius: 6, offset: const Offset(-2, 0)),
                                  Shadow(color: Colors.black.withOpacity(0.45), blurRadius: 6, offset: const Offset(0, -2)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 2),

                            // Bouton principal
                            SizedBox(
                              width: 250,
                              height: 50,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFF9800), // Orange
                                      Color(0xFFFFC107), // Jaune
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFF9800).withOpacity(0.4),
                                      blurRadius: 15,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(25),
                                    onTap: () {
                                      _navigated = true;
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          // Utilisation directe du nom de la classe de la page
                                          builder: (context) => const RegisterRecruteur(), 
                                        ),
                                      );
                                    },
                                    child: Center(
                                      child: Text(
                                        "S'inscrire",
                                        style: GoogleFonts.inter(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),

                            // Indicateurs de page
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(4, (index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: index == 2
                                        ? const Color(0xFF4CAF50) // Vert pour la page actuelle
                                        : Colors.white.withOpacity(0.6),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                
            ],
          ),
          ),
        ],
      ),
    );
  }
}

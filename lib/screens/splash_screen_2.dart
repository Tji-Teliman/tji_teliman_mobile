import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({super.key});

  @override
  State<SplashScreen2> createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/image splash screen 2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
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
                        style: GoogleFonts.inter(
                          fontSize: 20, // Taille réduite
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
                      
                          // Bouton principal (libellé déjà modifié par l'utilisateur)
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
                                    Navigator.of(context).pushReplacementNamed('/onboarding3');
                              },
                              child: Center(
                                child: Text(
                                      'Continuer',
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
                            children: List.generate(5, (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: index == 0 
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

              // Top overlay: skip button only (no back arrow on screen 2)
              Positioned(
                top: 8,
                left: 8,
                right: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 36,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFFFF9800), Color(0xFFFFC107)]),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF9800).withOpacity(0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            Navigator.of(context).pushReplacementNamed('/onboarding5');
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Passer', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 6),
                              const Icon(Icons.fast_forward_rounded, color: Colors.white, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

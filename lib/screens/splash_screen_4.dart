import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen4 extends StatefulWidget {
  const SplashScreen4({super.key});

  @override
  State<SplashScreen4> createState() => _SplashScreen4State();
}

class _SplashScreen4State extends State<SplashScreen4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/image splash screen 4.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  // Titre en haut de l'écran
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 60.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          'GAGNER FACILEMENT , PAYÉ RAPIDEMENT',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 3,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Section du bas: texte + bouton + indicateurs (espacements calculés)
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final double maxH = constraints.maxHeight;
                          // Hauteurs fixes des éléments
                          const double brandH = 32; // "Tchi teliman"
                          const double buttonH = 50;
                          const double indicatorsH = 20; // points + marges
                          const double minNeeded = brandH + buttonH + indicatorsH;

                          final double spare = (maxH - minNeeded).clamp(0, 1000);

                          // Exiger le même espacement que sur les écrans 2 et 3: 2px
                          final double gapBrandToButton = spare >= 2 ? 2.0 : spare;
                          final double remaining = (spare - gapBrandToButton).clamp(0, 1000);

                          // Répartir le reste entre haut du texte et indicateurs
                          double gapBeforeBrand = remaining * 0.6;
                          if (gapBeforeBrand > 60) gapBeforeBrand = 60;
                          double gapButtonToIndicators = remaining - gapBeforeBrand;
                          if (gapButtonToIndicators > 28) gapButtonToIndicators = 28;
                          if (gapButtonToIndicators < 0) gapButtonToIndicators = 0;

                          // Descendre le bloc texte+button ensemble sans changer leur espacement
                          const double shiftBlockDown = 10; // px
                          final double canShift = gapButtonToIndicators >= shiftBlockDown
                              ? shiftBlockDown
                              : gapButtonToIndicators;
                          gapBeforeBrand += canShift;
                          gapButtonToIndicators -= canShift;

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(height: gapBeforeBrand),
                              Text(
                                'Tchi teliman',
                                style: GoogleFonts.inter(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2563EB),
                                  shadows: [
                                    Shadow(color: Colors.black.withOpacity(0.55), blurRadius: 6, offset: const Offset(0, 2)),
                                    Shadow(color: Colors.black.withOpacity(0.45), blurRadius: 6, offset: const Offset(2, 0)),
                                    Shadow(color: Colors.black.withOpacity(0.45), blurRadius: 6, offset: const Offset(-2, 0)),
                                    Shadow(color: Colors.black.withOpacity(0.45), blurRadius: 6, offset: const Offset(0, -2)),
                                  ],
                                ),
                              ),
                              SizedBox(height: gapBrandToButton),
                              SizedBox(
                                width: 250,
                                height: buttonH,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFFF9800),
                                        Color(0xFFFFC107),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.25),
                                        blurRadius: 10,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(25),
                                      onTap: () {
                                        Navigator.of(context).pushReplacementNamed('/onboarding5');
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
                              SizedBox(height: gapButtonToIndicators),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (index) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: index == 3
                                          ? const Color(0xFF4CAF50)
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
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),

              // Overlay header
              Positioned(
                top: 8,
                left: 8,
                right: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('/onboarding3');
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
                        ),
                      ),
                    ),
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

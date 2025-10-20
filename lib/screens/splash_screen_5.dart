import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen5 extends StatefulWidget {
  const SplashScreen5({super.key});

  @override
  State<SplashScreen5> createState() => _SplashScreen5State();
}

class _SplashScreen5State extends State<SplashScreen5> with SingleTickerProviderStateMixin {
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
      Navigator.of(context).pushReplacementNamed('/onboarding');
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
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _bgController,
              builder: (context, _) {
                return Transform.scale(
                  scale: _bgScale.value,
                  child: Image.asset(
                    'assets/images/image splash screen 5.png',
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Headline at the top (centered)
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 60.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Chaque mission t’élève. Bâtis ta réputation, ouvre ton avenir.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.45),
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

                const Expanded(
                  flex: 3,
                  child: SizedBox.shrink(),
                ),

                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
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
                        const SizedBox(height: 2),
                        SizedBox(
                          width: 250,
                          height: 50,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF9800), Color(0xFFFFC107)],
                              ),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.22),
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
                                  _navigated = true;
                                  Navigator.of(context).pushReplacementNamed('/register');
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
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(4, (index) {
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
                    ),
                  ),
                ),
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}

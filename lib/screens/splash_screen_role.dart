import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'splash_screen_2.dart';
import 'screens_recruteurs/splash_screen1_recruteur.dart';

// --- COULEURS ET CONSTANTES ---
const Color backgroundColor = Colors.white;
const double headerHeight = 250.0;
const double footerHeight = 90.0;

// --- CHEMINS DES IMAGES (PNG) ---
const String headerImagePath = 'assets/images/header.png';
const String footerImagePath = 'assets/images/footer.png';
const String circleImagePath = 'assets/images/cercles.png';

// -----------------------------------------------------------------------------
// --- WIDGETS BASÉS SUR LES IMAGES (ALIGNÉS À register_screen.dart) ---
// -----------------------------------------------------------------------------

class BackgroundImageHeader extends StatelessWidget {
  final double height;
  final String imagePath;
  const BackgroundImageHeader({required this.height, required this.imagePath, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}

class BackgroundImageFooter extends StatelessWidget {
  final double height;
  final String imagePath;
  const BackgroundImageFooter({required this.height, required this.imagePath, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        alignment: Alignment.bottomCenter,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// --- CARTE DE SÉLECTION DE RÔLE ---
// -----------------------------------------------------------------------------

class RoleSelectionCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onSelect;
  final bool isSelected;

  const RoleSelectionCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.onSelect,
    required this.isSelected,
  });

  @override
  State<RoleSelectionCard> createState() => _RoleSelectionCardState();
}

class _RoleSelectionCardState extends State<RoleSelectionCard> {
  static const double _cardHeight = 340.0;
  static const double _iconCircleSize = 64.0;
  bool _hovered = false;

  void _setHovered(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final bool active = _hovered || widget.isSelected;
    final Color borderColor = active ? const Color(0xFF2563EB) : const Color(0xFFE5E7EB);

    return Expanded(
      child: MouseRegion(
        onEnter: (_) => _setHovered(true),
        onExit: (_) => _setHovered(false),
        child: GestureDetector(
          onTap: widget.onSelect,
          child: AnimatedScale(
            scale: active ? 1.03 : 1.0,
          duration: const Duration(milliseconds: 110),
          curve: Curves.easeOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 110),
              height: _cardHeight,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor, width: active ? 2.0 : 1.0),
                boxShadow: [
                  BoxShadow(
                    color: (active ? const Color(0xFF2563EB) : Colors.black)
                        .withOpacity(active ? 0.12 : 0.04),
                    blurRadius: active ? 14 : 8,
                    offset: Offset(0, active ? 6 : 4),
                  ),
                ],
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    width: _iconCircleSize,
                    height: _iconCircleSize,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(circleImagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(widget.icon, color: widget.iconColor, size: 30),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      widget.description,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.black54,
                        height: 1.5,
                         
                      ),
                      maxLines: 8,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// --- ÉCRAN PRINCIPAL : SPLASH ROLE ---
// -----------------------------------------------------------------------------

class SplashScreenRole extends StatelessWidget {
  const SplashScreenRole({super.key});

  void _selectRole(BuildContext context, String role) {
    if (role == 'JEUNE_PRESTATEUR') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SplashScreen2()),
      );
    } else if (role == 'RECRUTEUR') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SplashScreen1Recruteur()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String? selectedRole;
    final double screenHeight = MediaQuery.of(context).size.height;
    const double contentTopPosition = headerHeight - 40;
    final double contentAreaHeight = screenHeight - contentTopPosition - footerHeight;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: BackgroundImageHeader(
              height: headerHeight,
              imagePath: headerImagePath,
            ),
          ),
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BackgroundImageFooter(
              height: footerHeight,
              imagePath: footerImagePath,
            ),
          ),
          Positioned(
            top: contentTopPosition,
            left: 0,
            right: 0,
            child: SizedBox(
              height: contentAreaHeight,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Bienvenue sur Tji Teliman',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 320),
                          child: Text(
                            'La plateforme qui connecte les jeunes talents aux opportunités locales. Commençons par créer votre profil.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black,
                              height: 1.5,
                              fontWeight : FontWeight.w400
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RoleSelectionCard(
                            title: 'Jeune Prestataire',
                            description: 'Je cherche des missions temporaires pour gagner de l\'expérience et un revenu.',
                            icon: Icons.school_outlined,
                            iconColor: Colors.white,
                            isSelected: selectedRole == 'JEUNE_PRESTATEUR',
                            onSelect: () => setState(() { selectedRole = 'JEUNE_PRESTATEUR'; }),
                          ),
                          RoleSelectionCard(
                            title: 'Recruteur',
                            description: 'Je cherche des jeunes talents pour réaliser des missions ponctuelles, que ce soit pour mon entreprise ou à titre personnel.',
                            icon: Icons.work_outline,
                            iconColor: Colors.white,
                            isSelected: selectedRole == 'RECRUTEUR',
                            onSelect: () => setState(() { selectedRole = 'RECRUTEUR'; }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 220,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: selectedRole == null
                              ? null
                              : () => _selectRole(context, selectedRole!),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            disabledBackgroundColor: const Color(0xFF10B981).withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            elevation: 4,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Continuer',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



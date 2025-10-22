// Fichier : lib/widgets/custom_header.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- COULEURS ET CONSTANTES (à importer ou redéfinir) ---
const Color primaryBlue = Color(0xFF2563EB); 
const Color darkGrey = Colors.black54;

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? rightIcon; // Icône à droite (par exemple, la cloche pour notifications ou logo)
  final Widget? customRightWidget; // Peut être un logo ou une autre icône complexe
  final VoidCallback? onBack;
  final Widget? bottomWidget; // Pour la barre de recherche (facultatif)
  final bool useCompactStyle; // Nouveau: pour utiliser le style compact (comme CompactHeader)
  final Widget? leftWidget; // Nouveau: widget à gauche (comme avatar de profil)

  const CustomHeader({
    super.key,
    required this.title,
    this.rightIcon,
    this.customRightWidget,
    this.onBack,
    this.bottomWidget,
    this.useCompactStyle = false, // Par défaut, style normal
    this.leftWidget, // Widget à gauche (optionnel)
  });

  @override
  // Hauteur adaptée à la nouvelle structure Stack
  // 120.0 avec bottomWidget (header + corps)
  // 80.0 sans bottomWidget (header seulement)
  Size get preferredSize => Size.fromHeight(bottomWidget != null ? 120.0 : 80.0);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Header bleu fixe
        Container(
          height: 120,
          color: const Color(0xFF2e9dcd), // Couleur du header
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  // Bouton retour
                  GestureDetector(
                    onTap: onBack ?? () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 15),
                  
                  // Widget à gauche (avatar de profil, etc.)
                  if (leftWidget != null) ...[
                    leftWidget!,
                    const SizedBox(width: 10),
                  ],
                  
                  // Titre
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: useCompactStyle ? 20 : 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  // Icône de droite (ou Widget personnalisé)
                  if (customRightWidget != null)
                    customRightWidget!
                  else if (rightIcon != null)
                    Icon(rightIcon, color: Colors.white, size: 24),
                  
                  const SizedBox(width: 35), // Espace pour équilibrer
                ],
              ),
            ),
          ),
        ),
        
        // Corps avec coins arrondis
        Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFf6fcfc), // Couleur du corps
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(60),
                topRight: Radius.circular(60),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(60),
                topRight: Radius.circular(60),
              ),
              child: bottomWidget != null 
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 15.0),
                    child: bottomWidget!,
                  )
                : null,
            ),
          ),
        ),
      ],
    );
  }
}

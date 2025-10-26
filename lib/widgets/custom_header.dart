// Fichier : lib/widgets/custom_header.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Ne pas dépendre d'un écran précis ici; laisser les écrans fournir onBack si besoin

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
  final bool centerTitle; // Nouveau: permet d'aligner le titre à gauche au besoin

   const CustomHeader({
    super.key,
    required this.title,
    this.rightIcon,
    this.customRightWidget,
    this.onBack,
    this.bottomWidget,
    this.useCompactStyle = false, // Par défaut, style normal
    this.leftWidget, // Widget à gauche (optionnel)
     this.centerTitle = true, // Par défaut: titre centré
  });

  @override
  // Hauteur FIXE pour garantir l'espace du cadre arrondi sur toutes les pages
  // Même sans bottomWidget, on réserve 120px afin d'éviter que le body ne recouvre le cadre arrondi
  Size get preferredSize => const Size.fromHeight(130.0);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Header bleu fixe
        Container(
          height: 160,
          color: const Color(0xFF2f9bcf), // Couleur du header
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              child: Transform.translate(
                offset: const Offset(0, -16),
                child: Row(
                children: [
                  // Bouton retour
                  GestureDetector(
                    onTap: onBack ?? () {
                      final navigator = Navigator.of(context);
                      if (navigator.canPop()) {
                        navigator.pop();
                      }
                    },
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
                       textAlign: centerTitle ? TextAlign.center : TextAlign.left,
                    ),
                  ),
                  
                  // Icône de droite (ou Widget personnalisé)
                  if (customRightWidget != null)
                    customRightWidget!
                  else if (rightIcon != null)
                    Icon(rightIcon, color: Colors.white, size: 24),
                  
                  // Espace à droite: 0 si une icône est fournie, sinon 35 pour équilibrer
                  SizedBox(width: (customRightWidget != null || rightIcon != null) ? 0 : 35),
                ],
              ),
              ),
            ),
          ),
        ),
        
        // Corps avec coins arrondis
        Padding(
          padding: const EdgeInsets.only(top: 120.0),
          child: Container(
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFf6fcfc), // Couleur du corps
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(60),
                topRight: Radius.circular(60),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(60),
                topRight: Radius.circular(60),
              ),
              child: Stack(
                children: [
                  // Inner shadow en haut du cadre arrondi
                 
                ],
              ),
            ),
          ),
        ),

        // bottomWidget flottant entre le header bleu et le cadre arrondi
        if (bottomWidget != null)
          Positioned(
            left: 50,
            right: 50,
            top: 110,
            child: Material(
              color: Colors.transparent,
              elevation: 6,
              shadowColor: Colors.black54,
              borderRadius: BorderRadius.circular(25),
              child: bottomWidget!,
            ),
          ),
      ],
    );
  }
}

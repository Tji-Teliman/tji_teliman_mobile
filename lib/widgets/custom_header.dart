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

  const CustomHeader({
    super.key,
    required this.title,
    this.rightIcon,
    this.customRightWidget,
    this.onBack,
    this.bottomWidget,
  });

  @override
  // Ajustement de la hauteur pour garantir que 2 lignes de titre tiennent
  // 160.0 avec bottomWidget (comme avant)
  // 120.0 sans bottomWidget (augmentation légère pour 2 lignes + padding)
  Size get preferredSize => Size.fromHeight(bottomWidget != null ? 160.0 : 120.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, 
      backgroundColor: const Color(0xFF2f9bcf), // Couleur d'origine conservée
      toolbarHeight: 100, // Hauteur de la barre d'outils
      
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35), 
          bottomRight: Radius.circular(35),
        ),
      ),
      
      title: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Première ligne : Flèche de retour et icône de droite
            Row(
              children: [
                GestureDetector(
                  onTap: onBack ?? () => Navigator.of(context).pop(),
                  child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                ),
                const Spacer(),
                // Icône de droite (ou Widget personnalisé)
                if (customRightWidget != null)
                  customRightWidget!
                else if (rightIcon != null)
                  Icon(rightIcon, color: Colors.white, size: 24),
              ],
            ),
            const SizedBox(height: 10),
            // Deuxième ligne : Titre en bas
            Container(
              width: double.infinity,
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                // ⚠️ MODIFICATION CLÉ : Autorise l'affichage sur deux lignes
                maxLines: 2, 
                // Permet au texte de s'étendre au-delà de sa zone si nécessaire, 
                // mais maxLines: 2 gère le wrapping
                overflow: TextOverflow.ellipsis, // Coupe avec ... si plus de 2 lignes
                // Conserve TextAlign.center pour le titre court
                textAlign: TextAlign.center, 
              ),
            ),
          ],
        ),
      ),
      
      // Widget inférieur (Barre de recherche, si fournie)
      bottom: bottomWidget != null ? PreferredSize(
        preferredSize: const Size.fromHeight(50.0), 
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
          child: bottomWidget!,
        ),
      ) : null,
    );
  }
}

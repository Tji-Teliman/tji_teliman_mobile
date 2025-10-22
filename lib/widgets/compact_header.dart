// Fichier : lib/widgets/compact_header.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- COULEURS ET CONSTANTES ---
const Color darkBlueHeader = Color(0xFF2f9bcf); // Couleur du Header

class CompactHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? rightIcon; // Icône à droite (optionnelle)
  final Widget? customRightWidget; // Widget personnalisé à droite (optionnel)
  final VoidCallback? onBack;
  final List<Widget>? actions; // Actions supplémentaires (optionnelles)

  const CompactHeader({
    super.key,
    required this.title,
    this.rightIcon,
    this.customRightWidget,
    this.onBack,
    this.actions,
  });

  @override
  // Hauteur fixe de 80px comme chat_screen.dart
  Size get preferredSize => const Size.fromHeight(80.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: darkBlueHeader,
      automaticallyImplyLeading: false,
      elevation: 0,
      toolbarHeight: 80,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35), 
          bottomRight: Radius.circular(35),
        ),
      ),
      title: Row(
        children: <Widget>[
          // Flèche de retour
          GestureDetector(
            onTap: onBack ?? () => Navigator.of(context).pop(),
            child: const Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
            ),
          ),
          
          // Titre
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Widget personnalisé à droite (priorité sur rightIcon)
          if (customRightWidget != null)
            customRightWidget!
          else if (rightIcon != null)
            Icon(rightIcon, color: Colors.white, size: 24),
        ],
      ),
      actions: actions ?? const [
        // Actions par défaut (vide)
      ],
    );
  }
}

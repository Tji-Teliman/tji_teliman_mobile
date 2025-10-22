// ------------------------------------
// WIDGETS DE TÉLÉCHARGEMENT ET BOUTON
// ------------------------------------

import 'package:flutter/material.dart';
import 'package:tji_teliman_mobile/screens/screens_jeunes/profil_completion_screen.dart';

class idCardUploadSection extends StatelessWidget {
  const idCardUploadSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: lightGreyBorder, width: 1),
      ),
      child: InkWell(
        onTap: () {
          // Action de téléchargement
        },
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload_outlined, color: greyText, size: 35),
            SizedBox(height: 5),
            Text(
              'Televerser la photo de votre carte d\'identité',
              style: TextStyle(color: greyText),
            ),
          ],
        ),
      ),
    );
  }
}

class saveButton extends StatelessWidget {
  const saveButton();

  @override
  Widget build(BuildContext context) {
    // Bouton animé pour montrer l'effet Flutter
    return ElevatedButton(
      onPressed: () {
        // Action d'enregistrement
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero, // Important pour le dégradé
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5, // Ajout d'une ombre subtile
      ),
      child: Ink(
        decoration: BoxDecoration(
          // Dégradé pour le bouton (exactement le vert du design)
          gradient: const LinearGradient(
            colors: [primaryGreen, Color(0xFF00C890)], // Léger dégradé vert pour l'effet
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          width: double.infinity,
          height: 60,
          alignment: Alignment.center,
          child: const Text(
            'ENREGISTRER ET TERMINER',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
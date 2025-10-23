// ------------------------------------
// WIDGETS DE PROFIL ET CHAMPS
// ------------------------------------

import 'package:flutter/material.dart';
import 'package:tji_teliman_mobile/screens/screens_jeunes/profil_completion_screen.dart';

// ignore: unused_element
class profilePictureSection extends StatelessWidget {
  const profilePictureSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar avec une légère animation d'apparition
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 500),
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: primaryGreen.withOpacity(0.5), width: 2),
                ),
                child: const CircleAvatar(
                  radius: 40,
                  backgroundColor: primaryGreen,
                  child: Icon(Icons.person, size: 45, color: Colors.white),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        // Bouton Ajouter/Modifier
        OutlinedButton(
          onPressed: () {
            // Action pour la photo
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: lightGreyBorder, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          ),
          child: const Text(
            'Ajouter / Modifier la photo',
            style: TextStyle(
              color: primaryGreen,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}

class InputFieldsSection extends StatelessWidget {
  const InputFieldsSection({required TextEditingController dateOfBirthController, required TextEditingController firstNameController, required TextEditingController nameController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Champ Date de naissance
        profileInputField(
          label: 'Date de naissance',
          icon: Icons.calendar_today_outlined,
          onTap: () { /* Ouvre le sélecteur de date */ },
          isReadOnly: true,
        ),
        const SizedBox(height: 20),
        // Champ Localisation
        profileInputField(
          label: 'Localisation',
          icon: Icons.location_on_outlined,
          onTap: () { /* Ouvre la carte */ },
          isReadOnly: true,
        ),
        const SizedBox(height: 20),
        // Champ Compétences (Zone de texte multi-lignes)
        competencesInputField(),
      ],
    );
  }
}

class profileInputField extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isReadOnly;

  const profileInputField({
    required this.label,
    required this.icon,
    this.onTap,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: lightGreyBorder, width: 1),
      ),
      child: TextField(
        readOnly: isReadOnly,
        onTap: onTap,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(color: greyText),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          border: InputBorder.none,
          suffixIcon: Icon(icon, color: greyText),
        ),
      ),
    );
  }
}

class competencesInputField extends StatelessWidget {
  const competencesInputField();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // Hauteur ajustée pour la zone de texte
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: lightGreyBorder, width: 1),
      ),
      child: const TextField(
        maxLines: 5,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          hintText: 'Compétences',
          hintStyle: TextStyle(color: greyText),
          contentPadding: EdgeInsets.all(15),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
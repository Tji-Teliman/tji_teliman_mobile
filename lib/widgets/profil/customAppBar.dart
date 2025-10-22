// ------------------------------------
// WIDGETS D'ENTETE ET DE PROGRESSION
// ------------------------------------

import 'package:flutter/material.dart';
import 'package:tji_teliman_mobile/screens/screens_jeunes/profil_completion_screen.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      pinned: true,
      backgroundColor: Colors.white,
      expandedHeight: 180.0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(bottom: 20, left: 20),
        title: const Text(
          'Finaliser Mon Profil',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            color: primaryGreen, // Fond coloré pour le haut de l'App Bar
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 60.0, left: 20),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  // Action de retour
                },
              ),
            ),
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Container(
          color: Colors.white,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '50% Complété',
                  style: TextStyle(
                    color: greyText,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                AnimatedProgressBar(progress: 0.5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedProgressBar extends StatelessWidget {
  final double progress;

  const AnimatedProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    // Utiliser un AnimatedContainer pour simuler le défilement de la progression
    
    return Stack(
      children: [
        // Fond gris
        Container(
          height: 20,
          decoration: BoxDecoration(
            color: lightGreyBorder,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        // Barre de progression animée
        AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          height: 20,
          width: MediaQuery.of(context).size.width * 0.9 * progress, 
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [primaryBlue, primaryGreen],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ],
    );
  }
}

class ProgressMessage extends StatelessWidget {
  const ProgressMessage();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Text(
        'Plus que quelques étapes pour débloquer toutes les missions !',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: greyText,
          fontSize: 15,
        ),
      ),
    );
  }
}
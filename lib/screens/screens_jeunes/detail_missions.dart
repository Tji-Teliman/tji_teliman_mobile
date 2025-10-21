// Fichier : lib/screens/detail_missions.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ⚠️ Assurez-vous d'importer le bon chemin pour le CustomHeader
import '../../widgets/custom_header.dart'; 
import '../../widgets/custom_bottom_nav_bar.dart'; // Si vous avez une barre de navigation en bas

// --- COULEURS ET CONSTANTES (réutilisées depuis missions_screens.dart) ---
const Color primaryGreen = Color(0xFF10B981); 
const Color darkGreen = Color(0xFF00C78C); 
const Color primaryBlue = Color(0xFF2563EB); 
const Color bodyBackgroundColor = Color(0xFFF5F5F5); 

class DetailMissionScreen extends StatelessWidget {
  // Vous pouvez passer l'ID ou les données de la mission ici
  final Map<String, dynamic> missionData;

  const DetailMissionScreen({super.key, required this.missionData});

  // Helper pour afficher les étoiles
  Widget _buildRatingStars(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    
    for (int i = 0; i < 5; i++) {
      stars.add(
        Icon(
          i < fullStars ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 18,
        ),
      );
    }
    return Row(children: stars);
  }

  // Helper pour les informations sous la description (Localisation, Durée, Date Limite)
  Widget _buildDetailIcon({required IconData icon, required String label}) {
    return Column(
      children: [
        Icon(icon, color: primaryBlue, size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Helper pour les exigences clés (checkmarks)
  Widget _buildRequirement(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: primaryGreen, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      
      // 1. Header Personnalisé
      // Note: Le CustomHeader implémente PreferredSizeWidget, il est donc parfait pour 'appBar'
      appBar: CustomHeader(
        title: missionData['missionTitle'] ?? 'Aide Déménagement',
        customRightWidget: const Icon(
          Icons.warning_amber_outlined,
          color: Colors.white,
          size: 24,
        ),
        onBack: () => Navigator.of(context).pop(),
      ),

      // 2. Corps de la Page
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            
            // --- SECTION 1 : RECRUTEUR ET DESCRIPTION ---
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recruteur',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Infos Recruteur (Photo, Nom, Note)
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage('assets/images/amadou.jpg'), // ⚠️ Remplacer par la vraie image
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Amadou B.',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          _buildRatingStars(4.5), // Note 4.5/5
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Description de la Mission
                  Text(
                    'Description de la Mission',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    missionData['description'] ?? 
                      "Déménagement d'un appartement situé au 2e étage sans ascenseur. Aide au transport de cartons et de quelques meubles démontés jusqu'au camion de déménagement. Une autre personne sera présente pour prêter main-forte.\n\nRendez-vous à 9h.",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- SECTION 2 : EXIGENCES CLÉS ---
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Exigences Clés',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildRequirement('Force physique à sécurité'),
                  _buildRequirement('Disponibilité le matin'),
                  // Vous pouvez ajouter d'autres exigences ici
                ],
              ),
            ),
            
            const SizedBox(height: 20),

            // --- SECTION 3 : INFOS HORAIRES / LOCALISATION ---
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDetailIcon(
                    icon: Icons.location_on_outlined, 
                    label: missionData['location'] ?? 'Kalaban Coura',
                  ),
                  _buildDetailIcon(
                    icon: Icons.access_time, 
                    label: missionData['duration'] ?? 'Estimé: 3heures',
                  ),
                  _buildDetailIcon(
                    icon: Icons.calendar_today_outlined, 
                    label: missionData['dateLimit'] ?? 'Date Limite: 25/10/23',
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Le bouton "POSTULER À CETTE MISSION" est dans la bottomNavBar pour le fixer
            
          ],
        ),
      ),

      // 3. Bouton Fixe "Postuler" dans la BottomNavigationBar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Logique de postulation
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen, 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: Text(
                'POSTULER À CETTE MISSION',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'candidature_missions.dart';

const Color primaryGreen = Color(0xFF27AE60); // demandé: 27AE60
const Color bodyBackgroundColor = Color(0xFFf6fcfc);

class ProfilCandidatScreen extends StatelessWidget {
  final String name;
  final String motivation;
  final double rating; // ex: 4.8
  final List<String> competences;
  final String avatarAsset;
  final String missionTitle;

  const ProfilCandidatScreen({
    super.key,
    required this.name,
    required this.motivation,
    required this.rating,
    required this.competences,
    this.avatarAsset = 'assets/images/image_profil.png',
    this.missionTitle = 'Candidatures',
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double headerHeight = screenHeight * 0.33;

    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildHeader(context, headerHeight),
          ),

          Positioned(
            top: headerHeight - 40,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: bodyBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMessageCard(),
                      const SizedBox(height: 16),
                      _buildCompetencesCard(),
                      const SizedBox(height: 24),
                      _buildActions(context),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double height) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/header_home.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Top bar: back + title and hint link
          Positioned(
            top: 18,
            left: 12,
            right: 12,
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Profil de $name',
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Voir profil complet',
                          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),
          ),

          // Avatar + name + rating
          Positioned(
            top: height * 0.28,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(radius: 48, backgroundImage: AssetImage(avatarAsset)),
                const SizedBox(height: 8),
                Text(
                  name,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text('${rating.toStringAsFixed(1)}/5.0', style: GoogleFonts.poppins(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Message pour la mission', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Text(
              motivation,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87, height: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompetencesCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.workspace_premium_outlined, size: 18, color: Colors.black87),
                const SizedBox(width: 6),
                Text('Compétences', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87)),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: competences.map((c) => _chip(c)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: primaryGreen,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label, style: GoogleFonts.poppins(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 46,
            child: ElevatedButton(
              onPressed: () {
                _showResultDialog(
                  context,
                  title: 'Candidat sélectionné',
                  message: 'Votre sélection a été enregistrée avec succès.',
                  color: primaryGreen,
                  icon: Icons.check,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Sélectionner ce jeune', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 46,
            child: ElevatedButton(
              onPressed: () {
                _showResultDialog(
                  context,
                  title: 'Candidature rejetée',
                  message: 'Le rejet a été enregistré avec succès.',
                  color: const Color(0xFFFF3E3E).withOpacity(0.83),
                  icon: Icons.close,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF3E3E).withOpacity(0.83), // demandé: FF3E3E à 83% opacité
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Rejeter', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ],
    );
  }
  
  void _showResultDialog(
    BuildContext context, {
    required String title,
    required String message,
    required Color color,
    required IconData icon,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
                  child: Icon(icon, color: color, size: 30),
                ),
                const SizedBox(height: 12),
                Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => CandidatureMissionsScreen(missionTitle: missionTitle),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('OK', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}



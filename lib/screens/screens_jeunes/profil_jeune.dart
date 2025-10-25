import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/custom_bottom_nav_bar.dart';
import '../../../widgets/custom_menu.dart';
import 'home_jeune.dart';
import 'mes_candidatures.dart';
import 'message_conversation.dart';
import 'notifications.dart';
import 'mes_candidatures.dart';
import 'modifier_profil.dart';

// Couleurs utilisées (alignées sur home_jeune.dart)
const Color primaryBlue = Color(0xFF2563EB);
const Color primaryGreen = Color(0xFF10B981);
const Color bodyBackgroundColor = Color(0xFFf6fcfc);
const Color badgeOrange = Color(0xFFF59E0B);
const Color orangeBrand = Color(0xFFE67E22);

class ProfilJeuneScreen extends StatefulWidget {
  const ProfilJeuneScreen({super.key});

  @override
  State<ProfilJeuneScreen> createState() => _ProfilJeuneScreenState();
}

class _ProfilJeuneScreenState extends State<ProfilJeuneScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 2; // Onglet Profil

  // Données fictives conformes à la maquette
  final String fullName = 'Rama Konaré';
  final String role = 'Recruteur';
  final String email = 'ramatouyaya@gmail.com';
  final String phone = '+223 72 70 66 47';
  final String location = 'Bamako , Garantibougou';
  final String competences =
      'Livraisons , Cuisine , Evenementiel , Serveuse,\nBaby-sitting, Ménage, Vente de Magasin';
  final int missionsRealisees = 12;
  final String noteRecruteur = '4.8/5';

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double headerHeight = screenHeight * 0.33;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bodyBackgroundColor,
      drawer: CustomDrawer(
        userName: fullName,
        userProfile: 'Mon Profil',
      ),
      body: Stack(
        children: [
          // Header identique à home_jeune.dart
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildHeader(context, headerHeight),
          ),

          // Corps avec arrondi, positionné pour chevaucher le header
          Positioned(
            top: headerHeight - 50,
            left: 0,
            right: 0,
            bottom: 80,
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  color: bodyBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                width: screenWidth,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    screenWidth * 0.05,
                    22.0,
                    screenWidth * 0.05,
                    20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Informations personnelles'),
                      const SizedBox(height: 8),
                      _buildPersonalInfoCard(),
                      const SizedBox(height: 16),
                      _buildSectionTitle('Statistiques de missions'),
                      const SizedBox(height: 8),
                      _buildStatsCard(),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Barre de navigation inférieure
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNavBar(
              initialIndex: _selectedIndex,
              onItemSelected: (index) {
                if (index == _selectedIndex) return;
                if (index == 0) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomeJeuneScreen()),
                  );
                  return;
                }
                if (index == 1) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const MesCandidaturesScreen()),
                  );
                  return;
                }
                if (index == 3) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const MessageConversationScreen()),
                  );
                  return;
                }
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // Header adapté à la maquette du profil en réutilisant la logique/props
  Widget _buildHeader(BuildContext context, double height) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/header_home.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Ligne supérieure: flèche retour et titre centré
          Positioned(
            top: 16,
            left: 12,
            right: 12,
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Align(
                     alignment: Alignment.centerLeft,
                     child: GestureDetector(
                       behavior: HitTestBehavior.translucent,
                       onTap: () {
                         final navigator = Navigator.of(context);
                         if (navigator.canPop()) {
                           navigator.pop();
                         } else {
                           navigator.pushReplacement(
                             MaterialPageRoute(builder: (context) => const HomeJeuneScreen()),
                           );
                         }
                       },
                       child: const Padding(
                         padding: EdgeInsets.all(6.0),
                         child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                       ),
                     ),
                   ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Mon Profil',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20), // équilibre visuel
                ],
              ),
            ),
          ),
          // Avatar centré + nom + rôle
          Positioned(
            top: height * 0.18,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage('assets/images/image_profil.png'),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ModifierProfilScreen(
                                  initialPrenom: 'Rama',
                                  initialNom: 'Konaré',
                                  initialEmail: email,
                                  initialPhone: phone,
                                  initialLocation: location,
                                  initialCompetences: competences,
                                  fullName: fullName,
                                  role: 'Jeune_Prestauteur',
                                ),
                              ),
                            );
                          },
                          child: const Center(
                            child: Icon(Icons.edit, size: 14, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  fullName,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Jeune_Prestateur',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Carte avatar + nom + rôle (style proche de la maquette)
  Widget _buildAvatarCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: const AssetImage('assets/images/image_home.png'),
                backgroundColor: Colors.transparent,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: primaryBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit, size: 14, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullName,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  role,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoTile(
          icon: Icons.email_outlined,
          label: 'Email',
          value: email,
          tileColor: Colors.white,
          iconBg: orangeBrand.withOpacity(0.12),
          iconColor: orangeBrand,
        ),
        const SizedBox(height: 10),
        _infoTile(
          icon: Icons.call_outlined,
          label: 'Téléphone',
          value: phone,
          tileColor: Colors.white,
          iconBg: orangeBrand.withOpacity(0.12),
          iconColor: orangeBrand,
        ),
        const SizedBox(height: 10),
        _infoTile(
          icon: Icons.location_on_outlined,
          label: 'Localisation',
          value: location,
          tileColor: Colors.white,
          iconBg: orangeBrand.withOpacity(0.12),
          iconColor: orangeBrand,
        ),
        const SizedBox(height: 10),
        _infoTile(
          icon: Icons.workspace_premium_outlined,
          label: 'Compétences',
          value: competences,
          multiLine: true,
          tileColor: Colors.white,
          iconBg: orangeBrand.withOpacity(0.12),
          iconColor: orangeBrand,
        ),
      ],
    );
  }

  Widget _buildStatsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _statTile('Missions Realiser', missionsRealisees.toString()),
          _divider(),
          _statTile('Notes des Recruteur', noteRecruteur),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 1,
      color: const Color(0xFFEAEAEA),
      margin: const EdgeInsets.symmetric(horizontal: 12),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
    bool multiLine = false,
    Color? tileColor,
    Color? iconBg,
    Color? iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: tileColor ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: multiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBg ?? const Color(0xFFD9D9D9).withOpacity(0.0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor ?? orangeBrand),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



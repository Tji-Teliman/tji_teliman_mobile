import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Barre de navigation inférieure pour recruteur
import '../../widgets/custom_bottom_nav_bar_recruteur.dart';
// Menu latéral (même composant commun pour le moment)
import '../../widgets/custom_menu.dart';

// Réutilisation de certaines pages existantes tant que les versions recruteurs ne sont pas créées
import '../screens_jeunes/notifications.dart';
import '../screens_jeunes/liste_litige.dart';
import '../screens_jeunes/historique_paiement.dart';
import 'finaliser_profile_particulier.dart';
import 'publier_mission.dart';
import 'missions_recruteur.dart';
import 'paiement.dart';
import 'profil_recruteur.dart';
import 'message_conversation_recruteur.dart';

// --- COULEURS ---
const Color primaryGreen = Color(0xFF10B981);
const Color darkGreen = Color(0xFF069566);
const Color primaryBlue = Color(0xFF2563EB);
const Color badgeOrange = Color(0xFFF59E0B);
const Color cardColor = Color(0xFFF0F4F8);
const Color bodyBackgroundColor = Color(0xFFf6fcfc);

class HomeRecruteurScreen extends StatefulWidget {
  const HomeRecruteurScreen({super.key});

  @override
  State<HomeRecruteurScreen> createState() => _HomeRecruteurScreenState();
}

class _HomeRecruteurScreenState extends State<HomeRecruteurScreen> {
  bool _showProfileAlert = true;
  bool _hasPendingPayment = true; // Affiche l'alerte de paiement en attente
  int _selectedIndex = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Données statiques pour l'en-tête (selon la maquette)
  final String userName = "Amadou Bakagoyo !";
  final int missionsPubliees = 12;
  final String note = "3.7/5";

  void _completeProfile() {
    setState(() {
      _showProfileAlert = false;
    });
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const FinaliserProfileParticulier()),
    );
  }

  void _payWithOrangeMoney() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PaiementScreen(
          jeune: 'Ramatou konaré',
          mission: 'Aide Ménagere',
        ),
      ),
    );

    // Si le paiement est confirmé, masquer l'alerte
    if (result == true) {
      setState(() {
        _hasPendingPayment = false;
      });
    }
  }

  void _confirmCashPayment() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Confirmation du paiement en espèces.')),
    );
  }

  void _handleQuickAction(String action) {
    if (action == 'Publier une Mission') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const PublierMissionScreen()),
      );
      return;
    }
    if (action == 'Vos missions') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const MissionsRecruteurScreen()),
      );
      return;
    }
    if (action == 'Historiques Paiements') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const HistoriquePaiement()),
      );
      return;
    }
    if (action == 'Litige') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ListeLitige()),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Action rapide : $action')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double headerHeight = screenHeight * 0.33;

    final double cardSpacing = screenWidth * 0.03;

    double cardAspectRatio;
    if (screenHeight < 700) {
      cardAspectRatio = 1.4;
    } else if (screenHeight > 900) {
      cardAspectRatio = 0.85;
    } else {
      cardAspectRatio = 1.0;
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bodyBackgroundColor,

      drawer: CustomDrawer(
        userName: userName,
        userProfile: "Mon Profil",
      ),

      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildHeader(context, headerHeight),
          ),

          Positioned(
            top: headerHeight - 60,
            left: 0,
            right: 0,
            bottom: 80,
            child: Container(
              decoration: const BoxDecoration(
                color: bodyBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              width: screenWidth,
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  screenWidth * 0.05,
                  26.0,
                  screenWidth * 0.05,
                  20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (_hasPendingPayment)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: _buildPendingPaymentAlert(),
                      ),
                    if (_showProfileAlert)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: _buildProfileAlert(),
                      ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Aperçus',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),

                            Row(
                              children: <Widget>[
                                Flexible(
                                  flex: 1,
                                  child: IntrinsicHeight(
                                    child: _buildStatCard(
                                      icon: Icons.assignment_outlined,
                                      value: missionsPubliees.toString(),
                                      label: 'Missions publiées',
                                      color: primaryGreen,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Flexible(
                                  flex: 1,
                                  child: IntrinsicHeight(
                                    child: _buildStatCard(
                                      icon: Icons.star_outline,
                                      value: note,
                                      label: 'Note',
                                      color: badgeOrange,
                                      isNoteCard: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            Text(
                              'ACTIONS RAPIDES',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 6),

                            GridView.count(
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              crossAxisSpacing: cardSpacing,
                              mainAxisSpacing: cardSpacing,
                              childAspectRatio: cardAspectRatio,
                              physics: const NeverScrollableScrollPhysics(),
                              children: <Widget>[
                                _buildQuickActionCard(
                                  icon: Icons.add_circle_outline,
                                  label: 'Publier une Mission',
                                  onTap: () => _handleQuickAction('Publier une Mission'),
                                ),
                                _buildQuickActionCard(
                                  icon: Icons.assignment_turned_in,
                                  label: 'Vos missions',
                                  onTap: () => _handleQuickAction('Vos missions'),
                                ),
                                _buildQuickActionCard(
                                  icon: Icons.receipt_long,
                                  label: 'Historiques Paiements',
                                  onTap: () => _handleQuickAction('Historiques Paiements'),
                                ),
                                _buildQuickActionCard(
                                  icon: Icons.gavel,
                                  label: 'Litige',
                                  onTap: () => _handleQuickAction('Litige'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNavBarRecruteur(
              initialIndex: _selectedIndex,
              onItemSelected: (index) {
                if (index == 0) {
                  return; // Déjà sur Accueil
                }
                if (index == 1) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const MissionsRecruteurScreen()),
                  );
                  return;
                }
                if (index == 2) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const ProfilRecruteurScreen()),
                  );
                  return;
                }
                if (index == 3) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const MessageConversationScreen()),
                  );
                  return;
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS ---

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
          Positioned(
            right: 0,
            top: height * 0.05,
            bottom: 0,
            child: Opacity(
              opacity: 0.8,
              child: Image.asset(
                'assets/images/image_home.png',
                fit: BoxFit.contain,
                width: height * 0.6,
              ),
            ),
          ),

          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Transform.translate(
                    offset: const Offset(0, 10),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/LOGO_TJI_TELIMAN.png',
                          width: 50,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),

                  Transform.translate(
                    offset: const Offset(0, -5),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const NotificationsScreen(),
                              ),
                            );
                          },
                          child: const Icon(Icons.notifications_none, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                          child: const Icon(Icons.menu, color: Colors.white, size: 28),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: height * 0.42,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bienvenue sur Tji teliman',
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      userName,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileAlert() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: badgeOrange,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: badgeOrange.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PROFIL INCOMPLET:',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Veillez remplir vos informations personnelles',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 35,
            child: ElevatedButton(
              onPressed: _completeProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                elevation: 0,
              ),
              child: Text(
                'COMPLETER',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingPaymentAlert() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: badgeOrange,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: badgeOrange.withOpacity(0.35),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                'Paiement en attente',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Vous avez une mission terminée en attente de paiement. Veuillez procéder au paiement pour finaliser la mission.",
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 38,
            child: ElevatedButton(
              onPressed: _payWithOrangeMoney,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: badgeOrange,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                'Payer via l\'application',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: GestureDetector(
              onTap: _confirmCashPayment,
              child: Text(
                'Confirmer Paiement en Espèces.',
                style: GoogleFonts.poppins(
                  color: Colors.blue,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({required IconData icon, required String value, required String label, required Color color, bool isNoteCard = false}) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: const Color(0xFFe6f0f9),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: isNoteCard ? 26 : 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: isNoteCard ? 13 : 11,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({required IconData icon, required String label, required VoidCallback onTap}) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    double iconSize, fontSize, paddingSize, spacingSize;

    if (screenHeight < 700) {
      iconSize = screenWidth * 0.05;
      fontSize = screenWidth * 0.024;
      paddingSize = screenWidth * 0.01;
      spacingSize = screenHeight * 0.003;
    } else {
      iconSize = screenWidth * 0.08;
      fontSize = screenWidth * 0.030;
      paddingSize = screenWidth * 0.02;
      spacingSize = screenHeight * 0.008;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(paddingSize),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(screenWidth * 0.05),
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: primaryBlue, size: iconSize),
            ),
            SizedBox(height: spacingSize),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



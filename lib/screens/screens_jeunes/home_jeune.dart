import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ⚠️ Assurez-vous que ce chemin d'importation est correct !
import '../../../widgets/custom_bottom_nav_bar.dart';
// Import de la page missions
import 'missions_screen.dart';
// Import du menu personnalisé
import '../../../widgets/custom_menu.dart';
// Assurez-vous d'importer la page de profil cible si vous l'avez :
// import 'profile_screen.dart';
// Import de la page Discussions
import 'message_conversation.dart';
// Import de la page Notifications
import 'notifications.dart';
// Import de la page Mes Candidatures
import 'mes_candidatures.dart';

// --- COULEURS UTILISÉES DANS LE DESIGN ---
const Color primaryGreen = Color(0xFF10B981); // Vert principal du logo/home
const Color darkGreen = Color(0xFF069566);  // Vert plus foncé pour le dégradé (maintenu pour le boxShadow)
const Color primaryBlue = Color(0xFF2563EB); // Bleu pour les icônes d'action
const Color badgeOrange = Color(0xFFF59E0B); // Orange pour l'alerte de profil
const Color cardColor = Color(0xFFF0F4F8); // Couleur de fond des cartes (légèrement bleuté/gris)
const Color bodyBackgroundColor = Color(0xFFf6fcfc);

class HomeJeuneScreen extends StatefulWidget {
  const HomeJeuneScreen({super.key});

  @override
  State<HomeJeuneScreen> createState() => _HomeJeuneScreenState();
}

class _HomeJeuneScreenState extends State<HomeJeuneScreen> {
  // Simule l'état d'affichage de l'alerte de profil
  bool _showProfileAlert = true;
  int _selectedIndex = 0; // Index pour la navigation inférieure (Home)
  
  // Clé globale pour contrôler le drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Données statiques pour le profil
  final String userName = "Ramatou konaré !";
  final int missionsAccomplies = 12;
  final String note = "4.8/5";

  // Action lorsque l'utilisateur clique sur "COMPLETER"
  void _completeProfile() {
    setState(() {
      _showProfileAlert = false; // Le pop-up disparaît automatiquement
    });

    // ⚠️ Logique future : Rediriger vers la page de profil
    // if (mounted) {
    //    Navigator.of(context).push(
    //      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    //    );
    // }

    // Pour l'instant, on affiche une simple confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Alerte de profil masquée. Redirection vers le profil future."),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Fonction pour les actions rapides (missions disponibles, etc.)
  void _handleQuickAction(String action) {
    if (action == 'Missions Disponibles') {
      // Navigation vers la page missions
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const MissionsScreen()),
      );
    } else if (action == 'Mes Candidatures') {
      // Navigation vers la page mes candidatures
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const MesCandidaturesScreen()),
      );
    } else {
      // Pour les autres actions, afficher un message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Action rapide : $action cliquée."),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Variables responsives
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double headerHeight = screenHeight * 0.3;
    
    // Calculs responsives pour les cartes Actions Rapides
    final double cardSpacing = screenWidth * 0.03; // 3% de la largeur d'écran
    
    // Ratio adaptatif selon la taille d'écran
    double cardAspectRatio;
    if (screenHeight < 700) {
      // Petits écrans (iPhone SE, etc.) - cartes plus plates pour éviter débordement
      cardAspectRatio = 2.0; // Augmenté pour éviter le débordement
    } else if (screenHeight > 900) {
      // Grands écrans (iPhone Pro Max, etc.) - cartes plus grandes
      cardAspectRatio = 1.2;
    } else {
      // Écrans moyens
      cardAspectRatio = 1.5;
    }
    
    // Décalage responsive du body
    final double bodyOffset = _showProfileAlert 
      ? -(screenHeight * 0.04) // -4% de la hauteur d'écran
      : (screenHeight * 0.015); // +1.5% de la hauteur d'écran

    // ANCIENNE VARIABLE DE CHEVAUCHEMENT SUPPRIMÉE POUR FORCER LE DÉFILEMENT NORMAL
    // const double alertOverlap = -20.0;


    return Scaffold(
      key: _scaffoldKey, // Ajout de la clé pour contrôler le drawer
      backgroundColor: bodyBackgroundColor,
      
      // Ajout du drawer personnalisé
      drawer: CustomDrawer(
        userName: userName,
        userProfile: "Mon Profil",
      ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            // 1. Le Header Stylisé (défile)
            _buildHeader(context, headerHeight),

            // 2. L'ALERTE DE PROFIL INCOMPLET (ENTRE LE HEADER ET LE BODY)
            if (_showProfileAlert)
              Transform.translate(
                offset: const Offset(0, -55), // Décalage vers le haut pour rentrer dans le header
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                  child: _buildProfileAlert(),
                ),

              ),

            // 3. Corps principal
            Transform.translate(
              offset: Offset(0, bodyOffset), // Décalage responsive
              child: Padding(
                padding: EdgeInsets.fromLTRB(screenWidth * 0.05, 0.0, screenWidth * 0.05, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    // B. SECTION APERÇUS
                    Text(
                      'Aperçus',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: <Widget>[
                        // Carte 1: Missions Accomplies
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.check_circle_outline,
                            value: missionsAccomplies.toString(),
                            label: 'Missions Accomplies',
                            color: primaryGreen,
                          ),
                        ),
                        const SizedBox(width: 15),
                        // Carte 2: Note
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.star_outline,
                            value: note,
                            label: 'Note',
                            color: badgeOrange,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight < 700 ? screenHeight * 0.01 : screenHeight * 0.02),

                    // C. SECTION ACTIONS RAPIDES
                    Text(
                      'ACTIONS RAPIDES',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: screenHeight < 700 ? screenHeight * 0.005 : screenHeight * 0.01),

                    // Grille 2x2 des actions rapides
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: cardSpacing,
                      mainAxisSpacing: cardSpacing,
                      childAspectRatio: cardAspectRatio,
                      physics: const NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        _buildQuickActionCard(
                          icon: Icons.assignment_turned_in,
                          label: 'Missions Disponibles',
                          onTap: () => _handleQuickAction('Missions Disponibles'),
                        ),
                        _buildQuickActionCard(
                          icon: Icons.receipt_long,
                          label: 'Historiques Paiements',
                          onTap: () => _handleQuickAction('Historiques Paiements'),
                        ),
                        _buildQuickActionCard(
                          icon: Icons.library_books,
                          label: 'Mes Candidatures',
                          onTap: () => _handleQuickAction('Mes Candidatures'),
                        ),
                        _buildQuickActionCard(
                          icon: Icons.gavel,
                          label: 'Litige',
                          onTap: () => _handleQuickAction('Litige'),
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight < 700 ? screenHeight * 0.005 : screenHeight * 0.015),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // 3. BARRE DE NAVIGATION INFÉRIEURE (Footer)
      bottomNavigationBar: CustomBottomNavBar(
        initialIndex: _selectedIndex,
        onItemSelected: (index) {
          if (index == 0) {
            // Déjà sur Accueil
            return;
          }
          if (index == 1) {
            // Aller vers Mes Candidatures
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MesCandidaturesScreen()),
            );
            return;
          }
          if (index == 3) {
            // Aller vers Discussions
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
    );
  }

  // --------------------------------------------------------------------------
  // --- WIDGETS COMPOSANTS ---
  // --------------------------------------------------------------------------

  // Widget 1: Le Header Stylisé
  Widget _buildHeader(BuildContext context, double height) {
    // NOTE: Le Header utilise un Stack pour positionner ses éléments internes.
    // Il est lui-même dans le SingleChildScrollView.
    return Container(
      height: height,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        // --- DÉBUT MODIFICATION: Remplacement du dégradé par l'image de fond header_2.png ---
        image: const DecorationImage(
          image: AssetImage('assets/images/header_home.png'), // Nouvelle image de fond
          fit: BoxFit.cover, // S'assure que l'image couvre l'espace
        ),
        // --- FIN MODIFICATION DU FOND ---

        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            // L'ombre peut être ajustée car la couleur de fond a changé.
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Image de la dame (Photo du prestataire) - Positionnée en bas
          Positioned(
            right: 0,
            top: height * 0.3, // Commence plus bas
            bottom: 0, // Va jusqu'en bas
            child: Opacity(
              opacity: 0.8,
              child: Image.asset(
                'assets/images/image_home.png',
                fit: BoxFit.contain,
                width: height * 0.6,
              ),
            ),
          ),

          // 1. Logo (POSITIONNÉ EN HAUT)
          Positioned(
            top: 45, // Position du logo maintenue
            left: 20,
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
                      width: 50, // Utilise la largeur au lieu de la hauteur
                      fit: BoxFit.fitWidth, // Ajuste selon la largeur
                    ),
                  ),
            ),
          ),

          // 2. Icônes de notification et menu (POSITIONNÉES PLUS HAUT)
          Positioned(
            top: 45, // Position plus haute pour les icônes
            right: 20,
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
                    _scaffoldKey.currentState?.openDrawer(); // Ouvre le drawer avec la clé globale
                  },
                  child: const Icon(Icons.menu, color: Colors.white, size: 28),
                ),
              ],
            ),
          ),

          // 2. Texte de Bienvenue (POSITIONNÉ EN BAS DU HEADER)
          Positioned(
            top: height * 0.5, // Position encore plus bas dans le header
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Texte de Bienvenue
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

          // 3. Barre de Recherche (POSITIONNÉ EN BAS, LARGEUR RÉDUITE)
          Positioned(
            bottom: 5,
            left: 20,
            right: MediaQuery.of(context).size.width * 0.05, // Largeur réduite
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Recherche',
                  hintStyle: TextStyle(color: Colors.black54),
                  prefixIcon: Icon(Icons.search, color: primaryGreen),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  // Widget 2: Alerte de Profil Incomplet
  Widget _buildProfileAlert() {
    return Container(
      // Pas de marges horizontales car elles sont gérées par Padding
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

  // Widget 3: Carte de Statistique (Missions/Note) - Taille réduite
  Widget _buildStatCard({required IconData icon, required String value, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(10.0), // Réduit de 15.0 à 10.0
      decoration: BoxDecoration(
        color: const Color(0xFFe6f0f9), // Couleur #e6f0f9
        borderRadius: BorderRadius.circular(15), // Réduit de 15 à 12
         boxShadow: [
           BoxShadow(
             color: Colors.black.withOpacity(0.09),
             blurRadius: 8, // Réduit de 8 à 6
             offset: const Offset(0, 4), // Ombre seulement en bas
           ),
         ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Icon(icon, color: color, size: 22), // Réduit de 28 à 22
              const SizedBox(width: 6), // Réduit de 8 à 6
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 20, // Réduit de 24 à 20
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3), // Réduit de 5 à 3
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11, // Réduit de 13 à 11
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Widget 4: Carte d'Action Rapide Responsive
  Widget _buildQuickActionCard({required IconData icon, required String label, required VoidCallback onTap}) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    
    // Ajustements spécifiques pour iPhone SE
    double iconSize, fontSize, paddingSize, spacingSize;
    
    if (screenHeight < 700) {
      // iPhone SE - éléments plus petits pour éviter débordement
      iconSize = screenWidth * 0.05;
      fontSize = screenWidth * 0.025;
      paddingSize = screenWidth * 0.01;
      spacingSize = screenHeight * 0.003;
    } else {
      // Autres écrans
      iconSize = screenWidth * 0.08;
      fontSize = screenWidth * 0.032;
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


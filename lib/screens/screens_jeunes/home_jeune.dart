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
// Import des pages pour la navigation
import 'liste_litige.dart';
import 'historique_paiement.dart';
import 'finaliser_profil.dart';
import 'profil_jeune.dart';

// --- COULEURS UTILISÉES DANS LE DESIGN ---
const Color primaryGreen = Color(0xFF10B981); // Vert principal du logo/home
const Color darkGreen = Color(0xFF069566); // Vert plus foncé pour le dégradé (maintenu pour le boxShadow)
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

    // Navigation vers la page de finalisation du profil
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const FinaliserProfilScreen()),
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
    } else if (action == 'Historiques Paiements') {
      // Navigation vers la page historique paiements
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const HistoriquePaiement()),
      );
    } else if (action == 'Litige') {
      // Navigation vers la page liste litiges
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ListeLitige()),
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
    final double headerHeight = screenHeight * 0.33; // Augmenté de 0.3 à 0.35 pour faire monter le header
    
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
    
    // Décalage responsive du body - AJUSTÉ pour coller au header et inclure l'arrondi
    // Le body commence dans la zone du header pour créer l'effet de chevauchement arrondi.
    // La valeur choisie doit faire monter le body (cadre blanc) juste au-dessus
    // de la zone de la barre de recherche (pour l'effet d'arrondi) + gérer l'alerte.
    
    // Nous allons utiliser un 'Sliver' ou une approche similaire pour éviter la répétition
    // du 'Transform.translate' et encapsuler tout le body dans un seul cadre blanc.
    // MAIS comme la structure actuelle utilise 'SingleChildScrollView' et 'Transform.translate',
    // nous allons encapsuler le body dans un 'Container' arrondi.
    
    // Calcul pour positionner le bas du header (qui contient la barre de recherche) :
    // La barre de recherche est à 'bottom: 5' dans le header, donc la zone à arrondir
    // est juste au-dessus de 'bottom: 5'. On cible le bas du header.
    
    // Pour coller sans espace et faire l'arrondi, nous allons utiliser une hauteur fixe 
    // comme dans CustomHeader (80.0 pour l'arrondi de 60) et repositionner le body
    // en conséquence.
    
    // La méthode 'build' doit être modifiée pour utiliser la nouvelle structure.
    
    // Hauteur de l'arrondi (inspiré de CustomHeader): 80px 
    const double roundedBodyOverlap = 80.0;
    final double bodyInitialOffset = headerHeight - roundedBodyOverlap;
    
    // L'alerte de profil chevauche le header
    final double alertOffset = _showProfileAlert ? 55.0 : 0.0;
    // Le décalage total doit être ajusté pour l'alerte (si elle est affichée)
    // Nous allons gérer l'alerte DANS le header.
    
    // On simplifie l'approche: le header s'occupe de tout ce qui est bleu,
    // et le body s'occupe du cadre blanc arrondi.
    
    // --- NOUVELLE LOGIQUE DE MISE EN PAGE ---
    
    // Décalage nécessaire pour que le cadre blanc arrondi remonte sur le header
    // comme dans l'image. 
    // On va fixer la hauteur du header à 'headerHeight' et faire remonter le body.
    
    return Scaffold(
      key: _scaffoldKey, // Ajout de la clé pour contrôler le drawer
      backgroundColor: bodyBackgroundColor,
      
      // Ajout du drawer personnalisé
      drawer: CustomDrawer(
        userName: userName,
        userProfile: "Mon Profil",
      ),

      body: Stack(
        children: [
          // 1. Le Header Stylisé (FIXE EN HAUT)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildHeader(context, headerHeight),
          ),
          
          // 2. Le Corps Scrollable (EN DESSOUS DU HEADER)
          Positioned(
            top: headerHeight - 60, // Positionné pour que l'arrondi remonte sur le header
            left: 0,
            right: 0,
            bottom: 80, // Laisser de l'espace pour la barre de navigation (environ 80px)
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  color: bodyBackgroundColor, // Couleur du corps de la page
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60), // Rayon de 60px (comme CustomHeader)
                    topRight: Radius.circular(60), // Rayon de 60px (comme CustomHeader)
                  ),
                ),
                width: screenWidth, // Prend toute la largeur
                child: Padding(
                  // On retire le padding vertical supérieur et on ajoute un léger padding pour le contenu
                  // On ajoute un padding Top pour le contenu (au lieu de l'ancienne translation)
                  padding: EdgeInsets.fromLTRB(
                    screenWidth * 0.05, 
                    40.0, // Augmenté pour compenser le nouveau positionnement
                    screenWidth * 0.05, 
                    20.0 // Réduit pour optimiser l'espace
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                    
                      // 2. L'ALERTE DE PROFIL INCOMPLET (Déplacée et réajustée)
                      if (_showProfileAlert)
                        // On supprime le Transform.translate et on utilise un Padding pour l'espacement visuel
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: _buildProfileAlert(),
                        ),
                      // Le reste du body
                      
                      // B. SECTION APERÇUS
                      Text(
                        'Aperçus',
                        style: GoogleFonts.poppins(
                          fontSize: 18, // Augmenté de 14 à 18
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 15), // Réduit de 25 à 15

                      Row(
                        children: <Widget>[
                          // Carte 1: Missions Accomplies (même taille)
                          Flexible(
                            flex: 1, // Changé de 3 à 1 pour égaliser les tailles
                            child: IntrinsicHeight(
                              child: _buildStatCard(
                                icon: Icons.check_circle_outline,
                                value: missionsAccomplies.toString(),
                                label: 'Missions Accomplies',
                                color: primaryGreen,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          // Carte 2: Note (même taille)
                          Flexible(
                            flex: 1, // Changé de 2 à 1 pour égaliser les tailles
                            child: IntrinsicHeight(
                              child: _buildStatCard(
                                icon: Icons.star_outline,
                                value: note,
                                label: 'Note',
                                color: badgeOrange,
                                isNoteCard: true, // Indicateur pour le style spécial
                              ),
                            ),
                          ),
                        ],
                      ),

                       SizedBox(height: screenHeight < 700 ? screenHeight * 0.02 : screenHeight * 0.025), // Réduit significativement

                      // C. SECTION ACTIONS RAPIDES
                      Text(
                        'ACTIONS RAPIDES',
                        style: GoogleFonts.poppins(
                          fontSize: 18, // Augmenté de 14 à 18
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                       SizedBox(height: screenHeight < 700 ? screenHeight * 0.01 : screenHeight * 0.015), // Réduit significativement

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

                      SizedBox(height: screenHeight < 700 ? screenHeight * 0.02 : screenHeight * 0.03), // Espacement final réduit
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // 3. Barre de Navigation (FIXE EN BAS)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNavBar(
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
                if (index == 2) {
                  // Aller vers Profil
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const ProfilJeuneScreen()),
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
          ),
        ],
      ),
    );
  }

// --------------------------------------------------------------------------
// --- WIDGETS COMPOSANTS ---
// --------------------------------------------------------------------------

// Widget 1: Le Header Stylisé (MODIFIÉ)
// Le header n'a plus de coins arrondis en bas, il est plein.
// L'arrondi est maintenant géré par le corps principal qui remonte.
  Widget _buildHeader(BuildContext context, double height) {
    // NOTE: Le Header utilise un Stack pour positionner ses éléments internes.
    // Il est lui-même dans le SingleChildScrollView.
    return Container(
      // La hauteur est conservée pour maintenir la taille du header.
      height: height, 
      width: double.infinity,
      // On retire le 'clipBehavior: Clip.antiAlias' pour éviter de couper l'ombre
      // sur les côtés s'il y en avait, mais il est préférable de le laisser si le 
      // design final l'exige. Retiré pour l'instant car l'image n'a pas besoin d'arrondi.
      
      decoration: BoxDecoration(
        // --- MODIFICATION: Remplacement du dégradé par l'image de fond header_home.png ---
        image: const DecorationImage(
          image: AssetImage('assets/images/header_home.png'), // Nouvelle image de fond
          fit: BoxFit.cover, // S'assure que l'image couvre l'espace
        ),
        // --- MODIFICATION: SUPPRESSION de l'arrondi en BAS ---
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(0), // Retiré
          topRight: Radius.circular(0), // Retiré
          bottomLeft: Radius.circular(0), // Retiré
          bottomRight: Radius.circular(0), // Retiré
        ),
        // On laisse le BoxShadow pour l'esthétique générale
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
          // Image de la dame (Photo du prestataire) - Positionnée plus haut
          Positioned(
            right: 0,
            top: height * 0.05, // Monté de height * 0.3 à height * 0.2 pour être plus haut
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

          // 1. Logo et Icônes (POSITIONNÉS EN HAUT SUR LA MÊME LIGNE)
          Positioned(
            top: 20, // Descendu de 10 à 20 pour le logo
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo à gauche (position maintenue)
                  Transform.translate(
                    offset: const Offset(0, 10), // Descendre le logo de 10px
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
                  
                  // Icônes à droite (montées un peu plus haut)
                  Transform.translate(
                    offset: const Offset(0, -5), // Monté de 5px vers le haut
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

          // 2. Texte de Bienvenue (POSITIONNÉ POUR ÉQUILIBRER L'ESPACE)
          Positioned(
            top: height * 0.42, // Ajusté de height * 0.35 à height * 0.42 pour équilibrer
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

        ],
      ),
    );
  }
  
  // Widget 2: Alerte de Profil Incomplet
  // ... (PAS DE MODIFICATION) ...
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
  // ... (PAS DE MODIFICATION) ...
  Widget _buildStatCard({required IconData icon, required String value, required String label, required Color color, bool isNoteCard = false}) {
    return Container(
      padding: const EdgeInsets.all(15.0), // Diminué de 18.0 à 15.0
      decoration: BoxDecoration(
        color: const Color(0xFFe6f0f9), // Couleur #e6f0f9
        borderRadius: BorderRadius.circular(18), // Diminué de 20 à 18
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.09),
              blurRadius: 10, // Diminué de 12 à 10
              offset: const Offset(0, 4), // Ombre seulement en bas
            ),
          ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Icon(icon, color: color, size: 26), // Diminué de 28 à 26
              const SizedBox(width: 6), // Réduit de 8 à 6
              Flexible(
                child: Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: isNoteCard ? 26 : 24, // Plus grand pour la carte Note
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6), // Diminué de 8 à 6
          Center( // Wrapper Center pour centrer uniquement le texte du label
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: isNoteCard ? 13 : 11, // Tailles différentes
                color: Colors.black, // Noir pour les deux cartes
                fontWeight: FontWeight.bold, // Même gras pour les deux cartes
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1, // Limité à une seule ligne
            ),
          ),
        ],
      ),
    );
  }

  // Widget 4: Carte d'Action Rapide Responsive
  // ... (PAS DE MODIFICATION) ...
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
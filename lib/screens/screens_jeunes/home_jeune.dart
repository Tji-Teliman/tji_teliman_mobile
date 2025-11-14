import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ⚠️ Assurez-vous que ce chemin d'importation est correct !
import '../../../widgets/custom_bottom_nav_bar.dart';
// Import de la page missions
import 'missions_screen.dart';
// Import du menu personnalisé
import '../../../widgets/custom_menu.dart';
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
// Import des services
import '../../../services/user_service.dart';
import '../../../services/token_service.dart';
import '../../../services/profile_service.dart';
import '../../../services/message_service.dart';

// --- COULEURS UTILISÉES DANS LE DESIGN ---
const Color primaryGreen = Color(0xFF10B981); // Vert principal du logo/home
const Color darkGreen = Color(0xFF069566); // Vert plus foncé pour le dégradé (maintenu pour le boxShadow)
const Color primaryBlue = Color(0xFF2563EB); // Bleu pour les icônes d'action
const Color badgeOrange = Color(0xFFF59E0B); // Orange pour l'alerte de profil
const Color notificationBadgeColor = Color(0xFFE11D48); // Rouge pour les notifications
const Color cardColor = Color(0xFFF0F4F8); // Couleur de fond des cartes (légèrement bleuté/gris)
const Color bodyBackgroundColor = Color(0xFFf6fcfc);

class HomeJeuneScreen extends StatefulWidget {
  const HomeJeuneScreen({super.key});

  @override
  State<HomeJeuneScreen> createState() => _HomeJeuneScreenState();
}

class _HomeJeuneScreenState extends State<HomeJeuneScreen> {
  // État d'affichage de l'alerte de profil
  bool _showProfileAlert = true;
  int _selectedIndex = 0;
  
  // Clé globale pour contrôler le drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Données dynamiques pour le profil
  String userName = "";
  int missionsAccomplies = 0;
  String note = "0.0/5";
  bool _isLoading = true;
  bool _hasError = false;
  int _unreadNotificationsCount = 0;
  Timer? _notificationBadgeTimer;
  bool _isFetchingUnreadNotifications = false;
  int _unreadMessagesCount = 0;
  bool _isFetchingUnreadMessages = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadUnreadNotificationsCount();
    _loadUnreadMessagesCount();
    _notificationBadgeTimer = Timer.periodic(const Duration(seconds: 45), (_) {
      _loadUnreadNotificationsCount();
    });
  }

  @override
  void dispose() {
    _notificationBadgeTimer?.cancel();
    super.dispose();
  }

  // Charger les données de l'utilisateur depuis le backend
  Future<void> _loadUserData() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      print('🔄 Chargement des données utilisateur...');

      // Récupérer le nom depuis le stockage local
      final storedUserName = await TokenService.getUserName();
      if (storedUserName != null && storedUserName.isNotEmpty) {
        userName = storedUserName;
      } else {
        // Si pas de nom stocké, on utilise une valeur par défaut temporaire
        userName = "Jeune Prestataire";
      }

 // Charger les missions accomplies
final missionsResponse = await UserService.getMesMissionsAccomplies();
if (missionsResponse.success) {
  missionsAccomplies = missionsResponse.data.nombreMissions;
}

      // Charger la moyenne de notation
      print('📡 Récupération de la moyenne de notation...');
      final notationResponse = await UserService.getMoyenneNotation();
      if (notationResponse.success && notationResponse.data != null) {
        final moyenne = notationResponse.data!.moyenne;
        note = "${moyenne.toStringAsFixed(1)}/5";
        print('✅ Moyenne de notation: $note');
      } else {
        print('ℹ️ Aucune notation trouvée: ${notationResponse.message}');
        note = "0.0/5";
      }

      // Vérifier la complétion du profil côté backend
      try {
        final profil = await ProfileService.getMonProfil();
        final data = profil['data'] as Map<String, dynamic>?;
        bool complete = false;
        if (data != null) {
          // Photo (String ou Map avec url/path)
          final rawPhoto = data['photo'] ?? data['urlPhoto'];
          String photoStr = '';
          if (rawPhoto is Map) {
            photoStr = (rawPhoto['url'] ?? rawPhoto['path'] ?? rawPhoto['value'] ?? '').toString();
          } else if (rawPhoto != null) {
            photoStr = rawPhoto.toString();
          }
          final hasPhoto = photoStr.trim().isNotEmpty;

          // Date de naissance
          final hasDob = data['dateNaissance']?.toString().isNotEmpty == true;

          // Adresse
          final hasAdresse = data['adresse']?.toString().isNotEmpty == true;

          // Alerte disparaît si AU MOINS l'un des deux est présent: photo OU dateNaissance
          complete = hasPhoto || hasDob;
        }
        _showProfileAlert = !complete;
      } catch (e) {
        // En cas d'erreur backend, on laisse l'alerte affichée
        _showProfileAlert = true;
      }

    } catch (e) {
      print('❌ Erreur lors du chargement des données: $e');
      setState(() {
        _hasError = true;
      });
      // On garde les valeurs par défaut en cas d'erreur
      userName = "Jeune Prestataire";
      missionsAccomplies = 0;
      note = "0.0/5";
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Action lorsque l'utilisateur clique sur "COMPLETER"
  void _completeProfile() {
    setState(() {
      _showProfileAlert = false;
    });

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const FinaliserProfilScreen()),
    ).then((_) {
      // Recharger les données après retour du profil
      _loadUserData();
    });
  }

  // Fonction pour les actions rapides (missions disponibles, etc.)
  void _handleQuickAction(String action) {
    if (action == 'Missions Disponibles') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const MissionsScreen()),
      );
    } else if (action == 'Mes Candidatures') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const MesCandidaturesScreen()),
      );
    } else if (action == 'Historiques Paiements') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const HistoriquePaiement()),
      );
    } else if (action == 'Litige') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ListeLitige()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Action rapide : $action cliquée."),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _loadUnreadNotificationsCount() async {
    if (_isFetchingUnreadNotifications) return;
    _isFetchingUnreadNotifications = true;
    try {
      final count = await UserService.getUnreadNotificationsCount();
      if (!mounted) return;
      setState(() {
        _unreadNotificationsCount = count;
      });
    } catch (e) {
      // Ignore l'erreur mais consigne dans la console pour debug
      debugPrint('Erreur chargement notifications non lues: $e');
    } finally {
      _isFetchingUnreadNotifications = false;
    }
  }

  Future<void> _loadUnreadMessagesCount() async {
    if (_isFetchingUnreadMessages) return;
    _isFetchingUnreadMessages = true;
    try {
      final count = await MessageService.getTotalUnreadMessagesCount();
      if (!mounted) return;
      setState(() {
        _unreadMessagesCount = count;
      });
    } catch (e) {
      debugPrint('Erreur chargement messages non lus: $e');
    } finally {
      _isFetchingUnreadMessages = false;
    }
  }

  // Widget pour l'indicateur de chargement
  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: primaryGreen,
          ),
          const SizedBox(height: 16),
          Text(
            'Chargement de vos données...',
            style: GoogleFonts.poppins(
              color: Colors.black54,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // Widget pour l'état d'erreur
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'Erreur de chargement',
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Impossible de charger vos données',
            style: GoogleFonts.poppins(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadUserData,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
            ),
            child: Text(
              'Réessayer',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
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
    
    const double roundedBodyOverlap = 80.0;
    
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bodyBackgroundColor,
      
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
                    // Alerte FIXE (hors zone scrollable) — masquée pendant le chargement
                    if (_showProfileAlert && !_isLoading)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: _buildProfileAlert(),
                      ),
                    
                    // Contenu scrollable avec états de chargement/erreur
                    Expanded(
                      child: _isLoading 
                          ? _buildLoadingIndicator()
                          : _hasError
                              ? _buildErrorState()
                              : SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      // B. SECTION APERÇUS
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
                                          // Carte 1: Missions Accomplies
                                          Flexible(
                                            flex: 1,
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
                                          // Carte 2: Note
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
                                      
                                      // C. SECTION ACTIONS RAPIDES
                                      Text(
                                        'ACTIONS RAPIDES',
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      
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
          
          // 3. Barre de Navigation (FIXE EN BAS)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNavBar(
              initialIndex: _selectedIndex,
              unreadMessagesCount: _unreadMessagesCount,
              onItemSelected: (index) {
                if (index == 0) {
                  return;
                }
                if (index == 1) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const MesCandidaturesScreen()),
                  );
                  return;
                }
                if (index == 2) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const ProfilJeuneScreen()),
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

// --------------------------------------------------------------------------
// --- WIDGETS COMPOSANTS ---
// --------------------------------------------------------------------------

// Widget 1: Le Header Stylisé
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
        // Image de la dame (Photo du prestataire)
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

        // 1. Logo et Icônes
        Positioned(
          top: 20,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo à gauche
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
                
                // Icônes à droite
                Transform.translate(
                  offset: const Offset(0, -5),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const NotificationsScreen(),
                            ),
                          );
                          if (!mounted) return;
                          _loadUnreadNotificationsCount();
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Icon(Icons.notifications_none, color: Colors.white, size: 28),
                            if (_unreadNotificationsCount > 0)
                              Positioned(
                                top: -6,
                                right: -6,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: notificationBadgeColor,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.white, width: 1.2),
                                  ),
                                  child: Text(
                                    _unreadNotificationsCount > 99
                                        ? '99+'
                                        : _unreadNotificationsCount.toString(),
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
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

        // 2. Texte de Bienvenue
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
                    'Bienvenue sur Tji Teliman',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    userName.isNotEmpty ? userName : "Chargement...",
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

  // Widget 3: Carte de Statistique (Missions/Note)
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

  // Widget 4: Carte d'Action Rapide Responsive
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
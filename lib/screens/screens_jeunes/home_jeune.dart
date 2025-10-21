import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ⚠️ Assurez-vous que ce chemin d'importation est correct !
import '../../../widgets/custom_bottom_nav_bar.dart'; 
// Assurez-vous d'importer la page de profil cible si vous l'avez :
// import 'profile_screen.dart'; 

// --- COULEURS UTILISÉES DANS LE DESIGN ---
const Color primaryGreen = Color(0xFF10B981); // Vert principal du logo/home
const Color darkGreen = Color(0xFF069566);  // Vert plus foncé pour le dégradé
const Color primaryBlue = Color(0xFF2563EB); // Bleu pour les icônes d'action
const Color badgeOrange = Color(0xFFF59E0B); // Orange pour l'alerte de profil
const Color cardColor = Color(0xFFF0F4F8); // Couleur de fond des cartes (légèrement bleuté/gris)
const Color bodyBackgroundColor = Color(0xFFF5F5F5); 

class HomeJeuneScreen extends StatefulWidget {
  const HomeJeuneScreen({super.key});

  @override
  State<HomeJeuneScreen> createState() => _HomeJeuneScreenState();
}

class _HomeJeuneScreenState extends State<HomeJeuneScreen> {
  // Simule l'état d'affichage de l'alerte de profil
  bool _showProfileAlert = true; 
  int _selectedIndex = 0; // Index pour la navigation inférieure (Home)
  
  // Données statiques pour le profil
  final String userName = "Ramatou konaré";
  final int missionsAccomplies = 12;
  final String note = "4.8/5";

  // Action lorsque l'utilisateur clique sur "COMPLETER"
  void _completeProfile() {
    setState(() {
      _showProfileAlert = false; // Le pop-up disparaît automatiquement
    });

    // ⚠️ Logique future : Rediriger vers la page de profil
    // if (mounted) {
    //   Navigator.of(context).push(
    //     MaterialPageRoute(builder: (context) => const ProfileScreen()),
    //   );
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
     ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Action rapide : $action cliquée."),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calcule la hauteur pour le header (environ 30% de l'écran)
    final double headerHeight = MediaQuery.of(context).size.height * 0.3; 
    
    // ANCIENNE VARIABLE DE CHEVAUCHEMENT SUPPRIMÉE POUR FORCER LE DÉFILEMENT NORMAL
    // const double alertOverlap = -20.0; 
    

    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            
            // 1. Le Header Stylisé (défile)
            _buildHeader(context, headerHeight),
            
            // 2. L'ALERTE DE PROFIL INCOMPLET EST DANS LE FLUX DE DÉFILEMENT (défile avec le contenu)
            if (_showProfileAlert)
              Padding(
                // L'alerte se trouve dans un Padding pour la centrer horizontalement
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                // Nous n'utilisons plus Transform.translate, donc l'alerte doit bouger
                // de manière naturelle avec le SingleChildScrollView.
                child: _buildProfileAlert(),
              ),

            // 3. Corps principal 
            Padding(
              // Si l'alerte est affichée, le Padding supérieur peut être réduit.
              // S'il est masqué, nous pourrions avoir besoin d'un peu d'espace.
              // J'utilise 20.0 pour laisser un peu d'espace entre l'alerte ou le Header
              // et la section APERÇUS.
              padding: EdgeInsets.fromLTRB(20.0, _showProfileAlert ? 0.0 : 20.0, 20.0, 0.0), 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  
                  // B. SECTION APERÇUS
                  Text(
                    'APERÇUS',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
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
                  
                  const SizedBox(height: 30),
                  
                  // C. SECTION ACTIONS RAPIDES
                  Text(
                    'ACTIONS RAPIDES',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  // Grille 2x2 des actions rapides
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 15.0,
                    mainAxisSpacing: 15.0,
                    childAspectRatio: 0.95, 
                    physics: const NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      _buildQuickActionCard(
                        icon: Icons.assignment, 
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
                  
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
      
      // 3. BARRE DE NAVIGATION INFÉRIEURE (Footer)
      bottomNavigationBar: CustomBottomNavBar(
        initialIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
            // ⚠️ Logique future de navigation entre les pages
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
        gradient: const LinearGradient(
          colors: [primaryGreen, darkGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Image du prestataire (Arrière-plan)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Opacity(
              opacity: 0.8,
              child: Image.asset(
                'assets/images/image_home.png',
                fit: BoxFit.cover,
                height: height,
              ),
            ),
          ),
          
          // 1. Logo et icônes de notification/menu (POSITIONNÉ EN HAUT)
          Positioned(
            top: 40, // Padding top équivalent au Padding de la Column précédente
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // LOGO DANS UN CERCLE - TAILLE AUGMENTÉE
                Container(
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
                  padding: const EdgeInsets.all(7), 
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/LOGO_TJI_TELIMAN.png', 
                      height: 45, 
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                const Row(
                  children: [
                    Icon(Icons.notifications_none, color: Colors.white, size: 28),
                    SizedBox(width: 15),
                    Icon(Icons.menu, color: Colors.white, size: 28),
                  ],
                ),
              ],
            ),
          ),
          
          // 2. Texte de Bienvenue et Barre de Recherche (POSITIONNÉ EN BAS)
          Positioned(
            // NOTE: On laisse de la place en bas pour que la barre de recherche soit visible.
            bottom: 5, 
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
                
                const SizedBox(height: 10), // Espace avant la barre de recherche

                // Barre de Recherche 
                Container(
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
                  'PROFIL INCOMPLET :',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Finalisez votre profil pour plus d\'opportunités !',
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
                  color: badgeOrange,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Widget 3: Carte de Statistique (Missions/Note)
  Widget _buildStatCard({required IconData icon, required String value, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(15.0),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 8),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  // Widget 4: Carte d'Action Rapide
  Widget _buildQuickActionCard({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15.0),
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
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: primaryBlue, size: 30),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
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

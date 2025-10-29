import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/screens_recruteurs/missions_recruteur.dart';
import '../screens/screens_recruteurs/historique_paiement_recruteur.dart';
import '../screens/screens_recruteurs/message_conversation_recruteur.dart';
import '../screens/screens_jeunes/parametre.dart';
import '../screens/screens_jeunes/centre_aide.dart';

// --- COULEURS UTILISÉES DANS LE DESIGN (réutilisées depuis votre code) ---
const Color primaryGreen = Color(0xFF10B981); // Couleur principale du thème
const Color badgeOrange = Color(0xFFF59E0B); // Couleur du bouton de déconnexion

// Définition des éléments du menu
class DrawerItemRecruteur {
  final String title;
  final IconData icon;

  DrawerItemRecruteur({required this.title, required this.icon});
}

// Données statiques pour le menu recruteur
final List<DrawerItemRecruteur> drawerItemsRecruteur = [
  // Icônes ajustées pour correspondre au style de l'image (légèrement plus épaisses)
  DrawerItemRecruteur(title: 'Mes Missions', icon: Icons.assignment_outlined), 
  DrawerItemRecruteur(title: 'Historique', icon: Icons.bar_chart_outlined),
  DrawerItemRecruteur(title: 'Messages', icon: Icons.chat_bubble_outline),
  DrawerItemRecruteur(title: 'Paramètres', icon: Icons.settings_outlined),
  DrawerItemRecruteur(title: 'Aide', icon: Icons.help_outline),
];

class CustomDrawerRecruteur extends StatelessWidget {
  final String userName;
  final String userProfile; // Titre "Mon Profil"

  const CustomDrawerRecruteur({
    super.key,
    this.userName = "Amadou Bakagoyo",
    this.userProfile = "Mon Profil",
  });

  // Action de déconnexion simulée
  void _logout(BuildContext context) {
    // La navigation est gérée par le contexte de l'écran principal
    Navigator.of(context).pop(); // Ferme le menu
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Déconnexion en cours..."),
        duration: Duration(seconds: 1),
      ),
    );
    // Ajoutez ici la logique de déconnexion (navigation vers l'écran de connexion)
  }

  // Widget utilitaire pour les tuiles du menu
  Widget _buildDrawerTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      // Taille des icônes ajustée pour être visible comme sur l'image
      leading: Icon(icon, color: Colors.black87, size: 28), 
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          // Poids ajusté pour être en gras comme sur l'image
          fontWeight: FontWeight.w700, 
          color: Colors.black87,
        ),
      ),
      onTap: onTap,
    );
  }

  void _handleNavigation(BuildContext context, String title) {
    final String key = title.toLowerCase();
    Navigator.of(context).pop(); // Close the drawer first
    
    // Navigate to the appropriate screen
    if (key.contains('mission')) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const MissionsRecruteurScreen()),
      );
      return;
    }
    if (key.contains('histor')) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const HistoriquePaiementRecruteur()),
      );
      return;
    }
    if (key.contains('message')) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const MessageConversationScreen()),
      );
      return;
    }
    if (key.contains('param')) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const Parametre()),
      );
      return;
    }
    if (key.contains('aide')) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const CentreAide()),
      );
      return;
    }
    // Fallback: rester et fermer simplement le drawer
  }

  @override
  Widget build(BuildContext context) {
    // Définit la hauteur du menu (par exemple, 80% de la hauteur de l'écran)
    final double screenHeight = MediaQuery.of(context).size.height;
    // La hauteur du menu est définie manuellement pour être plus petite que 100%
    final double menuHeight = screenHeight * 0.70; 
    // Définit la largeur du menu (par exemple, 75% de la largeur de l'écran)
    final double menuWidth = MediaQuery.of(context).size.width * 0.75;

    return Container(
      width: menuWidth, 
      height: menuHeight, 
      
      // Ajout de la bordure supérieure arrondie
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25), // Arrondi de 25px en haut à gauche
        ),
      ),
      
      // Utilisation d'un widget `ClipRRect` pour s'assurer que le contenu (comme le Header)
      // ne dépasse pas l'arrondi du container.
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
        ),
        child: Column(
          children: <Widget>[
            // 1. HEADER DU PROFIL
            Container(
              height: 130, // Hauteur augmentée pour éviter le débordement
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Icône de fermeture en haut à droite
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(); // Ferme le menu
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.black54,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  
                  // Section profil avec photo et nom
                  Row(
                    children: [
                      // Photo de profil
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryGreen,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            userName.substring(0, 1),
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      
                      // Informations du profil
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Mon Profil
                            Text(
                              userProfile, 
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            // Nom de l'utilisateur
                            Text(
                              userName,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // 2. LISTE DES ÉLÉMENTS DU MENU
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero, 
                itemCount: drawerItemsRecruteur.length,
                itemBuilder: (context, index) {
                  final item = drawerItemsRecruteur[index];
                  return _buildDrawerTile(
                    icon: item.icon,
                    title: item.title,
                    onTap: () => _handleNavigation(context, item.title),
                  );
                },
              ),
            ),

            // 3. BOUTON DE DÉCONNEXION FIXE EN BAS
            Container(
              width: double.infinity,
              height: 70, // Hauteur ajustée pour le style (y compris le safe area)
              decoration: BoxDecoration(
                color: badgeOrange, 
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                top: false, // Ignorer le safe area en haut de ce Container
                child: TextButton.icon(
                  onPressed: () => _logout(context),
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 24,
                  ),
                  label: Text(
                    'Déconnexion',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


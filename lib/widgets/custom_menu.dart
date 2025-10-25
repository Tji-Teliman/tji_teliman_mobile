import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/screens_jeunes/mes_candidatures.dart';
import '../screens/screens_jeunes/historique_paiement.dart';
import '../screens/screens_jeunes/message_conversation.dart';
import '../screens/screens_jeunes/parametre.dart';
import '../screens/screens_jeunes/centre_aide.dart';

// --- COULEURS UTILISÉES DANS LE DESIGN (réutilisées depuis votre code) ---
const Color primaryGreen = Color(0xFF10B981); // Couleur principale du thème
const Color badgeOrange = Color(0xFFF59E0B); // Couleur du bouton de déconnexion

// Définition des éléments du menu
class DrawerItem {
  final String title;
  final IconData icon;

  DrawerItem({required this.title, required this.icon});
}

// Données statiques pour le menu
final List<DrawerItem> drawerItems = [
  // Icônes ajustées pour correspondre au style de l'image (légèrement plus épaisses)
  DrawerItem(title: 'Mes Candidatures', icon: Icons.assignment_outlined), 
  DrawerItem(title: 'Historique', icon: Icons.bar_chart_outlined),
  DrawerItem(title: 'Messages', icon: Icons.chat_bubble_outline),
  DrawerItem(title: 'Paramètres', icon: Icons.settings_outlined),
  DrawerItem(title: 'Aide', icon: Icons.help_outline),
];

class CustomDrawer extends StatelessWidget {
  final String userName;
  final String userProfile; // Titre "Mon Profil"

  const CustomDrawer({
    super.key,
    this.userName = "Rama Konaré",
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
    Navigator.of(context).pop();
    if (key.contains('candidature')) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MesCandidaturesScreen()),
      );
      return;
    }
    if (key.contains('histor')) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HistoriquePaiement()),
      );
      return;
    }
    if (key.contains('message')) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MessageConversationScreen()),
      );
      return;
    }
    if (key.contains('param')) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Parametre()),
      );
      return;
    }
    if (key.contains('aide')) {
      Navigator.of(context).pushReplacement(
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

    // En utilisant le widget Transform.translate, on peut "pousser" un Container
    // qui imite le comportement d'un Drawer, mais avec une hauteur et un arrondi contrôlés.
    // Cependant, le moyen le plus simple et le plus propre, tout en utilisant la propriété
    // endDrawer, est de créer un Container qui a la taille et l'arrondi.
    
    // Pour ne pas prendre toute la hauteur, nous utilisons un Container qui est
    // ensuite enveloppé par le Drawer.

    return Container(
      // La propriété 'width' de Drawer est ignorée si elle est dans un Drawer
      // On utilise donc un Container pour forcer la taille.
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
                            // Rama Konaré
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
                itemCount: drawerItems.length,
                itemBuilder: (context, index) {
                  final item = drawerItems[index];
                  return _buildDrawerTile(
                    icon: item.icon,
                    title: item.title,
                    onTap: () => _handleNavigation(context, item.title),
                  );
                },
              ),
            ),

            // 3. BOUTON DE DÉCONNEXION FIXE EN BAS
            // Assurez-vous que le bouton de déconnexion est à l'intérieur du ClipRRect
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

// ⚠️ IMPORTANT : Wrapper pour l'utiliser dans le Scaffold
// Enveloppez le CustomDrawer dans un widget Drawer si vous voulez l'utiliser dans la propriété endDrawer
// et obtenir l'animation de translation latérale.

class CustomMenuWrapper extends StatelessWidget {
  const CustomMenuWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Le Drawer natif est utilisé pour l'animation, mais son contenu est le CustomDrawer.
    return Drawer(
      // La largeur doit être définie ici pour l'animation
      width: MediaQuery.of(context).size.width * 0.75, 
      child: Align(
        // Aligner le menu en haut pour laisser l'espace blanc en bas
        alignment: Alignment.topRight, 
        child: CustomDrawer(
          // Passez les données réelles ici
          userName: "Rama Konaré",
          userProfile: "Mon Profil",
        ),
      ),
    );
  }
}
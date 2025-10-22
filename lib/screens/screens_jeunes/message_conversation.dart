// Fichier : lib/screens/message_conversation.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Importation des widgets réutilisables
import '../../widgets/custom_header.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
// Import de l'écran Accueil
import 'home_jeune.dart';
// Import de l'écran de chat
import 'chat_screen.dart';

// --- COULEURS ET CONSTANTES ---
const Color primaryBlue = Color(0xFF2563EB); 
const Color lightGrey = Color(0xFFE0E0E0);
const Color darkGrey = Colors.black54;
const Color bodyBackgroundColor = Color(0xFFF5F5F5); 
const Color customHeaderColor = Color(0xFF2f9bcf); // Couleur du Header

// Modèle de données factices pour simuler les conversations
class Conversation {
  final String name;
  final String lastMessageTime;
  final String imageUrl;

  Conversation({required this.name, required this.lastMessageTime, required this.imageUrl});
}

class MessageConversationScreen extends StatefulWidget {
  const MessageConversationScreen({super.key});

  @override
  State<MessageConversationScreen> createState() => _MessageConversationScreenState();
}

class _MessageConversationScreenState extends State<MessageConversationScreen> {
  // Index 3 correspond à la section "Discussions" dans la barre de navigation
  final int _selectedIndex = 3; 
  
  // Liste des conversations factices
  final List<Conversation> _conversations = [
    Conversation(name: 'Amadou B.', lastMessageTime: '11:24', imageUrl: 'user1.png'),
    Conversation(name: 'Sitan Konaré', lastMessageTime: 'Samedi', imageUrl: 'user2.png'),
    Conversation(name: 'Kadidja Konaré', lastMessageTime: 'Mercredi', imageUrl: 'user3.png'),
    Conversation(name: 'Sawa Simpara', lastMessageTime: '29/09/25', imageUrl: 'user4.png'),
    Conversation(name: 'Aminata Diarra', lastMessageTime: '25/09/25', imageUrl: 'user5.png'),
    Conversation(name: 'Awa Coulibaly', lastMessageTime: '15/09/25', imageUrl: 'user6.png'),
    Conversation(name: 'Papa Sylla', lastMessageTime: '11/09/25', imageUrl: 'user7.png'),
    Conversation(name: 'Samba Diallo', lastMessageTime: '04/09/25', imageUrl: 'user8.png'),
  ];
  
  // Widget pour la barre de recherche (à placer dans le CustomHeader)
  Widget _buildSearchBar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: darkGrey),
          hintText: 'Recherche',
          hintStyle: GoogleFonts.poppins(color: darkGrey.withOpacity(0.7)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
      ),
    );
  }

  // Widget pour un élément de conversation
  Widget _buildConversationItem(BuildContext context, Conversation conversation) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatScreen(interlocutorName: conversation.name),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: lightGrey, width: 0.5)),
          color: Colors.white,
        ),
        child: Row(
          children: <Widget>[
            // Photo de profil ou icône générique
            CircleAvatar(
              radius: 25,
              backgroundColor: lightGrey,
              child: Icon(Icons.person, color: Colors.white, size: 30),
            ),
            
            const SizedBox(width: 15),
            
            // Nom de l'utilisateur
            Expanded(
              child: Text(
                conversation.name,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            
            // Heure/Date du dernier message
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  conversation.lastMessageTime,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: darkGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                // Icône chevron
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: darkGrey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  // NOUVEAU WIDGET : Affichage pour l'état vide (Aucune conversation)
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Icône de message (utilisée pour simuler le style de la maquette)
            Icon(
              Icons.chat_bubble,
              size: 60,
              color: Colors.black, // Couleur noire comme sur la maquette
            ),
            const SizedBox(height: 20),
            Text(
              'Aucun message',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      
      // 1. HEADER personnalisé avec CustomHeader
      appBar: CustomHeader(
        title: 'Discussions',
        // Icône de droite pour les paramètres de discussion (comme dans la maquette)
        rightIcon: Icons.settings_outlined, 
        onBack: () => Navigator.of(context).pop(), 
        // Barre de recherche dans la partie inférieure du header
        bottomWidget: _buildSearchBar(),
      ),
      
      // 2. CORPS de la Page : Liste des Conversations
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 5.0),
              child: Text(
                'Conversations',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            
            // Séparateur
            const Divider(height: 0, color: lightGrey),

            // Liste des conversations
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _conversations.length,
                itemBuilder: (context, index) {
                  return _buildConversationItem(context, _conversations[index]);
                },
              ),
            ),
          ],
        ),
      ),
      
      // 3. FOOTER : Barre de Navigation Personnalisée
      bottomNavigationBar: CustomBottomNavBar(
        initialIndex: _selectedIndex,
        onItemSelected: (index) {
          if (index == 0) {
            // Aller vers Accueil
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeJeuneScreen()),
            );
            return;
          }
          if (index == 3) {
            // Déjà sur Discussions
            return;
          }
          // Autres onglets: à implémenter au besoin
        },
      ),
    );
  }
}

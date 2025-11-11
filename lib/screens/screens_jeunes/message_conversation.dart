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
// Import de l'écran Mes Candidatures
import 'mes_candidatures.dart';
import 'profil_jeune.dart';
import '../../services/message_service.dart';

// --- COULEURS ET CONSTANTES ---
const Color primaryBlue = Color(0xFF2563EB); 
const Color lightGrey = Color(0xFFE0E0E0);
const Color darkGrey = Colors.black54;
const Color bodyBackgroundColor = Color(0xFFf6fcfc); 
const Color customHeaderColor = Color(0xFF2f9bcf); // Couleur du Header

// On utilise ConversationSummary depuis MessageService

class MessageConversationScreen extends StatefulWidget {
  const MessageConversationScreen({super.key});

  @override
  State<MessageConversationScreen> createState() => _MessageConversationScreenState();
}

class _MessageConversationScreenState extends State<MessageConversationScreen> {
  // Index 3 correspond à la section "Discussions" dans la barre de navigation
  final int _selectedIndex = 3; 
  
  bool _isLoading = true;
  String? _error;
  List<ConversationSummary> _conversations = [];

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final list = await MessageService.getConversations();
      if (!mounted) return;
      setState(() {
        _conversations = list;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
        _conversations = [];
        _isLoading = false;
      });
    }
  }
  
  // Widget pour la barre de recherche 
  Widget _buildSearchBar() {
    return Container(
      height: 44,
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
          // Assure que le champ de texte prend toute la hauteur sans bordure
          border: InputBorder.none, 
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
      ),
    );
  }

  // Widget pour un élément de conversation
  Widget _buildConversationItem(BuildContext context, ConversationSummary conversation) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  interlocutorName: conversation.fullName,
                  destinataireId: conversation.destinataireId,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            decoration: BoxDecoration(
              color: conversation.messagesNonLus > 0 ? primaryBlue.withOpacity(0.12) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
        child: Row(
          children: <Widget>[
            if (conversation.messagesNonLus > 0)
              Container(
                width: 4,
                height: 56,
                margin: const EdgeInsets.only(right: 12),
                decoration: const BoxDecoration(color: primaryBlue, borderRadius: BorderRadius.all(Radius.circular(3))),
              ),
            // Photo de profil ou icône générique
            Builder(builder: (_) {
              final url = conversation.resolvedPhotoUrl;
              if (url != null) {
                return CircleAvatar(
                  radius: 25,
                  backgroundColor: lightGrey,
                  foregroundImage: NetworkImage(url),
                  child: const Icon(Icons.person, color: Colors.white, size: 30),
                );
              }
              return const CircleAvatar(
                radius: 25,
                backgroundColor: lightGrey,
                child: Icon(Icons.person, color: Colors.white, size: 30),
              );
            }),
            
            const SizedBox(width: 15),
            
            // Nom + Dernier message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (conversation.messagesNonLus > 0)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: const BoxDecoration(
                            color: primaryBlue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          conversation.fullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: conversation.messagesNonLus > 0 ? FontWeight.w700 : FontWeight.w500,
                            color: conversation.messagesNonLus > 0 ? primaryBlue : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    conversation.dernierMessage.isEmpty ? '...' : conversation.dernierMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: conversation.messagesNonLus > 0 ? Colors.black87 : darkGrey,
                      fontWeight: conversation.messagesNonLus > 0 ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            
            // Heure/Date + badge non lus
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      conversation.dateDernierMessage,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: darkGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (conversation.messagesNonLus > 0) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: primaryBlue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          conversation.messagesNonLus.toString(),
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ]
                  ],
                ),
                const SizedBox(height: 4),
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
        ),
        // Ligne de séparation entre chaque conversation
        const Divider(height: 1, color: lightGrey),
      ],
    );
  }
  
  // WIDGET : Affichage pour l'état vide (Aucune conversation)
  Widget _buildEmptyState() {
    // Si la liste des conversations est vide, on pourrait afficher ce widget
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
        customRightWidget: const Padding(
          padding: EdgeInsets.only(left: 14.0),
          child: Icon(Icons.more_horiz, color: Colors.white, size: 24),
        ),
        onBack: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeJeuneScreen()),
          );
        },
        bottomWidget: _buildSearchBar(),
      ),
      
      // 2. CORPS de la Page : Liste des Conversations
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryBlue))
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
                        const SizedBox(height: 12),
                        Text(_error!, textAlign: TextAlign.center, style: GoogleFonts.poppins()),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _loadConversations,
                          style: ElevatedButton.styleFrom(backgroundColor: primaryBlue),
                          child: Text('Réessayer', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                        )
                      ],
                    ),
                  ),
                )
              : (_conversations.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.chat_bubble, size: 60, color: Colors.black),
                            const SizedBox(height: 20),
                            Text('Aucun message', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 5.0),
                          child: Text(
                            'Conversations',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const Divider(height: 0, color: lightGrey),
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
                    )),
      
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
            // Déjà sur Discussions
            return;
          }
          // Autres onglets: à implémenter au besoin
        },
      ),
    );
  }
}

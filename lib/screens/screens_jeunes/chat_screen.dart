// Fichier : lib/screens/chat_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Importation du widget CustomHeader
import '../../widgets/custom_header.dart';

// --- COULEURS ET CONSTANTES ---
const Color primaryBlue = Color(0xFF2563EB); 
const Color darkBlueHeader = Color(0xFF2f9bcf); // Couleur du Header
const Color bodyBackgroundColor = Color(0xFFf6fcfc); 

// Modèle de Message pour la démonstration
class ChatMessage {
  final String text;
  final String time;
  final bool isMe; // True si c'est l'utilisateur actuel qui envoie

  ChatMessage({required this.text, required this.time, required this.isMe});
}

class ChatScreen extends StatefulWidget {
  final String interlocutorName;

  const ChatScreen({super.key, required this.interlocutorName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  
  // Liste de messages factices pour simuler la conversation de la maquette
  final List<ChatMessage> _messages = [
    ChatMessage(text: 'Salut , j\'aimerais avoir plus d\'informations !', time: '08h:04', isMe: true),
    ChatMessage(text: 'Salut , Déménagement d\'un appartement situé au 2e étage sans ascenseur. Aide au transport de cartons et de quelques meubles démontés jusqu\'au camion de déménagement.', time: '08h:08', isMe: false),
    ChatMessage(text: 'L\'heure est toujours 09h:00 ?', time: '08h:10', isMe: true),
    ChatMessage(text: 'OUI!!!', time: '08h:11', isMe: false),
  ];
  
  // Fonction pour construire une bulle de message
  Widget _buildMessageBubble(ChatMessage message) {
    // Les messages de l'utilisateur sont à droite (couleur bleue)
    // Les messages de l'interlocuteur sont à gauche (couleur grise foncée)
    final bubbleColor = message.isMe ? primaryBlue : Colors.grey[700];
    final textColor = message.isMe ? Colors.white : Colors.white;
    final alignment = message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bubbleMargin = message.isMe 
        ? const EdgeInsets.only(left: 60.0)
        : const EdgeInsets.only(right: 60.0);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      child: Column(
        crossAxisAlignment: alignment,
        children: <Widget>[
          Container(
            constraints: const BoxConstraints(maxWidth: 280),
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
            margin: bubbleMargin,
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(message.isMe ? 15 : 0),
                bottomRight: Radius.circular(message.isMe ? 0 : 15),
              ),
            ),
            child: Text(
              message.text,
              style: GoogleFonts.poppins(
                color: textColor,
                fontSize: 14.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0, right: 10, left: 10),
            child: Text(
              message.time,
              style: GoogleFonts.poppins(
                fontSize: 10.0,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget pour simuler le regroupement par date
  Widget _buildDateSeparator(String date) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          date,
          style: GoogleFonts.poppins(
            fontSize: 12.0,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
  
  // Fonction pour envoyer un message (factice pour la démo)
  void _handleSubmitted(String text) {
    if (text.isEmpty) return;
    _textController.clear();
    setState(() {
      _messages.add(
        ChatMessage(
          text: text, 
          time: 'Maintenant', 
          isMe: true,
        ),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      
      // 1. HEADER avec avatar de profil utilisant CustomHeader
      appBar: CustomHeader(
        title: widget.interlocutorName,
        useCompactStyle: true,
        leftWidget: const CircleAvatar(
          radius: 18,
          backgroundColor: Colors.white,
          child: Icon(Icons.person, color: darkBlueHeader, size: 20),
        ),
        onBack: () => Navigator.of(context).pop(),
      ),
      
      // 2. CORPS de la Page : Liste des messages
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 10.0),
              reverse: true, // Afficher les messages récents en bas
              itemCount: _messages.length + 1, // +1 pour le séparateur de date
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  // Afficher le séparateur de date en haut de la liste (chronologie inversée)
                  return _buildDateSeparator('Aujourd\'hui');
                }
                return _buildMessageBubble(_messages.reversed.toList()[index]);
              },
            ),
          ),
          
          // 3. Zone de Saisie de Message
          // On n'utilise pas le clavier visuel de la maquette mais une zone de saisie fonctionnelle.
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE0E0E0), width: 1.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
              child: Row(
                children: <Widget>[
                  // Icône Caméra/Image
                  const Icon(Icons.photo_camera_outlined, color: darkBlueHeader, size: 28),
                  const SizedBox(width: 8),
                  // Icône Audio (simulée par une icône A)
                  const Icon(Icons.mic_none, color: darkBlueHeader, size: 28),
                  const SizedBox(width: 8),

                  // Champ de Saisie
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        color: bodyBackgroundColor, // Fond gris clair pour le champ
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _textController,
                        onSubmitted: _handleSubmitted,
                        decoration: InputDecoration(
                          hintText: 'Message',
                          hintStyle: GoogleFonts.poppins(color: Colors.black54),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: GoogleFonts.poppins(fontSize: 14.0),
                      ),
                    ),
                  ),
                  
                  // Icône d'envoi
                  IconButton(
                    icon: const Icon(Icons.send, color: darkBlueHeader),
                    onPressed: () => _handleSubmitted(_textController.text),
                  ),
                ],
              ),
            ),
          ),
          // Espace pour simuler l'occupation du clavier (important pour l'affichage)
          const SizedBox(height: 10.0), 
        ],
      ),
      
      // On retire le footer CustomBottomNavBar pour les pages de discussion
      bottomNavigationBar: null, 
    );
  }
}
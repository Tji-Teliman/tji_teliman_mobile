import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/custom_bottom_nav_bar_recruteur.dart';
import 'home_recruteur.dart';
import 'missions_recruteur.dart';
import 'profil_recruteur.dart';
import 'chat_screen_recruteur.dart';

const Color primaryBlue = Color(0xFF2563EB); 
const Color lightGrey = Color(0xFFE0E0E0);
const Color darkGrey = Colors.black54;
const Color bodyBackgroundColor = Color(0xFFf6fcfc); 

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
  final int _selectedIndex = 3; 
  
  final List<Conversation> _conversations = [
    Conversation(name: 'Ramatou Konaré', lastMessageTime: '11:24', imageUrl: 'user1.png'),
    Conversation(name: 'Jean Dupont', lastMessageTime: 'Samedi', imageUrl: 'user2.png'),
    Conversation(name: 'Awa Traoré', lastMessageTime: 'Mercredi', imageUrl: 'user3.png'),
    Conversation(name: 'Moussa Keita', lastMessageTime: '29/09/25', imageUrl: 'user4.png'),
    Conversation(name: 'Fatoumata Diallo', lastMessageTime: '25/09/25', imageUrl: 'user5.png'),
    Conversation(name: 'Ousmane Diarra', lastMessageTime: '15/09/25', imageUrl: 'user6.png'),
    Conversation(name: 'Kadidja Coulibaly', lastMessageTime: '11/09/25', imageUrl: 'user7.png'),
  ];
  
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
          border: InputBorder.none, 
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
      ),
    );
  }

  Widget _buildConversationItem(BuildContext context, Conversation conversation) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChatScreen(interlocutorName: conversation.name),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            decoration: const BoxDecoration(),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 25,
              backgroundColor: lightGrey,
              child: Icon(Icons.person, color: Colors.white, size: 30),
            ),
            
            const SizedBox(width: 15),
            
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
        const Divider(height: 1, color: lightGrey),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      
      appBar: CustomHeader(
        title: 'Discussions',
        customRightWidget: const Padding(
          padding: EdgeInsets.only(left: 14.0),
          child: Icon(Icons.more_horiz, color: Colors.white, size: 24),
        ),
        onBack: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeRecruteurScreen()),
          );
        },
        bottomWidget: _buildSearchBar(),
      ),
      
      body: Column(
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
            child: Container(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _conversations.length,
                itemBuilder: (context, index) {
                  return _buildConversationItem(context, _conversations[index]);
                },
              ),
            ),
          ),
        ],
      ),
      
      bottomNavigationBar: CustomBottomNavBarRecruteur(
        initialIndex: _selectedIndex,
        onItemSelected: (index) {
          if (index == 0) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeRecruteurScreen()),
            );
            return;
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
            return;
          }
        },
      ),
    );
  }
}


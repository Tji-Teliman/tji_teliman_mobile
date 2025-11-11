import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/custom_bottom_nav_bar_recruteur.dart';
import 'home_recruteur.dart';
import 'missions_recruteur.dart';
import 'profil_recruteur.dart';
import 'chat_screen_recruteur.dart';
import '../../services/message_service.dart';

const Color primaryBlue = Color(0xFF2563EB); 
const Color lightGrey = Color(0xFFE0E0E0);
const Color darkGrey = Colors.black54;
const Color bodyBackgroundColor = Color(0xFFf6fcfc); 

// We will use ConversationSummary from MessageService

class MessageConversationScreen extends StatefulWidget {
  const MessageConversationScreen({super.key});

  @override
  State<MessageConversationScreen> createState() => _MessageConversationScreenState();
}

class _MessageConversationScreenState extends State<MessageConversationScreen> {
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
                  interlocutorPhotoUrl: conversation.resolvedPhotoUrl,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            decoration: BoxDecoration(
              color: conversation.messagesNonLus > 0 ? primaryBlue.withOpacity(0.10) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
        child: Row(
          children: <Widget>[
            if (conversation.messagesNonLus > 0)
              Container(
                width: 3,
                height: 50,
                margin: const EdgeInsets.only(right: 10),
                decoration: const BoxDecoration(color: primaryBlue, borderRadius: BorderRadius.all(Radius.circular(2))),
              ),
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
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.fullName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: conversation.messagesNonLus > 0 ? FontWeight.w700 : FontWeight.w500,
                      color: conversation.messagesNonLus > 0 ? primaryBlue : Colors.black87,
                    ),
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


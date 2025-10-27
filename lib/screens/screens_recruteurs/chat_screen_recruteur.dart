import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/custom_header.dart';

const Color primaryBlue = Color(0xFF2563EB); 
const Color darkBlueHeader = Color(0xFF2f9bcf);
const Color bodyBackgroundColor = Color(0xFFf6fcfc); 

class ChatMessage {
  final String text;
  final String time;
  final bool isMe;

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
  
  final List<ChatMessage> _messages = [
    ChatMessage(text: 'Bonjour, je suis intéressé par votre mission de livraison. Pouvez-vous me donner plus de détails ?', time: '08h:04', isMe: false),
    ChatMessage(text: 'Bonjour ! Bien sûr, la mission consiste à livrer des documents dans 3 bureaux différents. Le travail est prévu pour aujourd\'hui à partir de 10h. Est-ce que cela vous convient ?', time: '08h:08', isMe: true),
    ChatMessage(text: 'Parfait, je suis disponible. Quel est le lieu de rendez-vous ?', time: '08h:10', isMe: false),
    ChatMessage(text: 'Rendez-vous à 09h30 au siège, 123 Avenue Mohamed V.', time: '08h:11', isMe: true),
  ];
  
  Widget _buildMessageBubble(ChatMessage message) {
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
                topLeft: const Radius.circular(15),
                topRight: const Radius.circular(15),
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
      
      appBar: CustomHeader(
        title: widget.interlocutorName,
        useCompactStyle: true,
        centerTitle: false,
        leftWidget: const CircleAvatar(
          radius: 18,
          backgroundColor: Colors.white,
          child: Icon(Icons.person, color: darkBlueHeader, size: 20),
        ),
        onBack: () => Navigator.of(context).pop(),
      ),
      
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 10.0),
              reverse: true,
              itemCount: _messages.length + 1,
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return _buildDateSeparator('Aujourd\'hui');
                }
                return _buildMessageBubble(_messages.reversed.toList()[index]);
              },
            ),
          ),
          
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE0E0E0), width: 1.0)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  top: 5.0,
                  bottom: MediaQuery.of(context).padding.bottom + 5.0,
                ),
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.photo_camera_outlined, color: darkBlueHeader, size: 28),
                    const SizedBox(width: 8),
                    const Icon(Icons.mic_none, color: darkBlueHeader, size: 28),
                    const SizedBox(width: 8),

                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                        decoration: BoxDecoration(
                          color: bodyBackgroundColor,
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
                    
                    IconButton(
                      icon: const Icon(Icons.send, color: darkBlueHeader),
                      onPressed: () => _handleSubmitted(_textController.text),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      
      bottomNavigationBar: null,
    );
  }
}


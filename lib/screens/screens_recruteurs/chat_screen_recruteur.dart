import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/custom_header.dart';
import '../../services/message_service.dart';
import '../../config/api_config.dart';

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
  final int destinataireId;
  final String? interlocutorPhotoUrl;

  const ChatScreen({super.key, required this.interlocutorName, required this.destinataireId, this.interlocutorPhotoUrl});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  
  bool _loading = true;
  String? _error;
  final List<ChatMessage> _messages = [];
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _photoUrl = widget.interlocutorPhotoUrl;
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await MessageService.getConversationMessages(destinataireId: widget.destinataireId);
      if (!mounted) return;
      final list = data.map((m) {
        final contenu = (m['contenu'] ?? '').toString();
        final date = (m['dateMessage'] ?? '').toString();
        final expNom = (m['expediteurNom'] ?? '').toString();
        final expPrenom = (m['expediteurPrenom'] ?? '').toString();
        final senderFull = (expPrenom + ' ' + expNom).trim();
        final isFromInterlocutor = senderFull.isNotEmpty && senderFull.toLowerCase() == widget.interlocutorName.toLowerCase();
        if (_photoUrl == null && isFromInterlocutor) {
          final raw = m['expediteurPhoto'];
          final p = raw == null ? null : raw.toString();
          final r = _resolvePhotoUrl(p);
          if (r != null) {
            _photoUrl = r;
          }
        }
        return ChatMessage(
          text: contenu,
          time: date.isEmpty ? '•' : date,
          isMe: !isFromInterlocutor,
        );
      }).toList();
      setState(() {
        _messages
          ..clear()
          ..addAll(list);
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
        _loading = false;
      });
    }
  }

  String? _resolvePhotoUrl(String? raw) {
    if (raw == null) return null;
    final s = raw.trim();
    if (s.isEmpty) return null;
    if (s.startsWith('http://') || s.startsWith('https://')) return s;
    final normalized = s.replaceAll('\\', '/');
    final idx = normalized.toLowerCase().indexOf('/uploads/');
    if (idx != -1) {
      final tail = normalized.substring(idx);
      return ApiConfig.baseUrl + tail;
    }
    return null;
  }
  
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
    if (text.trim().isEmpty) return;
    final contenu = text.trim();
    _textController.clear();
    final optimistic = ChatMessage(text: contenu, time: 'Maintenant', isMe: true);
    setState(() {
      _messages.add(optimistic);
    });
    MessageService.sendTextMessage(destinataireId: widget.destinataireId, contenu: contenu).then((resp) {
      final date = (resp['dateMessage'] ?? '').toString();
      if (!mounted || date.isEmpty) return;
      setState(() {
        final idx = _messages.lastIndexOf(optimistic);
        if (idx != -1) {
          _messages[idx] = ChatMessage(text: optimistic.text, time: date, isMe: true);
        }
      });
    }).catchError((e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst(RegExp(r'^Exception:\s*'), ''), style: GoogleFonts.poppins())));
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
        leftWidget: CircleAvatar(
          radius: 18,
          backgroundColor: Colors.white,
          backgroundImage: (_photoUrl != null && _photoUrl!.startsWith('http')) ? NetworkImage(_photoUrl!) : null,
          child: (_photoUrl == null || !_photoUrl!.startsWith('http')) ? const Icon(Icons.person, color: darkBlueHeader, size: 20) : null,
        ),
        onBack: () => Navigator.of(context).pop(),
      ),
      
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: darkBlueHeader))
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
                          onPressed: _loadMessages,
                          style: ElevatedButton.styleFrom(backgroundColor: darkBlueHeader),
                          child: Text('Réessayer', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                        )
                      ],
                    ),
                  ),
                )
              : Column(
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


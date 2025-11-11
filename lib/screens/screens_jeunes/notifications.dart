// Fichier : lib/screens/notifications.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/user_service.dart';

// Importation des widgets réutilisables (doit exister dans le chemin correct)
import '../../widgets/custom_header.dart'; 

// --- COULEURS ET CONSTANTES ---
const Color primaryBlue = Color(0xFF2563EB); 
const Color lightGrey = Color(0xFFE0E0E0);
const Color darkGrey = Colors.black54;
const Color bodyBackgroundColor = Color(0xFFf6fcfc); 
const Color customHeaderColor = Color(0xFF2f9bcf); // Couleur du Header
const Color successGreen = Color(0xFF34C759); // Vert pour les succès
const Color actionBlue = Color(0xFF007AFF); // Bleu pour les actions (Noter/Action requise)
const Color orangeSms = Color(0xFFFF9500); // Orange pour les SMS/Messages
const Color starYellow = Color(0xFFFFCC00); // Jaune pour les notations
const Color infoBlue = Color(0xFF5AC8FA); // Bleu clair pour l'information générale
const Color amberAction = Color(0xFFF59E0B); // Couleur demandée pour paiement
const Color greenAction = Color(0xFF10B981); // Couleur demandée pour discuter

// Modèle de données pour les notifications
class NotificationItem {
  final String title;
  final String content;
  final String timeAgo;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final bool showReplyButton;
  final String type; 

  const NotificationItem({
    required this.title,
    required this.content,
    required this.timeAgo,
    required this.icon,
    required this.iconColor,
    this.backgroundColor = Colors.white,
    this.showReplyButton = false,
    required this.type,
  });
}

class _NotifStyle {
  final IconData icon;
  final Color color;
  final bool showReply;
  final String typeKey;
  _NotifStyle(this.icon, this.color, this.showReply, this.typeKey);
}

// Converti en StatefulWidget pour gérer l'état de chargement
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // État de chargement initial
  bool _isLoading = true;
  List<NotificationItem> _notifications = [];
  String? _errorMessage;
  
  // État pour la barre de navigation (simulé)
  // J'ai retiré le BottomNavigationBar, mais je garde _selectedIndex et _onItemTapped
  // au cas où une navigation y serait ajoutée plus tard, bien qu'ils ne soient plus utilisés ici.
  int _selectedIndex = 0; 
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Logique de navigation à implémenter ici (ex: Navigator.push)
    print("Navigation vers l'index $index");
  }


  // Liste factice des notifications incluant uniquement les types demandés
  final List<NotificationItem> _dummyNotifications = const [
    // 1. CANDIDATURE_ACCEPTEE
    NotificationItem(
      title: 'Candidature Acceptée !',
      content: 'Votre candidature pour la mission "Cours de Math" a été acceptée.',
      timeAgo: 'Il y a 45m',
      icon: Icons.check_circle_outline,
      iconColor: successGreen,
      type: 'CANDIDATURE_ACCEPTEE',
    ),
    
    // 2. MISSION_TERMINEE 
    NotificationItem(
      title: 'Mission Terminée',
      content: 'Félicitations ! La mission "Nettoyage de Bureau" est marquée comme terminée.',
      timeAgo: 'Il y a 1h',
      icon: Icons.work_history, // Icône pour tâche terminée
      iconColor: infoBlue,
      type: 'MISSION_TERMINEE',
    ),
    
    // 3. PAIEMENT_EFFECTUE 
    NotificationItem(
      title: 'Paiement Reçu',
      content: "Votre paiement de 5000 XOF pour 'Aide Déménagement' est arrivé.",
      timeAgo: 'Il y a 50m',
      icon: Icons.account_balance_wallet, // Icône pour paiement/argent
      iconColor: successGreen,
      type: 'PAIEMENT_EFFECTUE',
    ),

    // 4. DEMANDE_NOTATION_RECRUTEUR (Demande au Recruteur de noter le Jeune)
    NotificationItem(
      title: 'Action Requise: Noter le Jeune',
      content: 'Veuillez noter le jeune Mamadou pour la mission "Aide Jardinage".',
      timeAgo: 'Hier',
      icon: Icons.rate_review, // Icône pour demande de notation
      iconColor: actionBlue,
      showReplyButton: true, // Montre un bouton pour l'inciter à noter
      type: 'DEMANDE_NOTATION_RECRUTEUR',
    ),

    // 5. NOTATION_RECUE
    NotificationItem(
      title: 'Nouvelle Notation Reçue',
      content: 'Vous avez reçu une notation de 5 étoiles de Sitan Konaré.',
      timeAgo: 'Il y a 2j',
      icon: Icons.star, // Icône pour notation
      iconColor: starYellow,
      type: 'NOTATION_RECUE',
    ),
    
    // 6. DEMANDE_NOTATION_JEUNE (Demande au Jeune de noter le Recruteur)
    NotificationItem(
      title: 'Action Requise: Noter le Recruteur',
      content: 'Veuillez noter le recruteur M. Diallo pour la mission "Aide Jardinage".',
      timeAgo: 'Il y a 3j',
      icon: Icons.edit_note, // Icône différente pour noter une personne
      iconColor: actionBlue,
      showReplyButton: true, // Montre un bouton pour l'inciter à noter
      type: 'DEMANDE_NOTATION_JEUNE',
    ),
    
    // Ajout d'un exemple pour la variété des dates
    NotificationItem(
      title: 'Paiement Reçu',
      content: "Votre paiement de 3000 XOF pour 'Aide Ménage' est arrivé.",
      timeAgo: 'Il y a 1 semaine',
      icon: Icons.account_balance_wallet, 
      iconColor: successGreen,
      type: 'PAIEMENT_EFFECTUE',
    ),
  ];
  
  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  // Appel réel au backend
  Future<void> _fetchNotifications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final data = await UserService.getMesNotifications();
      final mapped = data.map<NotificationItem>((n) => _mapBackendToItem(n)).toList();
      if (!mounted) return;
      setState(() {
        _notifications = mapped;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
        _notifications = [];
        _isLoading = false;
      });
    }
  }

  NotificationItem _mapBackendToItem(Map<String, dynamic> n) {
    final type = (n['type'] ?? n['notificationType'] ?? '').toString();
    final title = (n['titre'] ?? n['title'] ?? n['subject'] ?? _defaultTitleForType(type)).toString();
    final content = (n['contenu'] ?? n['content'] ?? n['message'] ?? n['description'] ?? '').toString();
    final relative = n['dateCreationRelative']?.toString();
    final createdAtRaw = n['dateCreation'] ?? n['createdAt'] ?? n['created_at'] ?? n['date'];
    final timeAgo = (relative != null && relative.trim().isNotEmpty)
        ? relative
        : (_formatTimeAgoSafe(createdAtRaw) ?? (n['timeAgo']?.toString() ?? ''));

    final style = _styleForType(type);

    return NotificationItem(
      title: title.isEmpty ? _defaultTitleForType(type) : title,
      content: content.isEmpty ? _defaultContentForType(type) : content,
      timeAgo: timeAgo.isEmpty ? '•' : timeAgo,
      icon: style.icon,
      iconColor: style.color,
      backgroundColor: Colors.white,
      showReplyButton: style.showReply,
      type: style.typeKey,
    );
  }

  String _defaultTitleForType(String type) {
    switch (type.toUpperCase()) {
      case 'CANDIDATURE_ACCEPTEE':
        return 'Candidature Acceptée !';
      case 'MISSION_TERMINEE':
        return 'Mission Terminée';
      case 'PAIEMENT_EFFECTUE':
        return 'Paiement Reçu';
      case 'DEMANDE_NOTATION_RECRUTEUR':
        return 'Action Requise: Noter le Jeune';
      case 'DEMANDE_NOTATION_JEUNE':
        return 'Action Requise: Noter le Recruteur';
      case 'NOTATION_RECUE':
        return 'Nouvelle Notation Reçue';
      default:
        return 'Notification';
    }
  }

  String _defaultContentForType(String type) {
    switch (type.toUpperCase()) {
      case 'CANDIDATURE_ACCEPTEE':
        return 'Votre candidature a été acceptée.';
      case 'MISSION_TERMINEE':
        return 'Félicitations, mission marquée terminée.';
      case 'PAIEMENT_EFFECTUE':
        return 'Votre paiement est arrivé.';
      case 'DEMANDE_NOTATION_RECRUTEUR':
        return 'Veuillez noter le jeune.';
      case 'DEMANDE_NOTATION_JEUNE':
        return 'Veuillez noter le recruteur.';
      case 'NOTATION_RECUE':
        return 'Vous avez reçu une nouvelle notation.';
      default:
        return '';
    }
  }

  _NotifStyle _styleForType(String type) {
    final t = type.toUpperCase();
    if (t == 'CANDIDATURE_ACCEPTEE') {
      return _NotifStyle(Icons.check_circle_outline, successGreen, false, 'CANDIDATURE_ACCEPTEE');
    }
    if (t == 'MISSION_TERMINEE') {
      return _NotifStyle(Icons.work_history, infoBlue, false, 'MISSION_TERMINEE');
    }
    if (t == 'PAIEMENT_EFFECTUE') {
      return _NotifStyle(Icons.account_balance_wallet, successGreen, false, 'PAIEMENT_EFFECTUE');
    }
    if (t == 'DEMANDE_NOTATION_RECRUTEUR') {
      return _NotifStyle(Icons.rate_review, actionBlue, true, 'DEMANDE_NOTATION_RECRUTEUR');
    }
    if (t == 'DEMANDE_NOTATION_JEUNE') {
      return _NotifStyle(Icons.edit_note, actionBlue, true, 'DEMANDE_NOTATION_JEUNE');
    }
    if (t == 'NOTATION_RECUE') {
      return _NotifStyle(Icons.star, starYellow, false, 'NOTATION_RECUE');
    }
    // Défaut
    return _NotifStyle(Icons.notifications, customHeaderColor, false, t.isEmpty ? 'INFO' : t);
  }

  String? _formatTimeAgoSafe(dynamic raw) {
    try {
      if (raw == null) return null;
      final s = raw.toString();
      if (s.isEmpty) return null;
      final dt = DateTime.tryParse(s);
      if (dt == null) return null;
      return _formatTimeAgo(dt);
    } catch (_) {
      return null;
    }
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inSeconds < 60) return 'Il y a ${diff.inSeconds}s';
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes}m';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours}h';
    if (diff.inDays < 7) return 'Il y a ${diff.inDays}j';
    final weeks = (diff.inDays / 7).floor();
    return weeks <= 1 ? 'Il y a 1 semaine' : 'Il y a ${weeks} semaines';
  }

  // Widget pour construire une carte de notification
  Widget _buildNotificationCard(BuildContext context, NotificationItem item) {
    // Logique de visibilité/label/couleur du bouton selon le type
    final bool isRatingRequest = item.type == 'DEMANDE_NOTATION_RECRUTEUR' || item.type == 'DEMANDE_NOTATION_JEUNE';
    bool showAction = false;
    String buttonText = 'Action';
    Color buttonColor = successGreen;

    if (isRatingRequest) {
      showAction = true;
      buttonText = 'Noter';
      buttonColor = actionBlue;
    } else if (item.type == 'CANDIDATURE_ACCEPTEE') {
      showAction = true;
      buttonText = 'Discuter avec le recruteur';
      buttonColor = greenAction; // 10B981
    } else if (item.type == 'MISSION_TERMINEE') {
      showAction = true;
      buttonText = 'Passer au Paiement';
      buttonColor = amberAction; // F59E0B
    } else if (item.showReplyButton) {
      // Compatibilité avec l’ancien champ si déjà utilisé
      showAction = true;
    }

    return Container(
      // Marge extérieure pour espacer les cartes
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: item.backgroundColor,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Icône à gauche
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: item.iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              item.icon,
              color: item.iconColor,
              size: 28,
            ),
          ),
          
          const SizedBox(width: 15),
          
          // Texte principal
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold, // Plus gras que w600
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.content,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500, // Ajout d'un peu de gras
                    color: darkGrey,
                    // Utiliser italic pour les descriptions
                    fontStyle: FontStyle.italic, 
                  ),
                ),
              ],
            ),
          ),
          
          // Colonne Heure et Bouton Action (largeur fixe pour ne pas impacter le contenu)
          SizedBox(
            width: 120,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              // Temps écoulé
              Text(
                item.timeAgo,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: darkGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              
              // Bouton Action (conditionnel)
              if (showAction)
                GestureDetector(
                  onTap: () {
                    // TODO: brancher les actions spécifiques (chat, paiement, noter)
                    print('Action pour : ${item.type} - ${item.title}');
                  },
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 120),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: buttonColor, // Couleur dynamique
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        buttonText,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 3,
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      
      // 1. HEADER compact avec CustomHeader
      appBar: CustomHeader(
        title: 'Notifications',
        useCompactStyle: true,
        onBack: () => Navigator.of(context).pop(),
      ),
      
      // 2. CORPS de la Page : Liste des Notifications
      body: _isLoading 
            ? const Center(child: CircularProgressIndicator(color: customHeaderColor))
            : _notifications.isEmpty
                ? Center(
                    child: Text(
                      _errorMessage == null ? 'Aucune notification pour le moment.' : _errorMessage!,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: darkGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                     padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      return _buildNotificationCard(context, _notifications[index]);
                    },
                  ),
      
      // 3. CADRE DECORATIF INFÉRIEUR (FOOTER)
    );
  }
}

// Fichier : lib/screens/notifications.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  // Fonction simulant l'appel au backend
  Future<void> _fetchNotifications() async {
    setState(() {
      _isLoading = true;
    });

    // Simuler un délai réseau de 1.5 seconde
    await Future.delayed(const Duration(milliseconds: 1500)); 

    // Mettre à jour l'état avec les données factices
    setState(() {
      _notifications = _dummyNotifications;
      _isLoading = false;
    });
  }

  // Widget pour construire une carte de notification
  Widget _buildNotificationCard(BuildContext context, NotificationItem item) {
    // Vérifie si le type nécessite l'affichage du bouton "Noter"
    final bool isRatingRequest = item.type == 'DEMANDE_NOTATION_RECRUTEUR' || item.type == 'DEMANDE_NOTATION_JEUNE';
    
    // Couleur du bouton : actionBlue (bleu) si c'est une demande de notation
    final Color buttonColor = isRatingRequest ? actionBlue : successGreen;
    
    // Texte du bouton : "Noter" si c'est une demande de notation, sinon "Action"
    final String buttonText = isRatingRequest ? 'Noter' : 'Action';

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
          
          // Colonne Heure et Bouton Action
          Column(
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
              if (item.showReplyButton)
                GestureDetector(
                  onTap: () {
                    // Action à définir (Noter)
                    print('Action pour : ${item.title}');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: buttonColor, // Couleur dynamique
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      buttonText,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
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
                      'Aucune notification pour le moment.',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: darkGrey,
                      ),
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

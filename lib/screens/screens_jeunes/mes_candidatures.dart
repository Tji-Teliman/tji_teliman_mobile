// Fichier : mes_candidatures.dart (Suivi des Missions)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Importation des widgets existants (selon la demande de l'utilisateur)
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../widgets/custom_header.dart';
// Import de la page d'accueil pour la navigation
import 'home_jeune.dart';
// Import de la page Discussions pour la navigation
import 'message_conversation.dart';
// Import de la page Chat pour la navigation directe
import 'chat_screen.dart';
import 'profil_jeune.dart';

// --- COULEURS ET CONSTANTES ---
const Color primaryBlue = Color(0xFF2563EB); 
const Color lightGrey = Color(0xFFE0E0E0);
const Color darkGrey = Colors.black54;
const Color bodyBackgroundColor = Color(0xFFf6fcfc); // Couleur demandée
const Color customHeaderColor = Color(0xFF2f9bcf); // Couleur du Header de la maquette
const Color successGreen = Color(0xFF34C759); // Vert pour Accepté(e)
const Color orangePending = Color(0xFFFF9500); // Orange pour En attente
const Color rejectedRed = Color(0xFFEF4444); // Rouge pour Refusé(e)


// --- MODÈLE DE DONNÉES ---
enum CandidatureStatus {
  toutes,
  enAttente,
  acceptee,
  refusee,
}

class Candidature {
  final String title;
  final String location;
  final String datePostulee;
  final CandidatureStatus status;

  Candidature({
    required this.title,
    required this.location,
    required this.datePostulee,
    required this.status,
  });
}

// --- ÉCRAN PRINCIPAL ---
class MesCandidaturesScreen extends StatefulWidget {
  const MesCandidaturesScreen({super.key});

  @override
  State<MesCandidaturesScreen> createState() => _MesCandidaturesScreenState();
}

class _MesCandidaturesScreenState extends State<MesCandidaturesScreen> {
  // Simuler l'index sélectionné pour la navigation (Missions est souvent index 1)
  int _bottomNavIndex = 1; 
  CandidatureStatus _selectedFilter = CandidatureStatus.toutes;

  // Données factices
  final List<Candidature> _candidatures = [
    Candidature(
      title: 'Aide à la livraison du Marché Central',
      location: 'Marché Central',
      datePostulee: '01 Oct',
      status: CandidatureStatus.enAttente,
    ),
    Candidature(
      title: 'Animatrice pour le festival du Dibi',
      location: 'Place du Cinquantenaire',
      datePostulee: '01 Oct',
      status: CandidatureStatus.acceptee,
    ),
    Candidature(
      title: 'Aide à Domicile',
      location: 'Kalanba Coura',
      datePostulee: '01 Oct',
      status: CandidatureStatus.refusee,
    ),
    Candidature(
      title: 'Cours de Mathématiques pour Seconde',
      location: 'Hippodrome',
      datePostulee: '30 Sept',
      status: CandidatureStatus.acceptee,
    ),
    Candidature(
      title: 'Petits travaux de plomberie',
      location: 'Hamdallaye',
      datePostulee: '29 Sept',
      status: CandidatureStatus.enAttente,
    ),
  ];

  List<Candidature> get _filteredCandidatures {
    if (_selectedFilter == CandidatureStatus.toutes) {
      return _candidatures;
    }
    return _candidatures.where((c) => c.status == _selectedFilter).toList();
  }
  
  // Utility pour obtenir la couleur et le texte du statut
  Map<String, dynamic> _getStatusProps(CandidatureStatus status) {
    switch (status) {
      case CandidatureStatus.acceptee:
        return {'text': 'Accepté(e)', 'color': successGreen};
      case CandidatureStatus.refusee:
        return {'text': 'REFUSÉ(E)', 'color': rejectedRed};
      case CandidatureStatus.enAttente:
        return {'text': 'En attente', 'color': orangePending};
      default:
        return {'text': '', 'color': Colors.transparent};
    }
  }

  // Fonction pour simuler le nom du recruteur basé sur la candidature
  String _getRecruiterName(Candidature candidature) {
    // Simulation de noms de recruteurs basés sur le titre de la mission
    switch (candidature.title) {
      case 'Aide à la livraison du Marché Central':
        return 'Moussa Traoré';
      case 'Animatrice pour le festival du Dibi':
        return 'Fatoumata Diallo';
      case 'Aide à Domicile':
        return 'Aminata Koné';
      case 'Cours de Mathématiques pour Seconde':
        return 'Dr. Ibrahim Sissoko';
      case 'Petits travaux de plomberie':
        return 'Boubacar Coulibaly';
      default:
        return 'Recruteur Tji Teliman';
    }
  }

  // --- WIDGETS CONSTITUANTS ---

  Widget _buildFilterButton(CandidatureStatus status, String label) {
    final bool isSelected = _selectedFilter == status;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = status;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        margin: const EdgeInsets.only(right: 6),
        decoration: BoxDecoration(
          // Utilisation du bleu primaire si sélectionné, sinon blanc
          color: isSelected ? primaryBlue : Colors.white,
          border: status == CandidatureStatus.toutes ? null : Border.all(
            color: isSelected ? Colors.transparent : lightGrey, 
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
             if (isSelected) BoxShadow(
              color: primaryBlue.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : darkGrey,
          ),
        ),
      ),
    );
  }

  Widget _buildCandidatureCard(Candidature candidature) {
    final statusProps = _getStatusProps(candidature.status);
    final statusText = statusProps['text'];
    final statusColor = statusProps['color'];
    final bool showChatButton = candidature.status == CandidatureStatus.acceptee;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Icône d'image de mission (simulée)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: lightGrey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.handshake_outlined, color: darkGrey, size: 28),
              ),
              
              const SizedBox(width: 15),
              
              // Texte principal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      candidature.title,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      candidature.location,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: darkGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Postulé le ${candidature.datePostulee}',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: darkGrey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Statut
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusText,
                  style: GoogleFonts.poppins(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          if (showChatButton) const SizedBox(height: 16),
          
          // Bouton "Aller au chat" pour les candidatures acceptées
          if (showChatButton)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigation directe vers la page de chat avec le recruteur
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        interlocutorName: _getRecruiterName(candidature), // Utilise le nom du recruteur simulé
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Aller au chat',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
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
      
      // Utilisation du CustomHeader
      appBar: CustomHeader(
        title: 'Suivi des Missions',
        onBack: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeJeuneScreen()),
        ),
      ),
      
      body: Column(
        children: <Widget>[
          // Barres de Filtres
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterButton(CandidatureStatus.toutes, 'Toutes'),
                  _buildFilterButton(CandidatureStatus.enAttente, 'En attente'),
                  _buildFilterButton(CandidatureStatus.acceptee, 'Acceptée'),
                  _buildFilterButton(CandidatureStatus.refusee, 'Refusée'),
                ],
              ),
            ),
          ),

          // Liste des Candidatures
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 10.0), 
              itemCount: _filteredCandidatures.length,
              itemBuilder: (context, index) {
                return _buildCandidatureCard(_filteredCandidatures[index]);
              },
            ),
          ),
        ],
      ),
      
      // Footer (Bottom Nav Bar)
      bottomNavigationBar: CustomBottomNavBar(
        initialIndex: _bottomNavIndex,
        onItemSelected: (index) {
          if (index == 0) {
            // Aller vers Accueil
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeJeuneScreen()),
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
          if (index == 1) {
            // Déjà sur Candidatures
            return;
          }
          if (index == 3) {
            // Aller vers Discussions
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MessageConversationScreen()),
            );
            return;
          }
          setState(() {
            _bottomNavIndex = index;
          });
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/custom_bottom_nav_bar_recruteur.dart';
import 'publier_mission.dart';
import 'detail_mission_recruteur.dart';
import 'message_conversation_recruteur.dart';
import 'home_recruteur.dart';
import 'profil_recruteur.dart';

const Color primaryGreen = Color(0xFF10B981);
const Color primaryBlue = Color(0xFF2563EB);
const Color bodyBackgroundColor = Color(0xFFf6fcfc);
const Color badgeOrange = Color(0xFFF59E0B);

enum MissionStatus { pending, inProgress, finished }

class Mission {
  final String id;
  final String title;
  final int candidateCount;
  final MissionStatus status;
  final IconData icon;

  Mission({
    required this.id,
    required this.title,
    required this.candidateCount,
    required this.status,
    required this.icon,
  });
}

class MissionsRecruteurScreen extends StatefulWidget {
  const MissionsRecruteurScreen({super.key});

  @override
  State<MissionsRecruteurScreen> createState() => _MissionsRecruteurScreenState();
}

class _MissionsRecruteurScreenState extends State<MissionsRecruteurScreen> {
  int _selectedIndex = 1;
  String _searchQuery = '';

  final List<Mission> _allMissions = [
    Mission(
      id: '1',
      title: 'Aide ménagère',
      candidateCount: 0,
      status: MissionStatus.pending,
      icon: Icons.cleaning_services,
    ),
    Mission(
      id: '2',
      title: 'Livraison',
      candidateCount: 12,
      status: MissionStatus.inProgress,
      icon: Icons.local_shipping,
    ),
    Mission(
      id: '3',
      title: 'Manutention',
      candidateCount: 5,
      status: MissionStatus.finished,
      icon: Icons.work_outline,
    ),
    Mission(
      id: '4',
      title: 'Aide déménagement',
      candidateCount: 3,
      status: MissionStatus.pending,
      icon: Icons.warehouse,
    ),
    Mission(
      id: '5',
      title: 'Livraison',
      candidateCount: 8,
      status: MissionStatus.inProgress,
      icon: Icons.local_shipping,
    ),
    Mission(
      id: '6',
      title: 'Aide ménagère',
      candidateCount: 15,
      status: MissionStatus.finished,
      icon: Icons.cleaning_services,
    ),
  ];

  List<Mission> get _filteredMissions {
    if (_searchQuery.isEmpty) {
      return _allMissions;
    }
    return _allMissions
        .where((mission) => mission.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  String _getStatusLabel(MissionStatus status) {
    switch (status) {
      case MissionStatus.pending:
        return 'En attente';
      case MissionStatus.inProgress:
        return 'En cours';
      case MissionStatus.finished:
        return 'Terminé';
    }
  }

  Color _getStatusColor(MissionStatus status) {
    switch (status) {
      case MissionStatus.pending:
        return badgeOrange;
      case MissionStatus.inProgress:
        return primaryGreen;
      case MissionStatus.finished:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: CustomHeader(
        title: 'Toutes les Missions',
        rightIcon: Icons.add,
        onBack: () => Navigator.of(context).pop(),
        onRightIconTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const PublierMissionScreen()),
          );
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: _buildSearchBar(),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filteredMissions.length,
              itemBuilder: (context, index) {
                final mission = _filteredMissions[index];
                return _buildMissionCard(mission);
              },
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
            // Déjà sur Missions
            return;
          }
          if (index == 2) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const ProfilRecruteurScreen()),
            );
            return;
          }
          if (index == 3) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MessageConversationScreen()),
            );
            return;
          }
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Rechercche',
          hintStyle: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey.shade500,
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildMissionCard(Mission mission) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DetailMissionRecruteurScreen(
              missionData: {
                'title': mission.title,
                'candidateCount': mission.candidateCount,
                'status': mission.status,
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                mission.icon,
                color: primaryBlue,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mission.title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${mission.candidateCount} Candidatures',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(mission.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getStatusColor(mission.status).withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      _getStatusLabel(mission.status),
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(mission.status),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => DetailMissionRecruteurScreen(
                      missionData: {
                        'title': mission.title,
                        'candidateCount': mission.candidateCount,
                        'status': mission.status,
                      },
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.visibility_outlined,
                  color: Colors.black54,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


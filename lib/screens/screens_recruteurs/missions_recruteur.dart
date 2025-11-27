import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/custom_bottom_nav_bar_recruteur.dart';
import 'publier_mission.dart';
import 'detail_mission_recruteur.dart';
import 'candidature_missions.dart';
import 'message_conversation_recruteur.dart';
import 'home_recruteur.dart';
import 'profil_recruteur.dart';
import '../../services/user_service.dart';
import '../../models/mission_recruteur_response.dart' as mr;
import '../../config/api_config.dart';
import '../../services/mission_service.dart';

const Color primaryGreen = Color(0xFF10B981);
const Color primaryBlue = Color(0xFF2563EB);
const Color bodyBackgroundColor = Color(0xFFf6fcfc);
const Color badgeOrange = Color(0xFFF59E0B);

enum MissionStatus { pending, inProgress, finished }

class MissionsRecruteurScreen extends StatefulWidget {
  const MissionsRecruteurScreen({super.key});

  @override
  State<MissionsRecruteurScreen> createState() => _MissionsRecruteurScreenState();
}

class _MissionsRecruteurScreenState extends State<MissionsRecruteurScreen> {
  int _selectedIndex = 1;
  String _searchQuery = '';
  bool _isLoading = true;
  bool _hasError = false;
  List<mr.Mission> _allMissions = [];

  @override
  void initState() {
    super.initState();
    _loadMissions();
  }

  Future<void> _loadMissions() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
      final response = await UserService.getMesMissions();
      setState(() {
        _allMissions = response.data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  List<mr.Mission> get _filteredMissions {
    // Filtrer d'abord les missions annulées
    final activeMissions = _allMissions.where((m) {
      final s = m.statut.toUpperCase();
      return !s.contains('ANNULE') && !s.contains('CANCEL');
    }).toList();

    if (_searchQuery.isEmpty) {
      return activeMissions;
    }
    return activeMissions
        .where((mission) => mission.titre.toLowerCase().contains(_searchQuery.toLowerCase()))
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

  MissionStatus _mapStatus(String statut) {
    final s = statut.toUpperCase();
    if (s.contains('EN_ATTENTE') || s.contains('PENDING')) return MissionStatus.pending;
    if (s.contains('EN_COURS') || s.contains('IN_PROGRESS')) return MissionStatus.inProgress;
    if (s.contains('TERMINE') || s.contains('FINISHED')) return MissionStatus.finished;
    return MissionStatus.pending;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bodyBackgroundColor,
        appBar: CustomHeader(
          title: 'Toutes les Missions',
          rightIcon: Icons.add,
          onBack: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeRecruteurScreen()),
            );
          },
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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: primaryGreen))
                  : _hasError
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline, color: Colors.red, size: 48),
                              const SizedBox(height: 8),
                              Text('Erreur de chargement', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              ElevatedButton(onPressed: _loadMissions, child: const Text('Réessayer')),
                            ],
                          ),
                        )
                      : ListView.builder(
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

  String? _convertPhotoPathToUrl(String? photoPath) {
    if (photoPath == null || photoPath.isEmpty) return null;
    
    // Si c'est déjà une URL HTTP, retourner tel quel
    if (photoPath.startsWith('http://') || photoPath.startsWith('https://')) {
      return photoPath;
    }
    
    // Si c'est un chemin local Windows avec "uploads", convertir en URL
    if (photoPath.contains('uploads')) {
      String base = ApiConfig.baseUrl;
      if (base.endsWith('/')) base = base.substring(0, base.length - 1);
      
      // Trouver l'index de "uploads" et extraire la partie après
      final uploadsIndex = photoPath.indexOf('uploads');
      if (uploadsIndex != -1) {
        // Extraire la partie après "uploads" (incluant le slash ou backslash)
        String relativePath = photoPath.substring(uploadsIndex + 'uploads'.length);
        // Normaliser les séparateurs de chemin
        relativePath = relativePath.replaceAll('\\', '/');
        // S'assurer qu'on commence par un slash
        if (!relativePath.startsWith('/')) {
          relativePath = '/$relativePath';
        }
        // Construire l'URL complète
        final url = '$base/uploads$relativePath';
        print('🖼️ Conversion chemin: $photoPath -> $url');
        return url;
      }
    }
    
    // Si le chemin commence directement par "uploads", ajouter juste l'URL de base
    if (photoPath.startsWith('uploads')) {
      String base = ApiConfig.baseUrl;
      if (base.endsWith('/')) base = base.substring(0, base.length - 1);
      String url = '$base/$photoPath';
      url = url.replaceAll('\\', '/');
      return url;
    }
    
    return null;
  }

  Widget _buildMissionCard(mr.Mission mission) {
    return GestureDetector(
      onTap: () async {
        final deleted = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => DetailMissionRecruteurScreen(
              missionData: {
                'missionId': mission.id,
                'missionTitle': mission.titre,
                'description': mission.description,
                'competences': mission.exigence,
                'latitude': mission.latitude,
                'longitude': mission.longitude,
                'location': mission.adresse,
                'dateDebut': mission.dateDebut, // yyyy-MM-dd
                'dateFin': mission.dateFin, // yyyy-MM-dd
                'timeFrom': mission.heureDebut,
                'timeTo': mission.heureFin,
                'statut': mission.statut,
              },
            ),
          ),
        );
        if (deleted == true) {
          _loadMissions();
        }
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: Image.network(
                      _convertPhotoPathToUrl(mission.categorieUrlPhoto) ?? '',
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: primaryBlue.withOpacity(0.08),
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2, color: primaryBlue),
                          ),
                        );
                      },
                      errorBuilder: (c, e, s) {
                        print('❌ Erreur chargement image: ${_convertPhotoPathToUrl(mission.categorieUrlPhoto)}');
                        print('   Erreur: $e');
                        return Container(
                          color: primaryBlue.withOpacity(0.08),
                          child: const Icon(Icons.image_not_supported, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              mission.titre,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(_mapStatus(mission.statut)).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _getStatusColor(_mapStatus(mission.statut)).withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              _getStatusLabel(_mapStatus(mission.statut)),
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: _getStatusColor(_mapStatus(mission.statut)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${mission.nombreCandidatures} Candidatures',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Bouton Annuler (Seulement si en attente)
                if (_mapStatus(mission.statut) == MissionStatus.pending) ...[
                  GestureDetector(
                    onTap: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) {
                          return Dialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 54,
                                    height: 54,
                                    decoration: BoxDecoration(color: Colors.red.withOpacity(0.12), shape: BoxShape.circle),
                                    child: const Icon(Icons.delete_outline, color: Colors.red, size: 30),
                                  ),
                                  const SizedBox(height: 12),
                                  Text('Annuler la mission', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Voulez-vous vraiment annuler cette mission ?',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
                                  ),
                                  const SizedBox(height: 14),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () => Navigator.of(ctx).pop(false),
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(color: Colors.grey.shade300),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                          ),
                                          child: Text('Non', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87)),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () => Navigator.of(ctx).pop(true),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                          ),
                                          child: Text('Oui, Annuler', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );

                      if (confirmed == true) {
                        try {
                          // Utilisation de la nouvelle méthode cancelMission (PUT)
                          final success = await MissionService.cancelMission(mission.id);
                          if (success) {
                            if (!context.mounted) return;
                            await showDialog(
                              context: context,
                              builder: (ctx) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 54,
                                          height: 54,
                                          decoration: BoxDecoration(color: primaryGreen.withOpacity(0.15), shape: BoxShape.circle),
                                          child: const Icon(Icons.check, color: primaryGreen, size: 30),
                                        ),
                                        const SizedBox(height: 12),
                                        Text('Mission annulée', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
                                        const SizedBox(height: 6),
                                        Text(
                                          'La mission a été annulée avec succès.',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
                                        ),
                                        const SizedBox(height: 14),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 42,
                                          child: ElevatedButton(
                                            onPressed: () => Navigator.of(ctx).pop(),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: primaryGreen,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            ),
                                            child: Text('OK', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                            _loadMissions();
                          } else {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Erreur lors de l\'annulation'), backgroundColor: Colors.red),
                            );
                          }
                        } catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
                          );
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.withOpacity(0.25)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.cancel_outlined, color: Colors.red, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            'Annuler',
                            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                // Bouton Candidatures
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CandidatureMissionsScreen(
                          missionTitle: mission.titre,
                          missionId: mission.id,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: primaryGreen.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: primaryGreen.withOpacity(0.25)),
                      boxShadow: [
                        BoxShadow(
                          color: primaryGreen.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.people_outline, color: primaryGreen, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          'Candidatures',
                          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: primaryGreen),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Bouton Détails
                GestureDetector(
                  onTap: () async {
                    final deleted = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (_) => DetailMissionRecruteurScreen(
                          missionData: {
                            'missionId': mission.id,
                            'missionTitle': mission.titre,
                            'description': mission.description,
                            'competences': mission.exigence,
                            'latitude': mission.latitude,
                            'longitude': mission.longitude,
                            'location': mission.adresse,
                            'dateDebut': mission.dateDebut,
                            'dateFin': mission.dateFin,
                            'timeFrom': mission.heureDebut,
                            'timeTo': mission.heureFin,
                            'statut': mission.statut,
                          },
                        ),
                      ),
                    );
                    if (deleted == true) {
                      _loadMissions();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: primaryBlue.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: primaryBlue.withOpacity(0.25)),
                      boxShadow: [
                        BoxShadow(
                          color: primaryBlue.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: primaryBlue, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          'Détails',
                          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: primaryBlue),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/custom_header.dart';
import 'profil_candidat.dart';
import 'signaler_candidat_placeholder.dart';

const Color primaryGreen = Color(0xFF10B981);
const Color bodyBackgroundColor = Color(0xFFf6fcfc);

class CandidatureMissionsScreen extends StatefulWidget {
  final String missionTitle;

  const CandidatureMissionsScreen({super.key, required this.missionTitle});

  @override
  State<CandidatureMissionsScreen> createState() => _CandidatureMissionsScreenState();
}

class _CandidatureMissionsScreenState extends State<CandidatureMissionsScreen> {
  int _selectedTabIndex = 0; // 0: tout, 1: valider, 2: rejeter

  final List<_Candidate> _allCandidates = [
    _Candidate(name: 'Ramatou Konaré', motivation: 'Je suis très motivée par cette mission...', status: _CandidateStatus.validated),
    _Candidate(name: 'Jean Dupont', motivation: 'Disponible le matin et l’après-midi.', status: _CandidateStatus.pending),
    _Candidate(name: 'Awa Traoré', motivation: 'Expérience en aide ménagère.', status: _CandidateStatus.pending),
    _Candidate(name: 'Moussa Keita', motivation: 'Bonne condition physique.', status: _CandidateStatus.rejected),
    _Candidate(name: 'Fatoumata D.', motivation: 'Je peux commencer dès demain.', status: _CandidateStatus.pending),
  ];

  @override
  Widget build(BuildContext context) {
    final counts = _computeCounts();
    final filtered = _filteredCandidates();

    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: CustomHeader(
        title: 'Candidats : ${widget.missionTitle}',
        onBack: () => Navigator.of(context).pop(),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            _buildTabs(counts),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) => _buildCandidateCard(filtered[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, int> _computeCounts() {
    final int total = _allCandidates.length;
    final int validated = _allCandidates.where((c) => c.status == _CandidateStatus.validated).length;
    final int rejected = _allCandidates.where((c) => c.status == _CandidateStatus.rejected).length;
    return {
      'total': total,
      'validated': validated,
      'rejected': rejected,
    };
  }

  List<_Candidate> _filteredCandidates() {
    if (_selectedTabIndex == 1) {
      return _allCandidates.where((c) => c.status == _CandidateStatus.validated).toList();
    }
    if (_selectedTabIndex == 2) {
      return _allCandidates.where((c) => c.status == _CandidateStatus.rejected).toList();
    }
    return _allCandidates;
  }

  Widget _buildTabs(Map<String, int> counts) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTabButton(label: 'Tout (${counts['total']})', index: 0),
        _buildTabButton(label: 'Valider (${counts['validated']})', index: 1),
        _buildTabButton(label: 'Réjeter (${counts['rejected']})', index: 2),
      ],
    );
  }

  Widget _buildTabButton({required String label, required int index}) {
    final bool isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: Container(
          height: 34,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isSelected ? 0.08 : 0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.black : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCandidateCard(_Candidate c) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProfilCandidatScreen(
              name: c.name,
              motivation: c.motivation,
              rating: 4.8,
              competences: const ['Manutention', 'Livraison', 'Aide à Domicile', 'Menuisier', 'Vente'],
              missionTitle: widget.missionTitle,
            ),
          ),
        );
      },
      child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
        child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: primaryGreen.withOpacity(0.2),
              backgroundImage: const AssetImage('assets/images/image_profil.png'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          c.name,
                          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.more_vert, size: 18, color: Colors.black45),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        itemBuilder: (context) => <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'voir_profil',
                            child: Text('Voir Profil', style: GoogleFonts.poppins(fontSize: 13)),
                          ),
                          const PopupMenuDivider(height: 1),
                          PopupMenuItem<String>(
                            value: 'signaler',
                            child: Text('Signaler', style: GoogleFonts.poppins(fontSize: 13)),
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 'voir_profil') {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ProfilCandidatScreen(
                                  name: c.name,
                                  motivation: c.motivation,
                                  rating: 4.8,
                                  competences: const ['Manutention', 'Livraison', 'Aide à Domicile', 'Menuisier', 'Vente'],
                                  missionTitle: widget.missionTitle,
                                ),
                              ),
                            );
                          } else if (value == 'signaler') {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const SignalerCandidatPlaceholder(),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        height: 6,
                        width: 6,
                        decoration: BoxDecoration(
                          color: c.status == _CandidateStatus.validated
                              ? primaryGreen
                              : (c.status == _CandidateStatus.rejected ? Colors.redAccent : Colors.orange),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _statusLabel(c.status),
                        style: GoogleFonts.poppins(fontSize: 11, color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    c.motivation,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  String _statusLabel(_CandidateStatus s) {
    switch (s) {
      case _CandidateStatus.validated:
        return 'Validé';
      case _CandidateStatus.rejected:
        return 'Rejeté';
      case _CandidateStatus.pending:
      default:
        return 'En attente';
    }
  }
}

enum _CandidateStatus { pending, validated, rejected }

class _Candidate {
  final String name;
  final String motivation;
  final _CandidateStatus status;

  _Candidate({required this.name, required this.motivation, required this.status});
}



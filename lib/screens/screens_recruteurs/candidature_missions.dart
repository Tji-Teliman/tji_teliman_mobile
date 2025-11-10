import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/custom_header.dart';
import '../../config/api_config.dart';
import '../../services/user_service.dart';
import 'profil_candidat.dart';
import 'signaler_candidat_placeholder.dart';

const Color primaryGreen = Color(0xFF10B981);
const Color bodyBackgroundColor = Color(0xFFf6fcfc);

class CandidatureMissionsScreen extends StatefulWidget {
  final String missionTitle;
  final int? missionId;

  const CandidatureMissionsScreen({super.key, required this.missionTitle, this.missionId});

  @override
  State<CandidatureMissionsScreen> createState() => _CandidatureMissionsScreenState();
}

class _CandidatureMissionsScreenState extends State<CandidatureMissionsScreen> {
  int _selectedTabIndex = 0; // 0: tout, 1: valider, 2: rejeter

  final List<_Candidate> _allCandidates = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCandidatures();
  }

  String? _toHttpUrl(String raw) {
    if (raw.isEmpty) return null;
    // Normalise les backslashes et isole le segment /uploads/...
    final normalised = raw.replaceAll('\\', '/');
    final idx = normalised.toLowerCase().indexOf('/uploads/');
    final path = idx >= 0 ? normalised.substring(idx) : normalised;
    // Si c'est déjà une URL http(s), retourner tel quel
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    // Concaténer avec la baseUrl (qui inclut déjà l’hôte)
    final base = ApiConfig.baseUrl.endsWith('/') ? ApiConfig.baseUrl.substring(0, ApiConfig.baseUrl.length - 1) : ApiConfig.baseUrl;
    final p = path.startsWith('/') ? path : '/$path';
    return '$base$p';
  }

  Future<void> _fetchCandidatures() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    if (widget.missionId == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Identifiant de mission manquant";
      });
      return;
    }
    try {
      final data = await UserService.getCandidaturesParMission(widget.missionId!);
      final mapped = data.map((e) {
        final int? candidatureId = (e['id'] is int)
            ? e['id'] as int
            : (e['id'] is String ? int.tryParse(e['id']) : null);
        final prenom = (e['jeunePrestateurPrenom'] ?? '').toString();
        final nom = (e['jeunePrestateurNom'] ?? '').toString();
        final photo = e['jeunePrestateurUrlPhoto'];
        final motivation = (e['motivationContenu'] ?? '').toString();
        final statut = (e['statut'] ?? '').toString();
        return _Candidate(
          id: candidatureId,
          name: [prenom, nom].where((s) => s.trim().isNotEmpty).join(' ').trim(),
          motivation: motivation.isEmpty ? 'Aucune motivation fournie' : motivation,
          status: _mapBackendStatus(statut),
          photoUrl: (photo is String) ? _toHttpUrl(photo) : null,
        );
      }).toList();
      if (!mounted) return;
      setState(() {
        _allCandidates
          ..clear()
          ..addAll(mapped);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
      });
    }
  }

  _CandidateStatus _mapBackendStatus(String statut) {
    switch (statut.toUpperCase()) {
      case 'ACCEPTEE':
      case 'ACCEPTÉE':
      case 'ACCEPTE':
      case 'ACCEPTÉ':
        return _CandidateStatus.validated;
      case 'REFUSEE':
      case 'REFUSÉE':
      case 'REFUSE':
      case 'REFUSÉ':
        return _CandidateStatus.rejected;
      case 'EN_ATTENTE':
      default:
        return _CandidateStatus.pending;
    }
  }

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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : (_errorMessage != null)
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(color: Colors.redAccent),
                            ),
                          ),
                        )
                      : ListView.separated(
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
              candidatureId: c.id!,
              missionTitle: widget.missionTitle,
              missionId: widget.missionId,
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
              backgroundImage: (c.photoUrl != null && c.photoUrl!.startsWith('http'))
                  ? NetworkImage(c.photoUrl!)
                  : null,
              child: (c.photoUrl == null || !c.photoUrl!.startsWith('http'))
                  ? const Icon(Icons.person, color: Colors.white)
                  : null,
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
                                  candidatureId: c.id!,
                                  missionTitle: widget.missionTitle,
                                  missionId: widget.missionId,
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
  final int? id;
  final String name;
  final String motivation;
  final _CandidateStatus status;
  final String? photoUrl;

  _Candidate({required this.id, required this.name, required this.motivation, required this.status, this.photoUrl});
}



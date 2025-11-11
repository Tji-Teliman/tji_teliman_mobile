import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/api_config.dart';
import '../../services/user_service.dart';
import 'candidature_missions.dart';
import 'chat_screen_recruteur.dart';

const Color primaryGreen = Color(0xFF27AE60); // demandé: 27AE60
const Color bodyBackgroundColor = Color(0xFFf6fcfc);

class ProfilCandidatScreen extends StatefulWidget {
  final int candidatureId;
  final String missionTitle;
  final int? missionId;

  const ProfilCandidatScreen({
    super.key,
    required this.candidatureId,
    required this.missionTitle,
    this.missionId,
  });

  @override
  State<ProfilCandidatScreen> createState() => _ProfilCandidatScreenState();
}

class _ProfilCandidatScreenState extends State<ProfilCandidatScreen> {
  String? _name;
  String? _motivation;
  double _rating = 0.0;
  int _ratingsCount = 0;
  List<String> _competences = [];
  String? _photoUrl;
  bool _isValidated = false;
  bool _isRejected = false;
  bool _loading = true;
  String? _error;
  bool _acting = false;
  int? _jeuneId; // destinataireId pour le chat

  @override
  void initState() {
    super.initState();
    _fetchProfil();
  }

  int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is double) return v.toInt();
    final s = v.toString();
    if (s.isEmpty) return null;
    return int.tryParse(s);
  }

  int? _extractJeuneId(Map<String, dynamic> data) {
    final keys = [
      'jeuneId',
      'jeuneUserId',
      'userIdJeune',
      'jeune_id',
      'destinataireId',
      'destinataire_id',
    ];
    for (final k in keys) {
      if (data.containsKey(k)) {
        final val = _toInt(data[k]);
        if (val != null && val > 0) return val;
      }
    }
    return null;
  }

  Future<void> _fetchProfil() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await UserService.getProfilCandidature(widget.candidatureId);
      final prenom = (data['jeunePrenom'] ?? '').toString();
      final nom = (data['jeuneNom'] ?? '').toString();
      final photoRaw = data['jeuneUrlPhoto'];
      final motivation = (data['motivationContenu'] ?? '').toString();
      final statut = (data['statutCandidature'] ?? '').toString();
      final moyenne = data['moyenneNotes'];
      final nbEval = data['nombreEvaluations'];
      final jeuneId = _extractJeuneId(data);
      // Compétences: l'API renvoie 'competences' comme List<String>. Repli: 'jeuneCompetences' string "A, B, C"
      final compList = data['competences'];
      List<String> comps;
      if (compList is List) {
        comps = compList.map((e) => e.toString()).where((e) => e.trim().isNotEmpty).toList();
      } else {
        final compStr = data['jeuneCompetences'];
        comps = (compStr is String)
            ? compStr.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList()
            : <String>[];
      }

      if (!mounted) return;
      setState(() {
        _name = [prenom, nom].where((s) => s.trim().isNotEmpty).join(' ').trim();
        _photoUrl = (photoRaw is String) ? _toHttpUrl(photoRaw) : null;
        _motivation = motivation.isEmpty ? 'Aucune motivation fournie' : motivation;
        _isValidated = _mapValidated(statut);
        _isRejected = _mapRejected(statut);
        _rating = (moyenne is num) ? moyenne.toDouble() : 0.0;
        _ratingsCount = (nbEval is num) ? nbEval.toInt() : 0;
        _competences = comps;
        _loading = false;
        _jeuneId = jeuneId;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
        _loading = false;
      });
    }
  }

  bool _mapValidated(String statut) {
    switch (statut.toUpperCase()) {
      case 'ACCEPTEE':
      case 'ACCEPTÉE':
      case 'ACCEPTE':
      case 'ACCEPTÉ':
        return true;
      default:
        return false;
    }
  }

  bool _mapRejected(String statut) {
    switch (statut.toUpperCase()) {
      case 'REFUSEE':
      case 'REFUSÉE':
      case 'REFUSE':
      case 'REFUSÉ':
        return true;
      default:
        return false;
    }
  }

  String? _toHttpUrl(String raw) {
    if (raw.isEmpty) return null;
    final normalised = raw.replaceAll('\\', '/');
    final idx = normalised.toLowerCase().indexOf('/uploads/');
    final path = idx >= 0 ? normalised.substring(idx) : normalised;
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    final base = ApiConfig.baseUrl.endsWith('/') ? ApiConfig.baseUrl.substring(0, ApiConfig.baseUrl.length - 1) : ApiConfig.baseUrl;
    final p = path.startsWith('/') ? path : '/$path';
    return '$base$p';
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double headerHeight = screenHeight * 0.33;

    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildHeader(context, headerHeight),
          ),

          Positioned(
            top: headerHeight - 40,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: bodyBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_loading)
                        Center(child: Padding(padding: const EdgeInsets.all(16), child: CircularProgressIndicator(color: primaryGreen)))
                      else if (_error != null)
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Text(_error!, style: GoogleFonts.poppins(color: Colors.redAccent)),
                        )
                      else ...[
                        _buildMessageCard(),
                        const SizedBox(height: 16),
                        _buildCompetencesCard(),
                        const SizedBox(height: 24),
                        _buildActions(context),
                        const SizedBox(height: 20),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double height) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/header_home.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Top bar: back + title and hint link
          Positioned(
            top: 18,
            left: 12,
            right: 12,
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Profil de ${_name ?? '...'}',
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Voir profil complet',
                          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),
          ),

          // Avatar + name + rating
          Positioned(
            top: height * 0.32,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: primaryGreen.withOpacity(0.2),
                  backgroundImage: (_photoUrl != null && _photoUrl!.startsWith('http')) ? NetworkImage(_photoUrl!) : null,
                  child: (_photoUrl == null || !_photoUrl!.startsWith('http')) ? const Icon(Icons.person, color: Colors.white, size: 40) : null,
                ),
                const SizedBox(height: 8),
                Text(
                  _name ?? '...',
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text('${_rating.toStringAsFixed(1)}/5.0 (${_ratingsCount})', style: GoogleFonts.poppins(color: Colors.white, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Message pour la mission', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Text(
              _motivation ?? '-',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87, height: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompetencesCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.workspace_premium_outlined, size: 18, color: Colors.black87),
                const SizedBox(width: 6),
                Text('Compétences', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87)),
              ],
            ),
            const SizedBox(height: 10),
            if (_competences.isEmpty)
              Text('Aucune compétence fournie', style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54))
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _competences.map((c) => _chip(c)).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: primaryGreen,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label, style: GoogleFonts.poppins(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildActions(BuildContext context) {
    if (_isValidated) {
      // Bouton de communication pour les candidatures validées
      return SizedBox(
        height: 46,
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            final destId = _jeuneId;
            if (destId == null || destId <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Impossible d'ouvrir le chat: ID du jeune introuvable")),
              );
              return;
            }
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  interlocutorName: _name ?? 'Jeune',
                  destinataireId: destId,
                  interlocutorPhotoUrl: _photoUrl,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: const Icon(Icons.chat_bubble, color: Colors.white, size: 22),
          label: Text(
            'Communiquer avec le jeune',
            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
      );
    }

    if (_isRejected) {
      // Aucune action pour les candidatures rejetées
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.red, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Cette candidature a été rejetée',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    // Boutons sélectionner et rejeter pour les candidatures en attente
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 46,
            child: ElevatedButton(
              onPressed: _acting
                  ? null
                  : () async {
                      setState(() => _acting = true);
                      try {
                        final ok = await UserService.validerCandidature(widget.candidatureId);
                        if (!mounted) return;
                        if (ok) {
                          setState(() {
                            _isValidated = true;
                            _isRejected = false;
                          });
                          _showResultDialog(
                            context,
                            title: 'Candidat sélectionné',
                            message: 'Votre sélection a été enregistrée avec succès.',
                            color: primaryGreen,
                            icon: Icons.check,
                          );
                        }
                      } catch (e) {
                        if (!mounted) return;
                        _showResultDialog(
                          context,
                          title: 'Erreur',
                          message: e.toString().replaceFirst(RegExp(r'^Exception:\s*'), ''),
                          color: Colors.red,
                          icon: Icons.error_outline,
                        );
                      } finally {
                        if (mounted) setState(() => _acting = false);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _acting
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text('Sélectionner ce jeune', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 46,
            child: ElevatedButton(
              onPressed: _acting
                  ? null
                  : () async {
                      setState(() => _acting = true);
                      try {
                        final ok = await UserService.rejeterCandidature(widget.candidatureId);
                        if (!mounted) return;
                        if (ok) {
                          setState(() {
                            _isRejected = true;
                            _isValidated = false;
                          });
                          _showResultDialog(
                            context,
                            title: 'Candidature rejetée',
                            message: 'Le rejet a été enregistré avec succès.',
                            color: const Color(0xFFFF3E3E).withOpacity(0.83),
                            icon: Icons.close,
                          );
                        }
                      } catch (e) {
                        if (!mounted) return;
                        _showResultDialog(
                          context,
                          title: 'Erreur',
                          message: e.toString().replaceFirst(RegExp(r'^Exception:\s*'), ''),
                          color: Colors.red,
                          icon: Icons.error_outline,
                        );
                      } finally {
                        if (mounted) setState(() => _acting = false);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF3E3E).withOpacity(0.83), // demandé: FF3E3E à 83% opacité
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _acting
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text('Rejeter', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ],
    );
  }
  
  void _showResultDialog(
    BuildContext context, {
    required String title,
    required String message,
    required Color color,
    required IconData icon,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
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
                  decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
                  child: Icon(icon, color: color, size: 30),
                ),
                const SizedBox(height: 12),
                Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => CandidatureMissionsScreen(
                            missionTitle: widget.missionTitle,
                            missionId: widget.missionId,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
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
  }
}



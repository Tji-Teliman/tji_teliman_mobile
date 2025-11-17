import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/custom_header.dart';
import 'paiement.dart';
import '../../services/mission_service.dart';
import '../../services/user_service.dart';
import '../../services/payment_service.dart';
import 'noter_jeune.dart';

const Color bodyBackgroundColor = Color(0xFFf6fcfc);
const Color primaryGreen = Color(0xFF10B981);

class ModePaiementScreen extends StatefulWidget {
  final int missionId;
  final int? candidatureId;

  const ModePaiementScreen({
    super.key,
    required this.missionId,
    this.candidatureId,
  });

  @override
  State<ModePaiementScreen> createState() => _ModePaiementScreenState();
}

class _ModePaiementScreenState extends State<ModePaiementScreen> {
  bool _loading = true;
  String _missionTitle = '';
  String _amountText = '';
  String _jeuneName = '';
  String _jeunePhone = '';
  int? _candidatureId;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // 1) Try to get payment info directly from EN_ATTENTE payments
      final paiements = await PaymentService.getPaiementsEnAttente();
      Map<String, dynamic>? paiement;
      // Prefer matching by missionId; fallback by candidatureId if provided
      for (final p in paiements) {
        final mid = int.tryParse((p['missionId'] ?? '').toString()) ?? p['missionId'] as int?;
        if (mid != null && mid == widget.missionId) { paiement = p; break; }
      }

      if (paiement == null && widget.candidatureId != null) {
        for (final p in paiements) {
          final cid = int.tryParse((p['candidatureId'] ?? '').toString()) ?? p['candidatureId'] as int?;
          if (cid != null && cid == widget.candidatureId) { paiement = p; break; }
        }
      }

      if (paiement == null && paiements.isNotEmpty) {
        paiement = paiements.first;
      }

      if (paiement != null) {
        // Mission title
        _missionTitle = (paiement['missionTitre'] ?? '').toString();
        // Amount: prefer missionRemuneration then montant
        double? montantDouble;
        final mr = paiement['missionRemuneration'];
        if (mr != null) {
          montantDouble = mr is num ? mr.toDouble() : double.tryParse(mr.toString());
        }
        if (montantDouble == null) {
          final m = paiement['montant'];
          if (m != null) montantDouble = m is num ? m.toDouble() : double.tryParse(m.toString());
        }
        if (montantDouble != null) {
          final formatted = montantDouble.toStringAsFixed(0).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]} ',
          );
          _amountText = '$formatted CFA';
        }

        // Jeune name directly from paiement entry (robust)
        String pPrenom = (paiement['jeunePrestateurPrenom']
              ?? paiement['jeunePrestatairePrenom']
              ?? paiement['jeunePrenom']
              ?? paiement['prenom']
              ?? '')
            .toString();
        String pNom = (paiement['jeunePrestateurNom']
              ?? paiement['jeunePrestataireNom']
              ?? paiement['jeuneNom']
              ?? paiement['nom']
              ?? '')
            .toString();
        String pFull = '';
        if (paiement['jeune'] is Map<String, dynamic>) {
          final j = paiement['jeune'] as Map<String, dynamic>;
          if (pPrenom.trim().isEmpty) pPrenom = (j['prenom'] ?? j['firstName'] ?? '').toString();
          if (pNom.trim().isEmpty) pNom = (j['nom'] ?? j['lastName'] ?? '').toString();
          pFull = (j['nomComplet'] ?? j['fullName'] ?? '').toString();
        }
        String full = [pPrenom, pNom].where((s) => s.trim().isNotEmpty).join(' ').trim();
        if (full.isEmpty && (paiement['jeuneNomComplet'] != null)) {
          full = paiement['jeuneNomComplet'].toString();
        }
        if (full.isNotEmpty) {
          _jeuneName = full;
        }

        // Phone number from paiement (prefer jeunePrestateurTelephone, fallback telephone)
        final tel = (paiement['jeunePrestateurTelephone'] ?? paiement['telephone'] ?? '').toString();
        if (tel.trim().isNotEmpty) {
          _jeunePhone = tel.trim();
        }

        // Candidature id
        final cidAny = paiement['candidatureId'];
        if (cidAny != null) {
          final parsed = int.tryParse(cidAny.toString());
          if (parsed != null) _candidatureId = parsed; else if (cidAny is int) _candidatureId = cidAny as int;
        }
      } else {
        // 2) Fallback to mission + candidature lookup if no paiement matched
        final missionResp = await MissionService.getMissionById(widget.missionId);
        _missionTitle = missionResp.data.titre;
        final montant = missionResp.data.remuneration;
        if (montant != null) {
          final formatted = montant.toStringAsFixed(0).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]} ',
          );
          _amountText = '$formatted CFA';
        }
      }

      // Selected candidate name (accepted candidature)
      String extractName(Map<String, dynamic> data) {
        String prenom = '';
        String nom = '';
        String fullName = '';
        // flat fields
        prenom = (data['jeunePrenom'] ?? data['prenom'] ?? data['prenomJeune'] ?? data['firstName'] ?? '').toString();
        nom = (data['jeuneNom'] ?? data['nom'] ?? data['nomJeune'] ?? data['lastName'] ?? '').toString();
        fullName = (data['jeuneNomComplet'] ?? data['nomComplet'] ?? data['fullName'] ?? '').toString();
        // nested jeune object
        if ((prenom.isEmpty || nom.isEmpty) && data['jeune'] is Map<String, dynamic>) {
          final j = data['jeune'] as Map<String, dynamic>;
          prenom = prenom.isEmpty ? ((j['prenom'] ?? j['firstName'] ?? '').toString()) : prenom;
          nom = nom.isEmpty ? ((j['nom'] ?? j['lastName'] ?? '').toString()) : nom;
          if (fullName.isEmpty) {
            fullName = (j['nomComplet'] ?? j['fullName'] ?? '').toString();
          }
        }
        String name = [prenom, nom].where((s) => s.trim().isNotEmpty).join(' ').trim();
        if (name.isEmpty && fullName.trim().isNotEmpty) name = fullName.trim();
        return name;
      }

      bool isAcceptedStatusDynamic(Map<String, dynamic> c) {
        // text status
        final raw = (c['statut'] ?? c['statutCandidature'] ?? c['etat'] ?? c['status'] ?? '').toString();
        final u = raw.toUpperCase();
        // booleans commonly used
        final b = [
          c['valide'], c['validated'], c['isValidated'],
          c['accepte'], c['accepted'], c['isAccepted'],
          c['selectionne'], c['selected'], c['isSelected'],
          c['approuve'], c['approved'], c['isApproved'],
        ];
        final anyTrue = b.any((e) => e is bool && e == true);
        if (anyTrue) return true;
        // text variants
        return u.contains('ACCEPT') || u.contains('VALID') || u.contains('SÉLECT') || u.contains('SELEC') || u.contains('APPROUV');
      }

      // Fallback to candidature/profile only if name still empty
      if (_jeuneName.trim().isEmpty) {
        if (widget.candidatureId != null) {
          final profil = await UserService.getProfilCandidature(widget.candidatureId!);
          final name = extractName(profil);
          if (name.isNotEmpty) _jeuneName = name;
        } else {
          try {
            final candidatures = await UserService.getCandidaturesParMission(widget.missionId);
            Map<String, dynamic>? accepted;
            for (final c in candidatures) {
              if (isAcceptedStatusDynamic(c)) { accepted = c; break; }
            }
            if (accepted != null) {
              final name = extractName(accepted);
              if (name.isNotEmpty) _jeuneName = name;
            }
          } catch (_) {}
        }
      }
    } catch (e) {
      _error = e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
    } finally {
      if (!mounted) return;
      setState(() { _loading = false; });
    }
  }

  void _handleOrangeMoneyPayment() async {
    // Navigate to Orange Money payment confirmation
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaiementScreen(
          jeune: _jeuneName.isNotEmpty ? _jeuneName : '-',
          mission: _missionTitle.isNotEmpty ? _missionTitle : '-',
          montant: _amountText.isNotEmpty ? _amountText : '-',
          phone: _jeunePhone.isNotEmpty ? _jeunePhone : null,
          candidatureId: _candidatureId ?? widget.candidatureId,
        ),
      ),
    );
    if (!mounted) return;
    if (result == true) {
      Navigator.of(context).pop(true);
      return;
    }
    if (result is Map) {
      final map = Map<String, dynamic>.from(result as Map);
      final paid = map['paid'] == true;
      final goRate = map['rate'] == true;
      if (paid == true) {
        if (goRate == true) {
          // Navigate to rating screen with provided data first
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => NoterJeune(
                candidatureId: map['candidatureId'] as int?,
                jeuneName: (map['jeuneName'] ?? '-') as String,
                mission: (map['mission'] ?? '-') as String,
                montant: (map['montant'] ?? '-') as String,
                dateFin: (map['dateFin'] ?? '') as String,
              ),
            ),
          );
        }
        if (!mounted) return;
        Navigator.of(context).pop(true);
        return;
      }
    }
  }
  
  void _handleMoovMoneyPayment() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaiementScreen(
          jeune: _jeuneName.isNotEmpty ? _jeuneName : '-',
          mission: _missionTitle.isNotEmpty ? _missionTitle : '-',
          montant: _amountText.isNotEmpty ? _amountText : '-',
          phone: _jeunePhone.isNotEmpty ? _jeunePhone : null,
          candidatureId: _candidatureId ?? widget.candidatureId,
        ),
      ),
    );
    if (!mounted) return;
    if (result == true) {
      Navigator.of(context).pop(true);
      return;
    }
    if (result is Map) {
      final map = Map<String, dynamic>.from(result as Map);
      final paid = map['paid'] == true;
      final goRate = map['rate'] == true;
      if (paid == true) {
        if (goRate == true) {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => NoterJeune(
                candidatureId: map['candidatureId'] as int?,
                jeuneName: (map['jeuneName'] ?? '-') as String,
                mission: (map['mission'] ?? '-') as String,
                montant: (map['montant'] ?? '-') as String,
                dateFin: (map['dateFin'] ?? '') as String,
              ),
            ),
          );
        }
        if (!mounted) return;
        Navigator.of(context).pop(true);
        return;
      }
    }
  }

  void _handleWavePayment() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaiementScreen(
          jeune: _jeuneName.isNotEmpty ? _jeuneName : '-',
          mission: _missionTitle.isNotEmpty ? _missionTitle : '-',
          montant: _amountText.isNotEmpty ? _amountText : '-',
          phone: _jeunePhone.isNotEmpty ? _jeunePhone : null,
          candidatureId: _candidatureId ?? widget.candidatureId,
        ),
      ),
    );
    if (!mounted) return;
    if (result == true) {
      Navigator.of(context).pop(true);
      return;
    }
    if (result is Map) {
      final map = Map<String, dynamic>.from(result as Map);
      final paid = map['paid'] == true;
      final goRate = map['rate'] == true;
      if (paid == true) {
        if (goRate == true) {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => NoterJeune(
                candidatureId: map['candidatureId'] as int?,
                jeuneName: (map['jeuneName'] ?? '-') as String,
                mission: (map['mission'] ?? '-') as String,
                montant: (map['montant'] ?? '-') as String,
                dateFin: (map['dateFin'] ?? '') as String,
              ),
            ),
          );
        }
        if (!mounted) return;
        Navigator.of(context).pop(true);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: CustomHeader(
        title: 'Mode Paiement',
        onBack: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            if (_loading)
              Center(child: Padding(padding: const EdgeInsets.all(16), child: CircularProgressIndicator(color: primaryGreen)))
            else if (_error != null)
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(_error!, style: GoogleFonts.poppins(color: Colors.redAccent)),
              )
            else ...[
            
            // Mission summary text
            Text(
              'Choisissez votre mode de paiement pour la mission "${_missionTitle}".',
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            
            // Amount
            Text(
              'Montant: ${_amountText.isNotEmpty ? _amountText : '-'}.' ,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),
            
            // Payment details heading
            Text(
              'Détails du paiement:',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),
            
            // Jeune detail
            Row(
              children: [
                Text(
                  'Jeune:',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _jeuneName.isNotEmpty ? _jeuneName : '-',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            
            // Mission detail
            Row(
              children: [
                Text(
                  'Missions:',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _missionTitle.isNotEmpty ? _missionTitle : '-',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            
            // Orange Money card
            InkWell(
              onTap: _handleOrangeMoneyPayment,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFA500).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.phone_android, color: Color(0xFFFFA500)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Orange Money',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Paiement sécurisé via Orange Money',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Moov Money card
            InkWell(
              onTap: _handleMoovMoneyPayment,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.sim_card, color: Color(0xFF2563EB)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Moov Money',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Payer avec votre compte Moov',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Wave card
            InkWell(
              onTap: _handleWavePayment,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0EA5E9).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.waves, color: Color(0xFF0EA5E9)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Wave',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Payer rapidement via Wave',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            // Explanatory text
            Center(
              child: Text(
                'Votre choix déterminera comment la plateforme enregistre cette transaction.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
            ),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/custom_header.dart';
import 'paiement.dart';
import '../../services/mission_service.dart';
import '../../services/user_service.dart';
import '../../services/payment_service.dart';

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
    final paid = await Navigator.of(context).push(
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
    if (paid == true) {
      if (!mounted) return;
      Navigator.of(context).pop(true);
    }
  }

  void _handleCashPayment() {
    // Show confirmation dialog for cash payment
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white, // White background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Warning Icon (Triangle) in a circle
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withOpacity(0.37), // 37% opacity
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.warning,
                    color: const Color(0xFFF59E0B), // Orange color
                    size: 50,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Title "Confirmer le paiement en espèces"
                Text(
                  'Confirmer le paiement\nen espèces',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Explanatory text
                Text(
                  'En choisissant cette option, vous confirmez que le paiement a été effectué directement au jeune. En cas de litige, l\'équipe Tji Teliman se basera sur cette confirmation.',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Question
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Voulez-vous continuer ?',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Confirm Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      // Show success dialog
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: primaryGreen.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check_circle_outline,
                                      color: primaryGreen,
                                      size: 48,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Paiement en espèces confirmé',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Votre transaction a été enregistrée avec succès.',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Close dialog
                                        Navigator.of(context).pop(true); // Go back with success
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryGreen,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        'OK',
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
                            ),
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF59E0B), // Orange #F59E0B
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 4,
                      shadowColor: const Color(0xFFF59E0B).withOpacity(0.3),
                    ),
                    child: Text(
                      'Oui, confirme le paiement',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Cancel Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF59E0B).withOpacity(0.54), // 54% opacity
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child: Text(
                      'Annuler',
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
          ),
        );
      },
    );
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
            
            // Orange Money Payment Button (Green)
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _handleOrangeMoneyPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 4,
                  shadowColor: Colors.black.withOpacity(0.15),
                ),
                icon: const Icon(
                  Icons.phone_android,
                  color: Colors.white,
                  size: 24,
                ),
                label: Text(
                  'Payer via Orange Money',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            
            // Cash Payment Button (White with border)
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                onPressed: _handleCashPayment,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black87, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  backgroundColor: Colors.white,
                  elevation: 2,
                  shadowColor: Colors.black.withOpacity(0.1),
                ),
                icon: const Icon(
                  Icons.money,
                  color: Colors.black87,
                  size: 24,
                ),
                label: Text(
                  'J\'ai payé le jeune en espèces',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
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

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../widgets/custom_header.dart';
import '../../config/api_config.dart';
import '../../services/token_service.dart';
import 'package:google_fonts/google_fonts.dart';


class SignalerMission extends StatelessWidget {
  final int missionId;
  final String? missionTitle;

  const SignalerMission({super.key, required this.missionId, this.missionTitle});

  @override
  Widget build(BuildContext context) {
    return SignalMissionScreen(missionId: missionId, missionTitle: missionTitle);
  }
}

// Définition des couleurs personnalisées (récupérées de l'écran précédent)
const Color customOrange = Color(0xFFF59E0B);
const Color customBlue = Color(0xFF2563EB); // Bleu foncé de la barre d'App
const Color accentColor = Color(0xFF4DD0E1); // Bleu/Cyan pour le dégradé (maintenu pour d'autres éléments)
const Color lightBlueButton = Color(0xFFE3F2FD); // Couleur de fond des options

class SignalMissionScreen extends StatefulWidget {
  final int missionId;
  final String? missionTitle;

  const SignalMissionScreen({super.key, required this.missionId, this.missionTitle});

  @override
  State<SignalMissionScreen> createState() => _SignalMissionScreenState();
}

class _SignalMissionScreenState extends State<SignalMissionScreen> {
  // État pour gérer l'option de radio sélectionnée
  String? _selectedReason;
  // Contrôleur pour le champ de texte 'Précisions'
  final TextEditingController _precisionController = TextEditingController();
  bool _submitting = false;
  String? _errorMsg;

  // Liste des raisons de signalement
  final List<String> reasons = [
    "CONTENU_INAPPROPRIE_OU_MISSION_ILLEGAL",
    "ARNAQUE_OU_FRAUDE_POTENTIELLE",
    "DEMANDE_D_INFORMATIONS_PERSONNELLES",
    "NON_RESPECT_DES_CONDITIONS_D_UTILISATION",
    "PRIX_IRREALISTE_OU_INCOHERENT",
    "AUTRE",
  ];

  @override
  void dispose() {
    _precisionController.dispose();
    super.dispose();
  }

  String _mapReasonToType(String reason) {
    // If already an enum-like value, return as is
    if (RegExp(r'^[A-Z_]+$').hasMatch(reason)) return reason;
    final r = reason.toLowerCase();
    if (r.contains('inappropri') || r.contains('illégal') || r.contains('illegale')) {
      return 'CONTENU_INAPPROPRIE_OU_MISSION_ILLEGAL';
    }
    if (r.contains('arnaque') || r.contains('fraude')) return 'ARNAQUE_OU_FRAUDE_POTENTIELLE';
    if (r.contains("informations personnelles")) return 'DEMANDE_D_INFORMATIONS_PERSONNELLES';
    if (r.contains('conditions')) return 'NON_RESPECT_DES_CONDITIONS_D_UTILISATION';
    if (r.contains('prix')) return 'PRIX_IRREALISTE_OU_INCOHERENT';
    return 'AUTRE';
  }

  Future<void> _sendReport() async {
    if (_selectedReason == null) return;
    setState(() {
      _submitting = true;
      _errorMsg = null;
    });
    try {
      final String type = _mapReasonToType(_selectedReason!);
      final uri = Uri.parse('${ApiConfig.baseUrl}/api/signalements/missions/${widget.missionId}');
      final token = await TokenService.getToken();
      final body = <String, dynamic>{'type': type};
      final precision = _precisionController.text.trim();
      if (precision.isNotEmpty) body['description'] = precision;
      final resp = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: json.encode(body),
      );
      if (!mounted) return;
      if (resp.statusCode == 200 || resp.statusCode == 201) {
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
                      decoration: BoxDecoration(color: customBlue.withOpacity(0.15), shape: BoxShape.circle),
                      child: Icon(Icons.check, color: customBlue, size: 30),
                    ),
                    const SizedBox(height: 12),
                    Text('Signalement envoyé', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text(
                      'Merci, votre signalement a bien été transmis.',
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
                          backgroundColor: customBlue,
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
        Navigator.of(context).pop(true);
      } else {
        String msg = 'Erreur ${resp.statusCode}';
        try {
          final jsonErr = json.decode(resp.body);
          msg = jsonErr['message']?.toString() ?? msg;
        } catch (_) {}
        setState(() {
          _errorMsg = msg;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMsg = e.toString();
      });
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6fcfc), // Couleur de fond du CustomHeader
      appBar: CustomHeader(
        title: 'Signaler la mission',
        onBack: () => Navigator.of(context).pop(),
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- Mission Info ---
            Text(
              'Mission: ${widget.missionTitle ?? 'Aide Déménagement'}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),

            if (_errorMsg != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.08),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMsg!,
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // --- Titre Raison du signalement ---
            const Text(
              'Raison du signalement',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),

            // --- Liste des options de radio ---
            ...reasons.map((reason) => RadioOptionCard(
              title: reason,
              groupValue: _selectedReason,
              value: reason,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedReason = newValue;
                });
              },
            )).toList(),
            
            const SizedBox(height: 25),

            // --- Titre Précisions ---
            const Text(
              'Précisions',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),

            // --- Champ de texte pour les précisions ---
            TextField(
              controller: _precisionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Expliquez pourquoi vous trouvez cette mission suspecte',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                contentPadding: const EdgeInsets.all(15.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: customBlue, width: 2),
                ),
                fillColor: Colors.grey.shade50,
                filled: true,
              ),
            ),
            
            const SizedBox(height: 20),

            // --- Boutons Annuler et Envoyer ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Bouton Annuler (Bleu clair et texte bleu)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Logique d'annulation (peut fermer l'écran)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Annulation du signalement"))
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: lightBlueButton,
                      side: const BorderSide(color: customBlue),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text(
                      'ANNULER',
                      style: TextStyle(color: customBlue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                // Bouton Envoyer (Bleu foncé plein)
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedReason == null || _submitting ? null : _sendReport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: customBlue,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 2,
                    ),
                    child: _submitting
                        ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text(
                            'ENVOYER',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}


// Widget pour chaque option de radio avec un style de carte
class RadioOptionCard extends StatelessWidget {
  final String title;
  final String? groupValue;
  final String value;
  final ValueChanged<String?> onChanged;

  const RadioOptionCard({
    super.key,
    required this.title,
    required this.groupValue,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = groupValue == value;
    
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? lightBlueButton.withOpacity(0.5) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? customBlue : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: <Widget>[
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: customBlue,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // Pour réduire la zone de clic par défaut
            ),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

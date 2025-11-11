import 'package:flutter/material.dart';
import '../../widgets/custom_header.dart';
import '../../services/notation_service.dart';



class NoterRecruteur extends StatelessWidget {
  final int? candidatureId;
  final String? missionTitle;
  final String? endDate;
  final String? amount;

  const NoterRecruteur({super.key, this.candidatureId, this.missionTitle, this.endDate, this.amount});

  @override
  Widget build(BuildContext context) {
    return RecruiterEvaluationScreen(
      candidatureId: candidatureId,
      missionTitle: missionTitle,
      endDate: endDate,
      amount: amount,
    );
  }
}

// Définition des couleurs personnalisées
const Color customOrange = Color(0xFFF59E0B); // Bouton Soumettre/Étoiles
const Color customBlue = Color(0xFF2563EB); // Couleur principale/Bouton Bleu
const Color accentColor = Color(0xFF4DD0E1); // Pour le dégradé de l'AppBar

class RecruiterEvaluationScreen extends StatelessWidget {
  final int? candidatureId;
  final String? missionTitle;
  final String? endDate;
  final String? amount;

  const RecruiterEvaluationScreen({super.key, this.candidatureId, this.missionTitle, this.endDate, this.amount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6fcfc), // Couleur de fond du CustomHeader
      appBar: CustomHeader(
        title: 'Évaluer le Recruteur',
        onBack: () => Navigator.of(context).pop(),
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        child: EvaluationContent(
          candidatureId: candidatureId,
          missionTitle: missionTitle,
          endDate: endDate,
          amount: amount,
        ),
      ),
    );
  }
}

// Widget contenant le contenu du formulaire d'évaluation
class EvaluationContent extends StatefulWidget {
  final int? candidatureId;
  final String? missionTitle;
  final String? endDate;
  final String? amount;

  const EvaluationContent({super.key, this.candidatureId, this.missionTitle, this.endDate, this.amount});

  @override
  State<EvaluationContent> createState() => _EvaluationContentState();
}

class _EvaluationContentState extends State<EvaluationContent> {
  int _rating = 0; // Notation actuelle
  final TextEditingController _commentController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating <= 0) return;
    if (widget.candidatureId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Identifiant de candidature manquant')));
      return;
    }
    setState(() {
      _submitting = true;
    });
    try {
      await NotationService.noterRecruteur(
        candidatureId: widget.candidatureId!,
        note: _rating,
        commentaire: _commentController.text.trim().isEmpty ? null : _commentController.text.trim(),
      );
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Text('Avis envoyé avec succès'),
            content: const Text('Merci pour votre retour !'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Erreur'),
          content: Text(e.toString()),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Fermer')),
          ],
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // --- Message de Bienvenue ---
        const Text(
          'Merci d\'avoir terminé votre mission ! Partagez votre expérience avec le recruteur.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 25),

        // --- Bloc Récapitulatif de Mission ---
        MissionSummaryCard(
          missionName: (widget.missionTitle ?? 'Mission'),
          endDate: (widget.endDate ?? '—'),
          amount: (widget.amount ?? '+ 0 CFA'),
        ),
        const SizedBox(height: 30),

        // --- Section Notation ---
        const Text(
          'Notez votre recruteur',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 15),

        // 5 Étoiles pour la notation
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                index < _rating ? Icons.star : Icons.star_border,
                color: customOrange,
                size: 40.0,
              ),
              onPressed: () {
                setState(() {
                  _rating = index + 1;
                });
              },
            );
          }),
        ),
        const SizedBox(height: 20),

        // Champ de Texte pour l'avis (facultatif)
        const Text(
          'Votre avis (facultatif)',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _commentController,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Partaeger votre expérience ....',
            hintStyle: const TextStyle(color: Colors.grey),
            contentPadding: const EdgeInsets.all(15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: customBlue, width: 2.0),
            ),
          ),
        ),
        const SizedBox(height: 40),

        // --- Boutons d'Action ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Bouton "Envoyer l'avis" (Bleu)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _rating > 0 && !_submitting ? _submit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: customBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 3,
                    ),
                    child: _submitting
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text(
                            'Envoyer l\'avis',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ),

            // Bouton "Quitter" (Rouge/Rose)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      // Logique de Quitter / Annuler
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6961), // Un rouge/rose clair pour le bouton "Quitter"
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 3,
                    ),
                    child: const Text(
                      'Quitter',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Widget pour afficher les détails de la mission
class MissionSummaryCard extends StatelessWidget {
  final String missionName;
  final String endDate;
  final String amount;

  const MissionSummaryCard({
    super.key,
    required this.missionName,
    required this.endDate,
    required this.amount,
  });

  Widget _buildDetailRow(String label, String value, {bool isAmount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isAmount ? Colors.green.shade600 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildDetailRow('Mission', missionName),
          _buildDetailRow('Date de fin', endDate),
          _buildDetailRow('Montant gagné', amount, isAmount: true),
        ],
      ),
    );
  }
}

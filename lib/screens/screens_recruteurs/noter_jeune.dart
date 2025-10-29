import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/custom_header.dart';
import 'home_recruteur.dart';

class NoterJeune extends StatelessWidget {
  final String jeuneName;
  final String mission;
  final String montant;
  final String dateFin;

  const NoterJeune({
    super.key,
    required this.jeuneName,
    required this.mission,
    required this.montant,
    required this.dateFin,
  });

  @override
  Widget build(BuildContext context) {
    return const JeuneEvaluationScreen();
  }
}

// Définition des couleurs personnalisées
const Color customOrange = Color(0xFFF59E0B); // Bouton Soumettre/Étoiles
const Color customBlue = Color(0xFF2563EB); // Couleur principale/Bouton Bleu
const Color bodyBackgroundColor = Color(0xFFf6fcfc);

class JeuneEvaluationScreen extends StatefulWidget {
  final String jeuneName;
  final String mission;
  final String montant;
  final String dateFin;

  const JeuneEvaluationScreen({
    super.key,
    this.jeuneName = 'Ramatou konaré',
    this.mission = 'Aide Ménagere',
    this.montant = '5 000 CFA',
    this.dateFin = '06 Octobre 2025',
  });

  @override
  State<JeuneEvaluationScreen> createState() => _JeuneEvaluationScreenState();
}

class _JeuneEvaluationScreenState extends State<JeuneEvaluationScreen> {
  int _rating = 0; // Notation actuelle
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    // Afficher le pop-up de confirmation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Success Icon
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Success message
                  Text(
                    'Avis envoyé avec succès',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  Text(
                    'Merci pour votre retour !',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // OK button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                        Navigator.of(context).pop(); // Close evaluation screen
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const HomeRecruteurScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: customBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
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
          ),
        );
      },
    );
  }

  void _handleQuit() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeRecruteurScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: CustomHeader(
        title: 'Évaluer le Jeune',
        onBack: () => Navigator.of(context).pop(),
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- Message de Bienvenue ---
            Text(
              'Partagez votre expérience avec le jeune.',
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 25),

            // --- Bloc Récapitulatif de Mission ---
            MissionSummaryCard(
              missionName: widget.mission,
              endDate: widget.dateFin,
              amount: widget.montant,
            ),
            const SizedBox(height: 30),

            // --- Section Notation ---
            Text(
              'Notez votre Jeune',
              style: GoogleFonts.poppins(
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
            Text(
              'Votre avis (facultatif)',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Partaeger votre expérience ....',
                hintStyle: GoogleFonts.poppins(color: Colors.grey),
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
              style: GoogleFonts.poppins(),
            ),
            const SizedBox(height: 40),

            // --- Boutons d'Action ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Bouton "Envoyer l'avis" (Bleu ou gris si _rating == 0)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _rating > 0 ? _handleSubmit : null, // Désactiver si aucune note
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _rating > 0 ? customBlue : Colors.grey.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: _rating > 0 ? 3 : 0,
                        ),
                        child: Text(
                          'Envoyer l\'avis',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Bouton "Quitter" (Rouge)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _handleQuit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6961), // Rouge clair pour le bouton "Quitter"
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 3,
                        ),
                        child: Text(
                          'Quitter',
                          style: GoogleFonts.poppins(
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
        ),
      ),
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.bold,
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildDetailRow('Nom de la mission', missionName),
          _buildDetailRow('Date de fin', endDate),
          _buildDetailRow('Montant payé', amount, isAmount: true),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/custom_header.dart';
import 'paiement.dart';

const Color bodyBackgroundColor = Color(0xFFf6fcfc);
const Color primaryGreen = Color(0xFF10B981);

class ModePaiementScreen extends StatefulWidget {
  final String jeune;
  final String mission;
  final String montant;
  final String nomMission;

  const ModePaiementScreen({
    super.key,
    this.jeune = 'Ramatou konaré',
    this.mission = 'Aide Ménagere',
    this.montant = '5 000 CFA',
    this.nomMission = 'Mission de terrain',
  });

  @override
  State<ModePaiementScreen> createState() => _ModePaiementScreenState();
}

class _ModePaiementScreenState extends State<ModePaiementScreen> {
  void _handleOrangeMoneyPayment() {
    // Navigate to Orange Money payment confirmation
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaiementScreen(
          jeune: widget.jeune,
          mission: widget.mission,
        ),
      ),
    );
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
                                        Navigator.of(context).pop(); // Go back to previous screen
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
            
            // Mission summary text
            Text(
              'Choisissez votre mode de paiement pour la mission "${widget.nomMission}".',
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            
            // Amount
            Text(
              'Montant: ${widget.montant}.',
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
                  widget.jeune,
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
                  widget.mission,
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
        ),
      ),
    );
  }
}

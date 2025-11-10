import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/custom_header.dart';
import '../../services/payment_service.dart';
import 'home_recruteur.dart';
import 'noter_jeune.dart';

const Color bodyBackgroundColor = Color(0xFFf6fcfc);
const Color primaryBlue = Color(0xFF2563EB);
const Color primaryGreen = Color(0xFF10B981);
const Color primaryPurple = Color(0xFF8B5CF6);

class PaiementScreen extends StatefulWidget {
  final String jeune;
  final String mission;
  final String montant;
  final String? phone;
  final int? candidatureId;

  const PaiementScreen({
    super.key,
    required this.jeune,
    required this.mission,
    required this.montant,
    this.phone,
    this.candidatureId,
  });

  @override
  State<PaiementScreen> createState() => _PaiementScreenState();
}

class _PaiementScreenState extends State<PaiementScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    // Prefill amount from provided montant if parseable
    final digits = RegExp(r'\d+[\d\s]*').stringMatch(widget.montant) ?? '';
    final normalized = digits.replaceAll(RegExp(r'\s+'), '');
    if (normalized.isNotEmpty) {
      _amountController.text = normalized;
    }
    // Prefill phone if provided
    if (widget.phone != null && widget.phone!.trim().isNotEmpty) {
      _phoneController.text = widget.phone!.trim();
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _handlePayment() {
    // Validation des champs
    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez entrer le numéro de téléphone', 
            style: GoogleFonts.poppins()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_amountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez entrer le montant', 
            style: GoogleFonts.poppins()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (widget.candidatureId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Aucune candidature liée au paiement', style: GoogleFonts.poppins()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    double? montant;
    try {
      montant = double.tryParse(_amountController.text.replaceAll(' ', ''));
    } catch (_) {}
    if (montant == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Montant invalide', style: GoogleFonts.poppins()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() { _submitting = true; });
    PaymentService.postPaiement(
      candidatureId: widget.candidatureId!,
      telephone: _phoneController.text.trim(),
      montant: montant,
    ).then((ok) {
      if (!mounted) return;
      setState(() { _submitting = false; });
      // Afficher une confirmation
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
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  // Success Icon in circle
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: primaryGreen.withOpacity(0.37), // 37% opacity
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: primaryGreen, // #10B981
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Confirmation message
                  Text(
                    'Paiement confirmé avec succès :',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  // Mission status
                  Text(
                    'La mission "${widget.mission}" est maintenant payée.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Payment details card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Amount
                        Text(
                          'Montant',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.montant,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Horizontal line separator
                        Divider(
                          color: Colors.grey.shade300,
                          thickness: 1,
                        ),
                        const SizedBox(height: 20),
                        
                        // Payment method
                        Text(
                          'Méthode de paiement',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Orange Money',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Buttons row
                  Row(
                    children: [
                      // Noter le jeune button
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close dialog
                              Navigator.of(context).pop(true); // Close paiement screen and notify success
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => JeuneEvaluationScreen(
                                    jeuneName: widget.jeune,
                                    mission: widget.mission,
                                    montant: widget.montant,
                                    dateFin: '06 Octobre 2025',
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF59E0B), // Orange
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Noter le jeune',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Return to home button
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close dialog
                              Navigator.of(context).pop(true); // Close paiement screen and notify success
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => const HomeRecruteurScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryGreen, // #10B981
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Retour à l\'accueil',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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
          ),
        );
      });
    }).catchError((e) {
      if (!mounted) return;
      setState(() { _submitting = false; });
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF3E3E).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.error_outline, color: const Color(0xFFFF3E3E).withOpacity(0.83), size: 40),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Erreur de paiement',
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    e.toString().replaceFirst(RegExp(r'^Exception:\s*'), ''),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF3E3E).withOpacity(0.83),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Fermer', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: CustomHeader(
        title: 'Paiement Mobile',
        onBack: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          screenWidth * 0.05,
          0,
          screenWidth * 0.05,
          MediaQuery.of(context).padding.bottom + 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Titre
            Text(
              'Confirmer votre paiement',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Logo Orange Money
            Center(
              child: Image.asset(
                'assets/images/orange_money.png',
                width: 150,
                height: 80,
              ),
            ),
            const SizedBox(height: 30),

            // Champ numéro de téléphone
            _buildTextField(
              controller: _phoneController,
              hintText: 'Numero de téléphone Orange Money',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 15),

            // Champ montant
            _buildTextField(
              controller: _amountController,
              hintText: 'Montant à payer en FCFA',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),

            // Détails du paiement
            Text(
              'Détails du paiement:',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            _buildDetailRow('Jeune:', widget.jeune),
            const SizedBox(height: 8),
            _buildDetailRow('Missions:', widget.mission),
            const SizedBox(height: 30),

            // Bouton Payer
            Center(
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryPurple, primaryBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: primaryPurple.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _submitting ? null : _handlePayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2563EB),
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _submitting
                      ? SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(
                          'Payer',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            color: Colors.grey.shade500,
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}

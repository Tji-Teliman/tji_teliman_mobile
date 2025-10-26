import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/custom_header.dart';

const Color primaryGreen = Color(0xFF10B981);
const Color bodyBackgroundColor = Color(0xFFf6fcfc);
const Color inactiveGray = Color(0xFFE0E0E0);

class FinaliserProfilEntreprise extends StatefulWidget {
  const FinaliserProfilEntreprise({super.key});

  @override
  State<FinaliserProfilEntreprise> createState() => _FinaliserProfilEntrepriseState();
}

class _FinaliserProfilEntrepriseState extends State<FinaliserProfilEntreprise> {

  final TextEditingController _adresseController = TextEditingController();
  final TextEditingController _nomEntrepriseController = TextEditingController();
  final TextEditingController _secteurController = TextEditingController();
  final TextEditingController _emailEntrepriseController = TextEditingController();
  final TextEditingController _siteWebController = TextEditingController();

  @override
  void dispose() {
    _adresseController.dispose();
    _nomEntrepriseController.dispose();
    _secteurController.dispose();
    _emailEntrepriseController.dispose();
    _siteWebController.dispose();
    super.dispose();
  }

  // Section logo supprimée pour le profil entreprise

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: CustomHeader(
        title: 'Finaliser Mon Profil',
        onBack: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            _buildProgressBar(progress: 0.5),
            const SizedBox(height: 10),
            Text(
              'Plus que quelques étapes pour débloquer toutes les missions !',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 30),

            // Section logo supprimée

            _buildTextField(controller: _nomEntrepriseController, hint: "Nom de l'entreprise", icon: Icons.apartment),
            const SizedBox(height: 20),
            _buildTextField(controller: _adresseController, hint: "Adresse de l'entreprise", icon: Icons.location_on_outlined),
            const SizedBox(height: 20),
            _buildTextField(controller: _secteurController, hint: "Secteur d'activité", icon: Icons.category_outlined),
            const SizedBox(height: 20),
            _buildTextField(controller: _emailEntrepriseController, hint: "Email de l'entreprise", icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 20),
            _buildTextField(controller: _siteWebController, hint: 'Site web', icon: Icons.language_outlined, keyboardType: TextInputType.url),

            const SizedBox(height: 40),
            _buildSaveButton(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar({required double progress}) {
    final percentage = '${(progress * 100).toInt()}% Complété';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          percentage,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 5),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: inactiveGray,
          valueColor: const AlwaysStoppedAnimation<Color>(primaryGreen),
          minHeight: 25,
          borderRadius: BorderRadius.circular(20),
        ),
      ],
    );
  }

  // _buildLogoSection supprimé

  Widget _buildTextField({required TextEditingController controller, required String hint, required IconData icon, TextInputType? keyboardType}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 3)),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: Colors.black54),
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
          suffixIcon: Icon(icon, color: Colors.black54),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 5,
        ),
        child: Text(
          'ENREGISTRER ET TERMINER',
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
      ),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../../widgets/custom_header.dart';
import '../../services/profile_service.dart';

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
  final ImagePicker _picker = ImagePicker();
  XFile? _justifDoc;

  bool _isFormComplete() {
    final hasNom = _nomEntrepriseController.text.isNotEmpty;
    final hasAdresse = _adresseController.text.isNotEmpty;
    final hasSecteur = _secteurController.text.isNotEmpty;
    final hasEmail = _emailEntrepriseController.text.isNotEmpty;
    final hasSite = _siteWebController.text.isNotEmpty;
    return hasNom && hasAdresse && hasSecteur && hasEmail && hasSite;
  }

  Widget _buildJustificatifUploadSection() {
    return GestureDetector(
      onTap: _showImageSourceDialog,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 120,
          maxHeight: 150,
        ),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.black.withOpacity(0.2),
            style: BorderStyle.solid,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 3)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_justifDoc == null)
              const Icon(Icons.cloud_upload_outlined, color: Colors.black, size: 40)
            else
              SizedBox(
                height: 80,
                child: kIsWeb
                    ? Image.network(_justifDoc!.path, fit: BoxFit.cover)
                    : Image.file(File(_justifDoc!.path), fit: BoxFit.cover),
              ),
            const SizedBox(height: 10),
            Text(
              "Téléverser un justificatif d'entreprise",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _computeProgress() {
    int completed = 0;
    if (_nomEntrepriseController.text.isNotEmpty) completed++;
    if (_adresseController.text.isNotEmpty) completed++;
    if (_secteurController.text.isNotEmpty) completed++;
    if (_emailEntrepriseController.text.isNotEmpty) completed++;
    if (_siteWebController.text.isNotEmpty) completed++;
    return 0.5 + (completed * 0.1); // 5 critères => +10% chacun
  }

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

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _justifDoc = image;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la sélection: $e')),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Caméra'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galerie'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
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
        title: 'Finaliser Mon Profil',
        onBack: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            _buildProgressBar(progress: _computeProgress()),
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

            const SizedBox(height: 20),
            _buildJustificatifUploadSection(),

            const SizedBox(height: 20),
            _buildSaveButton(context),
            const SizedBox(height: 20),
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
        onChanged: (_) => setState(() {}),
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
        onPressed: _isFormComplete() ? () async {
          try {
            final fields = <String, String>{};
            if (_nomEntrepriseController.text.isNotEmpty) fields['nomEntreprise'] = _nomEntrepriseController.text;
            if (_adresseController.text.isNotEmpty) fields['adresse'] = _adresseController.text;
            if (_secteurController.text.isNotEmpty) fields['secteurActivite'] = _secteurController.text;
            if (_emailEntrepriseController.text.isNotEmpty) fields['emailEntreprise'] = _emailEntrepriseController.text;
            if (_siteWebController.text.isNotEmpty) fields['siteWeb'] = _siteWebController.text;

            Map<String, dynamic> result;
            if (_justifDoc != null) {
              if (kIsWeb) {
                final bytes = await _justifDoc!.readAsBytes();
                result = await ProfileService.updateMonProfil(
                  fields: fields,
                  carteIdentiteBytes: bytes,
                  carteIdentiteFilename: _justifDoc!.name,
                );
              } else {
                result = await ProfileService.updateMonProfil(
                  fields: fields,
                  carteIdentite: File(_justifDoc!.path),
                );
              }
            } else {
              result = await ProfileService.updateMonProfil(fields: fields);
            }

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(result['message']?.toString() ?? 'Profil entreprise mis à jour')),
              );
              Navigator.of(context).pop(true);
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erreur de sauvegarde: $e')),
              );
            }
          }
        } : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isFormComplete() ? primaryGreen : Colors.grey,
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



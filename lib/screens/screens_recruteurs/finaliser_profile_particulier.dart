import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/custom_header.dart';

const Color primaryGreen = Color(0xFF10B981);
const Color primaryBlue = Color(0xFF2563EB);
const Color bodyBackgroundColor = Color(0xFFf6fcfc);
const Color inactiveGray = Color(0xFFE0E0E0);

class FinaliserProfileParticulier extends StatefulWidget {
  const FinaliserProfileParticulier({super.key});

  @override
  State<FinaliserProfileParticulier> createState() => _FinaliserProfileParticulierState();
}

class _FinaliserProfileParticulierState extends State<FinaliserProfileParticulier> {
  final ImagePicker _picker = ImagePicker();

  String? _selectedDateOfBirth;
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();
    _professionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image sélectionnée: ${image.name}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sélection: $e')),
      );
    }
  }

  void _showImageSourceDialog(String type) {
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

  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(const Duration(days: 6570)),
    );
    if (picked != null) {
      setState(() {
        _selectedDateOfBirth = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
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
            _buildProgressBar(context, progress: 0.5),
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

            _buildProfilePhotoSection(context),
            const SizedBox(height: 30),

            _buildDateField(),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _locationController,
              hint: 'Localisation',
              icon: Icons.location_on_outlined,
              readOnly: false,
            ),
            const SizedBox(height: 20),
            _buildMultilineField(
              controller: _professionController,
              hint: 'Profession',
              icon: Icons.work_outline,
            ),
            const SizedBox(height: 30),

            _buildIDUploadSection(),
            const SizedBox(height: 20),

            _buildSaveButton(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, {required double progress}) {
    String percentage = '${(progress * 100).toInt()}% Complété';
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

  Widget _buildProfilePhotoSection(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: primaryGreen.withOpacity(0.2),
            border: Border.all(color: primaryGreen, width: 2),
          ),
          child: Icon(
            Icons.person,
            size: 60,
            color: primaryGreen,
          ),
        ),
        const SizedBox(height: 20),
        OutlinedButton(
          onPressed: () {
            _showImageSourceDialog('photo de profil');
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            side: const BorderSide(color: primaryGreen, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            'Ajouter / Modifier la photo',
            style: GoogleFonts.poppins(
              color: primaryGreen,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: _selectDateOfBirth,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _selectedDateOfBirth ?? 'Date de naissance',
                  style: GoogleFonts.poppins(
                    color: _selectedDateOfBirth != null ? Colors.black : Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ),
              const Icon(Icons.calendar_today_outlined, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hint, required IconData icon, bool readOnly = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: Colors.black54),
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
          suffixIcon: Icon(icon, color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildMultilineField({required TextEditingController controller, required String hint, required IconData icon}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        minLines: 2,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: Colors.black54),
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
          suffixIcon: Icon(icon, color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildIDUploadSection() {
    return GestureDetector(
      onTap: () {
        _showImageSourceDialog('carte d\'identité');
      },
      child: _DottedBorderContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_upload_outlined, color: Colors.black, size: 40),
            const SizedBox(height: 10),
            Text(
              'Televerser la photo de votre carte d\'identité',
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

  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
        ),
        child: Text(
          'ENREGISTRER ET TERMINER',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

class _DottedBorderContainer extends StatelessWidget {
  final Widget child;
  const _DottedBorderContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      ),
      child: Center(child: child),
    );
  }
}



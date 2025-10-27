import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// Réutilise l'image de header et le style général des autres écrans
const Color bodyBackgroundColor = Color(0xFFf6fcfc);
const Color primaryBlue = Color(0xFF2563EB);
const Color primaryGreen = Color(0xFF10B981);
const Color orangeBrand = Color(0xFFE67E22);

class ModifierProfilRecruteurScreen extends StatefulWidget {
  final String initialEmail;
  final String initialPhone;
  final String initialLocation;
  final String initialProfession;
  final String initialDateNaissance;
  final String fullName;
  final String role;

  const ModifierProfilRecruteurScreen({
    super.key,
    required this.initialEmail,
    required this.initialPhone,
    required this.initialLocation,
    required this.initialProfession,
    required this.initialDateNaissance,
    required this.fullName,
    required this.role,
  });

  @override
  State<ModifierProfilRecruteurScreen> createState() => _ModifierProfilRecruteurScreenState();
}

class _ModifierProfilRecruteurScreenState extends State<ModifierProfilRecruteurScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController locationController;
  late final TextEditingController professionController;
  late final TextEditingController dateNaissanceController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.initialEmail);
    phoneController = TextEditingController(text: widget.initialPhone);
    locationController = TextEditingController(text: widget.initialLocation);
    professionController = TextEditingController(text: widget.initialProfession);
    dateNaissanceController = TextEditingController(text: widget.initialDateNaissance);
  }

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    professionController.dispose();
    dateNaissanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double headerHeight = screenHeight * 0.33;

    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      body: Stack(
        children: [
          // Header avec image, flèche retour, avatar et titres
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildHeader(context, headerHeight),
          ),

          // Corps arrondi chevauchant le header
          Positioned(
            top: headerHeight - 40,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: screenWidth,
              decoration: const BoxDecoration(
                color: bodyBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  screenWidth * 0.05,
                  22,
                  screenWidth * 0.05,
                  MediaQuery.of(context).padding.bottom + 30,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informations personnelles',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _labeledField('Email', emailController, Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 10),
                      _labeledField('Téléphone', phoneController, Icons.call_outlined,
                          keyboardType: TextInputType.phone),
                      const SizedBox(height: 10),
                      _labeledField('Localisation', locationController, Icons.location_on_outlined),
                      const SizedBox(height: 10),
                      _labeledField('Profession', professionController, Icons.work_outline),
                      const SizedBox(height: 10),
                      _dateField(),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: _onSave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            elevation: 0,
                          ),
                          child: Text(
                            'Enregistrer',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).padding.bottom),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double height) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/header_home.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 16,
            left: 12,
            right: 12,
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => Navigator.of(context).pop(),
                    child: const Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Modifier Profil',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),
          ),

          // Avatar + nom + rôle
          Positioned(
            top: height * 0.28,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _profileImage == null
                          ? const AssetImage('assets/images/profil_recruteur.png') as ImageProvider
                          : FileImage(File(_profileImage!.path)),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: _showImageSourceDialog,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: orangeBrand,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.fullName,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  widget.role,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _labeledField(
    String label,
    TextEditingController controller,
    IconData icon, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Container(
              width: 44,
              alignment: Alignment.center,
              child: Icon(icon, color: orangeBrand),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: primaryBlue, width: 1.5),
            ),
          ),
          style: GoogleFonts.poppins(fontSize: 13.5, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _dateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date de naissance',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate ?? DateTime.now(),
              firstDate: DateTime(1950),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              setState(() {
                _selectedDate = picked;
                dateNaissanceController.text =
                    '${picked.day}/${picked.month}/${picked.year}';
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined, color: orangeBrand, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    dateNaissanceController.text.isEmpty
                        ? 'Sélectionnez une date'
                        : dateNaissanceController.text,
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      color: dateNaissanceController.text.isEmpty
                          ? Colors.grey.shade500
                          : Colors.black87,
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onSave() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profil mis à jour', style: GoogleFonts.poppins()),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.of(context).pop();
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Caméra'),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  final picked = await _picker.pickImage(source: ImageSource.camera);
                  if (picked != null) {
                    setState(() => _profileImage = picked);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galerie'),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  final picked = await _picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    setState(() => _profileImage = picked);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}


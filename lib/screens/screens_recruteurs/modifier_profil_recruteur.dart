import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import '../../services/profile_service.dart';
import '../../config/api_config.dart';

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
  final String initialPhotoUrl;
  // Champs spécifiques ENTREPRISE
  final String? initialEmailEntreprise;
  final String? initialSecteurActivite;
  final String? initialSiteWeb;
  final String? initialPrenom;
  final String? initialNom;
  final String? initialNomEntreprise;

  const ModifierProfilRecruteurScreen({
    super.key,
    required this.initialEmail,
    required this.initialPhone,
    required this.initialLocation,
    required this.initialProfession,
    required this.initialDateNaissance,
    required this.fullName,
    required this.role,
    required this.initialPhotoUrl,
    this.initialEmailEntreprise,
    this.initialSecteurActivite,
    this.initialSiteWeb,
    this.initialPrenom,
    this.initialNom,
    this.initialNomEntreprise,
  });

  @override
  State<ModifierProfilRecruteurScreen> createState() => _ModifierProfilRecruteurScreenState();
}

class _ModifierProfilRecruteurScreenState extends State<ModifierProfilRecruteurScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;
  Uint8List? _previewBytes;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController locationController;
  late final TextEditingController professionController;
  late final TextEditingController dateNaissanceController;
  // Entreprise controllers
  late final TextEditingController emailEntrepriseController;
  late final TextEditingController secteurController;
  late final TextEditingController siteWebController;
  late final TextEditingController prenomController;
  late final TextEditingController nomController;
  late final TextEditingController nomEntrepriseController;
  DateTime? _selectedDate;
  bool _isSaving = false;
  bool _isDirty = false;
  late String _initialPhotoUrl;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.initialEmail);
    phoneController = TextEditingController(text: widget.initialPhone);
    locationController = TextEditingController(text: widget.initialLocation);
    professionController = TextEditingController(text: widget.initialProfession);
    dateNaissanceController = TextEditingController(text: widget.initialDateNaissance);
    _initialPhotoUrl = widget.initialPhotoUrl;
    emailEntrepriseController = TextEditingController(text: widget.initialEmailEntreprise ?? '');
    secteurController = TextEditingController(text: widget.initialSecteurActivite ?? '');
    siteWebController = TextEditingController(text: widget.initialSiteWeb ?? '');
    prenomController = TextEditingController(text: widget.initialPrenom ?? '');
    nomController = TextEditingController(text: widget.initialNom ?? '');
    nomEntrepriseController = TextEditingController(text: widget.initialNomEntreprise ?? '');

    void markDirty() {
      if (!_isDirty) setState(() => _isDirty = true);
    }
    emailController.addListener(markDirty);
    phoneController.addListener(markDirty);
    locationController.addListener(markDirty);
    professionController.addListener(markDirty);
    dateNaissanceController.addListener(markDirty);
    emailEntrepriseController.addListener(markDirty);
    secteurController.addListener(markDirty);
    siteWebController.addListener(markDirty);
    prenomController.addListener(markDirty);
    nomController.addListener(markDirty);
    nomEntrepriseController.addListener(markDirty);
  }

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    professionController.dispose();
    dateNaissanceController.dispose();
    emailEntrepriseController.dispose();
    secteurController.dispose();
    siteWebController.dispose();
    prenomController.dispose();
    nomController.dispose();
    nomEntrepriseController.dispose();
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
                      if (widget.role.toUpperCase() == 'ENTREPRISE') ...[
                        _labeledField('Nom Entreprise', nomEntrepriseController, Icons.apartment),
                        const SizedBox(height: 10),
                        _labeledField('Email Entreprise', emailEntrepriseController, Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress),
                        const SizedBox(height: 10),
                        _labeledField('Téléphone', phoneController, Icons.call_outlined,
                            keyboardType: TextInputType.phone),
                        const SizedBox(height: 10),
                        _labeledField('Adresse', locationController, Icons.location_on_outlined),
                        const SizedBox(height: 10),
                        _labeledField("Secteur d'activité", secteurController, Icons.apartment_outlined),
                        const SizedBox(height: 10),
                        _labeledField('Site Web', siteWebController, Icons.public_outlined,
                            keyboardType: TextInputType.url),
                      ] else ...[
                        Row(
                          children: [
                            Expanded(child: _labeledField('Prénom', prenomController, Icons.badge)),
                            const SizedBox(width: 10),
                            Expanded(child: _labeledField('Nom', nomController, Icons.badge_outlined)),
                          ],
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
                      ],
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: (_isDirty && !_isSaving) ? _onSave : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: (_isDirty && !_isSaving) ? primaryGreen : Colors.grey,
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
                    if (widget.role.toUpperCase() == 'ENTREPRISE' && _previewBytes == null && _profileImage == null && (widget.initialPhotoUrl.isEmpty))
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white.withOpacity(0.25),
                        child: const Icon(Icons.person, size: 50, color: Colors.white),
                      )
                    else
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _previewBytes != null
                            ? MemoryImage(_previewBytes!)
                            : (_profileImage != null && !kIsWeb
                                ? FileImage(File(_profileImage!.path)) as ImageProvider
                                : (widget.initialPhotoUrl.isNotEmpty
                                    ? NetworkImage(widget.initialPhotoUrl)
                                    : const AssetImage('assets/images/profil_recruteur.png') as ImageProvider)),
                      ),
                    if (widget.role.toUpperCase() != 'ENTREPRISE')
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
                _isDirty = true;
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

  Future<void> _onSave() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      // Conversion date dd/MM/yyyy -> yyyy-MM-dd
      String dobFormatted = '';
      final rawDob = dateNaissanceController.text.trim();
      if (rawDob.isNotEmpty) {
        final parts = rawDob.split('/');
        if (parts.length == 3) {
          final d = parts[0].padLeft(2, '0');
          final m = parts[1].padLeft(2, '0');
          final y = parts[2];
          dobFormatted = '$y-$m-$d';
        } else {
          dobFormatted = rawDob;
        }
      }

      Map<String, String> fields;
      if (widget.role.toUpperCase() == 'ENTREPRISE') {
        fields = {
          if (nomEntrepriseController.text.trim().isNotEmpty) 'nomEntreprise': nomEntrepriseController.text.trim(),
          'telephone': phoneController.text.trim(),
          'adresse': locationController.text.trim(),
          'emailEntreprise': emailEntrepriseController.text.trim(),
          if (secteurController.text.trim().isNotEmpty) 'secteurActivite': secteurController.text.trim(),
          if (siteWebController.text.trim().isNotEmpty) 'siteWeb': siteWebController.text.trim(),
        };
      } else {
        fields = {
          if (prenomController.text.trim().isNotEmpty) 'prenom': prenomController.text.trim(),
          if (nomController.text.trim().isNotEmpty) 'nom': nomController.text.trim(),
          'email': emailController.text.trim(),
          'telephone': phoneController.text.trim(),
          'adresse': locationController.text.trim(),
          if (professionController.text.trim().isNotEmpty) 'profession': professionController.text.trim(),
          if (dobFormatted.isNotEmpty) 'dateNaissance': dobFormatted,
        };
      }

      // Photo upload
      Uint8List? photoBytes;
      String? photoFilename;
      File? photoFile;
      if (_profileImage != null) {
        photoFilename = _profileImage!.name;
        if (kIsWeb) {
          photoBytes = _previewBytes ?? await _profileImage!.readAsBytes();
        } else {
          photoFile = File(_profileImage!.path);
        }
      }

      await ProfileService.updateMonProfil(
        fields: fields,
        photoProfil: photoFile,
        photoBytes: photoBytes,
        photoFilename: photoFilename,
      );

      // Fetch updated profile and return
      Map<String, dynamic> updated = {};
      try {
        final resp = await ProfileService.getMonProfil();
        final data = resp['data'] as Map<String, dynamic>?;
        if (data != null) {
          String newEmail = (data['email'] ?? data['userEmail'])?.toString() ?? emailController.text.trim();
          String newPhone = (data['telephone'] ?? data['userPhone'])?.toString() ?? phoneController.text.trim();
          String newAdresse = data['adresse']?.toString() ?? locationController.text.trim();
          String newProfession = data['profession']?.toString() ?? professionController.text.trim();
          String newDob = data['dateNaissance']?.toString() ?? dobFormatted;
          if (newDob.contains('-')) {
            final parts = newDob.split('-');
            if (parts.length == 3) {
              newDob = '${parts[2].padLeft(2, '0')}/${parts[1].padLeft(2, '0')}/${parts[0]}';
            }
          }

          // Entreprise fields
          final type = (data['typeRecruteur'] ?? '').toString().toUpperCase().trim();
          final nomEnt = data['nomEntreprise']?.toString() ?? (nomEntrepriseController.text.trim());
          final emailEnt = data['emailEntreprise']?.toString() ?? (emailEntrepriseController.text.trim());
          final secteur = data['secteurActivite']?.toString() ?? (secteurController.text.trim());
          final site = data['siteWeb']?.toString() ?? (siteWebController.text.trim());

          // Photo
          final rawPhoto = data['photo'] ?? data['urlPhoto'];
          String tempPhoto = '';
          if (rawPhoto is Map) {
            tempPhoto = (rawPhoto['url'] ?? rawPhoto['path'] ?? rawPhoto['value'] ?? '').toString();
          } else if (rawPhoto != null) {
            tempPhoto = rawPhoto.toString();
          }
          final newPhoto = _convertPhotoPathToUrl(tempPhoto) ?? tempPhoto;

          updated = {
            'email': newEmail,
            'telephone': newPhone,
            'adresse': newAdresse,
            'profession': newProfession,
            'dateNaissance': newDob,
            'photoUrl': newPhoto,
            'typeRecruteur': type,
            'nomEntreprise': nomEnt,
            'emailEntreprise': emailEnt,
            'secteurActivite': secteur,
            'siteWeb': site,
            // For Particulier, renvoyer aussi prenom/nom si disponibles
            'prenom': (data['prenom']?.toString() ?? prenomController.text.trim()),
            'nom': (data['nom']?.toString() ?? nomController.text.trim()),
          };
        }
      } catch (_) {}

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profil mis à jour', style: GoogleFonts.poppins()),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).pop(updated.isNotEmpty ? updated : true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la mise à jour: $e', style: GoogleFonts.poppins()),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
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
                    Uint8List? bytes;
                    try { bytes = await picked.readAsBytes(); } catch (_) {}
                    setState(() {
                      _profileImage = picked;
                      _previewBytes = bytes;
                      _isDirty = true;
                    });
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
                    Uint8List? bytes;
                    try { bytes = await picked.readAsBytes(); } catch (_) {}
                    setState(() {
                      _profileImage = picked;
                      _previewBytes = bytes;
                      _isDirty = true;
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Convertit un chemin local (ex: C:\\...\\uploads\\...) en URL HTTP complète
  String? _convertPhotoPathToUrl(String? photoPath) {
    if (photoPath == null || photoPath.isEmpty) return null;
    if (photoPath.startsWith('http://') || photoPath.startsWith('https://')) {
      return photoPath;
    }
    if (photoPath.contains('uploads')) {
      String base = ApiConfig.baseUrl;
      if (base.endsWith('/')) base = base.substring(0, base.length - 1);
      final uploadsIndex = photoPath.indexOf('uploads');
      if (uploadsIndex != -1) {
        String relativePath = photoPath.substring(uploadsIndex + 'uploads'.length);
        relativePath = relativePath.replaceAll('\\', '/');
        if (!relativePath.startsWith('/')) {
          relativePath = '/$relativePath';
        }
        final url = '$base/uploads$relativePath';
        return url;
      }
    }
    if (photoPath.startsWith('uploads')) {
      String base = ApiConfig.baseUrl;
      if (base.endsWith('/')) base = base.substring(0, base.length - 1);
      String url = '$base/$photoPath';
      url = url.replaceAll('\\', '/');
      return url;
    }
    return null;
  }
}


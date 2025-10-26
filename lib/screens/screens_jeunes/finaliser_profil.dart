import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
// Importation du widget CustomHeader (Assurez-vous que le chemin est correct dans votre projet)
import '../../widgets/custom_header.dart'; // Supposons que c'est le chemin valide.

// --- COULEURS ET CONSTANTES GLOBALES (À ADAPTER À VOTRE FICHIER CONSTANTES SI EXISTANT) ---
const Color primaryGreen = Color(0xFF10B981); // Vert principal
const Color primaryBlue = Color(0xFF2563EB); // Bleu
const Color bodyBackgroundColor = Color(0xFFf6fcfc); // Couleur de fond du Scaffold
const Color orangeBrand = Color(0xFFE67E22);
const Color inactiveGray = Color(0xFFE0E0E0); // Gris pour la barre de progression inactive

class FinaliserProfilScreen extends StatefulWidget {
  const FinaliserProfilScreen({super.key});

  @override
  State<FinaliserProfilScreen> createState() => _FinaliserProfilScreenState();
}

class _FinaliserProfilScreenState extends State<FinaliserProfilScreen> {
  final ImagePicker _picker = ImagePicker();
  String? _selectedDateOfBirth;
  String? _selectedLocation;
  final List<String> _allCompetences = const [
    'Livraisons',
    'Cuisine',
    'Evenementiel',
    'Serveuse',
    'Baby-sitting',
    'Ménage',
    'Vente de Magasin',
  ];
  final Set<String> _selectedCompetences = {};

  // Fonction pour sélectionner une image (caméra ou galerie)
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        // Ici vous pouvez traiter l'image sélectionnée
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

  // Fonction pour afficher le sélecteur de source d'image
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

  // Fonction pour sélectionner la date de naissance
  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)), // 18 ans par défaut
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(const Duration(days: 6570)), // Minimum 18 ans
    );
    
    if (picked != null) {
      setState(() {
        _selectedDateOfBirth = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calcul de la taille de l'écran pour le padding et la responsivité
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: CustomHeader(
        title: 'Finaliser Mon Profil',
        onBack: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            // 1. Barre de Progression
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

            // 2. Photo de Profil
            _buildProfilePhotoSection(context),
            const SizedBox(height: 30),

            // 3. Champs du Formulaire (Date de naissance, Localisation, Compétences)
            _buildDateField(),
            const SizedBox(height: 20),

            _buildTextField(
              hint: 'Localisation',
              icon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 20),

            _buildCompetencesField(),
            const SizedBox(height: 30),

            // 4. Téléversement de la pièce d'identité
            _buildIDUploadSection(),
            const SizedBox(height: 40),

            // 5. Bouton Enregistrer
            _buildSaveButton(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS COMPOSANTS ---

  // Widget pour la barre de progression
  Widget _buildProgressBar(BuildContext context, {required double progress}) {
    // Affiche le pourcentage complété
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
        // Barre de progression linéaire
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

  // Widget pour la section photo de profil
  Widget _buildProfilePhotoSection(BuildContext context) {
    return Column(
      children: [
        // Icône/Image de profil
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
        // Bouton Ajouter/Modifier la photo
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

  // Widget pour le champ de date de naissance
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
              Icon(Icons.calendar_today_outlined, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }

  // Widget pour les champs de texte simples (Localisation)
  Widget _buildTextField({required String hint, required IconData icon}) {
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
        readOnly: hint != 'Localisation', // Rendre la date et la localisation non éditables si un sélecteur est prévu
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: Colors.black54),
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
          suffixIcon: Icon(icon, color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none, // Supprimer la bordure par défaut de l'Outline
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  // Widget pour le champ "Compétences" (liste déroulante multi-sélection)
  Widget _buildCompetencesField() {
    return GestureDetector(
      onTap: _openCompetencesPicker,
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
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
        child: Row(
          children: [
            const Icon(Icons.workspace_premium_outlined, color: orangeBrand),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _selectedCompetences.isEmpty
                    ? 'Compétences'
                    : _selectedCompetences.join(', '),
                style: GoogleFonts.poppins(
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  void _openCompetencesPicker() async {
    final tempInitial = Set<String>.from(_selectedCompetences);
    final result = await showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        final double h = MediaQuery.of(sheetContext).size.height * 0.6;
        return StatefulBuilder(
          builder: (context, setModalState) {
            final temp = tempInitial;
            return SafeArea(
              child: SizedBox(
                height: h,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Row(
                        children: [
                          Text('Choisir des compétences', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(sheetContext).pop(temp),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: ListView(
                        children: _allCompetences.map((c) {
                          final checked = temp.contains(c);
                          return CheckboxListTile(
                            value: checked,
                            title: Text(c, style: GoogleFonts.poppins(fontSize: 14)),
                            activeColor: primaryGreen,
                            onChanged: (v) {
                              setModalState(() {
                                if (v == true) {
                                  temp.add(c);
                                } else {
                                  temp.remove(c);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(sheetContext).pop(temp),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text('Valider', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
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
    );

    if (result != null) {
      setState(() {
        _selectedCompetences
          ..clear()
          ..addAll(result);
      });
    }
  }

  // Widget pour la section de téléversement de la pièce d'identité
  Widget _buildIDUploadSection() {
    return GestureDetector(
      onTap: () {
        _showImageSourceDialog('carte d\'identité');
      },
      child: DottedBorderContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload_outlined, color: Colors.black, size: 40),
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

  // Widget pour le bouton d'enregistrement
  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          // Logique d'enregistrement et de redirection
        },
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

// --- WIDGET UTILITAIRE POUR LA BORDURE EN POINTILLÉS (NON FOURNI PAR FLUTTER DE BASE) ---
// Vous devrez créer ce widget ou utiliser une librairie comme 'dotted_border' si vous voulez exactement l'effet
class DottedBorderContainer extends StatelessWidget {
  final Widget child;

  const DottedBorderContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Ceci est une implémentation simplifiée pour le style, l'effet pointillé réel
    // nécessite un package externe ou un CustomPainter complexe.
    return Container(
      constraints: const BoxConstraints(
        minHeight: 120, // Hauteur minimale
        maxHeight: 150, // Hauteur maximale pour éviter le débordement
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black.withOpacity(0.2),
          style: BorderStyle.solid, // Simplifié : bordure solide
          width: 2,
        ),
      ),
      child: Center(child: child),
    );
  }
}

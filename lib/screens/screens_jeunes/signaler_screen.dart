import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../widgets/custom_header.dart';
import '../../services/user_service.dart';

class SignalerScreen extends StatelessWidget {
  const SignalerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DisputeFormScreen();
  }
}

class DisputeFormScreen extends StatefulWidget {
  DisputeFormScreen({super.key});

  @override
  State<DisputeFormScreen> createState() => _DisputeFormScreenState();
}

class _DisputeFormScreenState extends State<DisputeFormScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6fcfc),
      appBar: CustomHeader(
        title: 'Signaler un litige',
        onBack: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, MediaQuery.of(context).padding.bottom + 20),
        child: DisputeFormContent(
          key: ValueKey('form_content'),
        ),
      ),
    );
  }
}

class DisputeFormContent extends StatefulWidget {
  const DisputeFormContent({super.key});

  @override
  State<DisputeFormContent> createState() => _DisputeFormContentState();
}

class _MissionOption {
  final int id;
  final String title;
  const _MissionOption({required this.id, required this.title});
}

class _DisputeFormContentState extends State<DisputeFormContent> {
  // Contrôleurs pour les champs obligatoires
  final TextEditingController _problemController = TextEditingController();
  
  // État pour la validation
  String? _selectedDisputeType; // valeurs backend
  XFile? _selectedImage;
  int? _selectedMissionId;
  bool _loadingMissions = true;
  String? _missionsError;
  List<_MissionOption> _missions = [];
  
  // Style commun pour les labels
  final TextStyle labelStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: Colors.black87,
  );

  // Style commun pour les bordures
  final OutlineInputBorder borderStyle = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    borderSide: BorderSide(color: Colors.grey, width: 1.0),
  );

  @override
  void dispose() {
    _problemController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadMissionsForUser();
  }

  // Vérifier si le formulaire est valide
  bool get _isFormValid {
    return _selectedDisputeType != null &&
        _selectedMissionId != null &&
        _problemController.text.trim().isNotEmpty;
  }

  Future<void> _loadMissionsForUser() async {
    setState(() {
      _loadingMissions = true;
      _missionsError = null;
      _missions = [];
      _selectedMissionId = null;
    });
    try {
      final info = await UserService.getUserInfo();
      final role = (info['role'] ?? '').toString().toUpperCase();
      if (role.contains('JEUNE')) {
        final resp = await UserService.getMesMissionsAccomplies();
        final list = resp.data.missions;
        final options = <_MissionOption>[];
        for (final m in list) {
          if (m is Map<String, dynamic>) {
            // Préférer l'ID de la mission imbriquée si présent
            dynamic nested = m['mission'] ?? m['Mission'] ?? m['missionObjet'];
            dynamic idAny;
            dynamic titleAny;
            if (nested is Map<String, dynamic>) {
              idAny = nested['id'] ?? nested['missionId'] ?? nested['mission_id'];
              titleAny = nested['titre'] ?? nested['title'] ?? nested['nom'];
            }
            idAny = idAny ?? m['missionId'] ?? m['mission_id'] ?? m['id'];
            titleAny = titleAny ?? m['missionTitre'] ?? m['titre'] ?? m['title'] ?? m['nom'];

            final id = idAny is int ? idAny : int.tryParse(idAny?.toString() ?? '');
            final title = (titleAny?.toString() ?? '').trim();
            if (id != null && id > 0 && title.isNotEmpty) {
              options.add(_MissionOption(id: id, title: title));
            }
          }
        }
        // Logs de diagnostic
        // ignore: avoid_print
        print('🧭 JEUNE missions accomplies total: ' + list.length.toString());
        // ignore: avoid_print
        print('🧭 Options construites: ' + options.map((o) => '[id=' + o.id.toString() + ', title=' + o.title + ']').join(', '));
        setState(() {
          _missions = options;
        });
      } else {
        final resp = await UserService.getMesMissions();
        // Filtrer uniquement les missions TERMINÉES pour le recruteur
        final filtered = resp.data.where((m) =>
            (m.statut ?? '').toString().toUpperCase() == 'TERMINEE');
        // ignore: avoid_print
        print('🧭 RECRUTEUR missions publiées total: ' + resp.data.length.toString() +
            ', TERMINÉES: ' + filtered.length.toString());
        setState(() {
          _missions = filtered
              .map((m) => _MissionOption(id: m.id, title: m.titre))
              .toList();
        });
      }
    } catch (e) {
      setState(() {
        _missionsError = e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
      });
    } finally {
      if (mounted) setState(() => _loadingMissions = false);
    }
  }

  // Fonction pour ouvrir le sélecteur d'images
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    
    // Afficher une boîte de dialogue pour choisir entre caméra et galerie
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text('Appareil photo'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.blue),
                title: const Text('Galerie'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );

    if (source != null) {
      try {
        final XFile? image = await picker.pickImage(source: source);
        if (image != null) {
          setState(() {
            _selectedImage = image;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur lors de la sélection de l\'image: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _submitForm() async {
    if (!_isFormValid) return;
    final type = _selectedDisputeType!;
    final description = _problemController.text.trim();
    final missionId = _selectedMissionId!;
    String? docPath = _selectedImage?.path;

    // Logs de diagnostic côté UI
    // ignore: avoid_print
    print('🧭 UI submit -> type=' + type + ', missionId=' + missionId.toString() + ', hasFile=' + (docPath != null).toString());

    try {
      final resp = await UserService.creerLitige(
        type: type,
        description: description,
        missionId: missionId,
        documentPath: docPath,
      );
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.white,
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          actionsPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          title: Row(
            children: const [
              Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 26),
              SizedBox(width: 8),
              Text('Litige créé', style: TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                'Votre litige a été enregistré avec succès.',
                style: TextStyle(color: Colors.grey.shade700, height: 1.3),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF10B981),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('OK', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst(RegExp(r'^Exception:\\s*'), ''))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Signaler un litige',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Veuillez fournir des détails sur le litige. Incluez toute information ou preuve à l\'appui de votre réclamation.',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 25),

        // Type de Litige
        Text('Le type de Litige', style: labelStyle),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedDisputeType,
          decoration: InputDecoration(
            hintText: 'Sélectionnez le type de Litige',
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            border: borderStyle,
            enabledBorder: borderStyle,
            focusedBorder: borderStyle.copyWith(
              borderSide: const BorderSide(color: Colors.blue, width: 2.0),
            ),
            fillColor: Colors.white,
            filled: true,
          ),
          items: const [
            DropdownMenuItem(value: 'MISSION_NON_PAYEE', child: Text('Mission non payée')),
            DropdownMenuItem(value: 'TRAVAIL_NON_CONFORME', child: Text('Travail non conforme')),
            DropdownMenuItem(value: 'COMPORTEMENT_INAPPROPRIE', child: Text('Comportement inapproprié')),
            DropdownMenuItem(value: 'ANNULATION_TARDIVE', child: Text('Annulation tardive')),
            DropdownMenuItem(value: 'AUTRE', child: Text('Autre')),
          ],
          onChanged: (String? newValue) {
            setState(() {
              _selectedDisputeType = newValue;
            });
          },
        ),
        const SizedBox(height: 25),

        // Décrire le problème
        Text('Décrire le problème', style: labelStyle),
        const SizedBox(height: 8),
        TextFormField(
          controller: _problemController,
          maxLines: 5,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Explique ce qui s\'est passé',
            contentPadding: const EdgeInsets.all(15),
            border: borderStyle,
            enabledBorder: borderStyle,
            focusedBorder: borderStyle.copyWith(
              borderSide: const BorderSide(color: Colors.blue, width: 2.0),
            ),
            fillColor: Colors.white,
            filled: true,
          ),
        ),
        const SizedBox(height: 25),

        // Joindre des documents
        Text('Joindre des documents (facultatif)', style: labelStyle),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: _selectedImage != null ? Colors.green : Colors.grey.shade300,
                width: 1.5,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
            child: _selectedImage != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 35,
                        color: Colors.green,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _selectedImage!.name,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Appuyez pour changer',
                        style: TextStyle(color: Colors.blue, fontSize: 12),
                      ),
                    ],
                  )
                : const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 35,
                  color: Colors.grey,
                ),
                SizedBox(height: 8),
                Text(
                  'Televerser la photo de votre carte d\'identité',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 25),

        // Sélectionner la mission
        Text('Sélectionnez la mission', style: labelStyle),
        const SizedBox(height: 8),
        Builder(
          builder: (_) {
            if (_loadingMissions) {
              return const Center(child: Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator()));
            }
            if (_missionsError != null) {
              return Text(_missionsError!, style: const TextStyle(color: Colors.red));
            }
            return DropdownButtonFormField<int>(
              value: _selectedMissionId,
              decoration: InputDecoration(
                hintText: 'Sélectionnez une mission',
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                border: borderStyle,
                enabledBorder: borderStyle,
                focusedBorder: borderStyle.copyWith(
                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
              items: _missions
                  .map((m) => DropdownMenuItem<int>(
                        value: m.id,
                        child: Text(m.title, overflow: TextOverflow.ellipsis),
                      ))
                  .toList(),
              onChanged: (int? newValue) {
                setState(() => _selectedMissionId = newValue);
              },
            );
          },
        ),
        const SizedBox(height: 40),

        // Bouton Soumettre
        SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            onPressed: _isFormValid ? _submitForm : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isFormValid 
                  ? const Color(0xFFF9A825) 
                  : Colors.grey.shade300,
              disabledBackgroundColor: Colors.grey.shade300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              elevation: 4,
            ),
            child: Text(
              'Soumettre le signalement',
              style: TextStyle(
                color: _isFormValid ? Colors.white : Colors.grey.shade600,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}

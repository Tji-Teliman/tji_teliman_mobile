import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/custom_header.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'location_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'home_recruteur.dart';
import 'detail_mission_recruteur.dart';
import '../../services/mission_service.dart';
import '../../config/api_config.dart';
import 'package:intl/intl.dart';
import '../../services/category_service.dart';
import '../../models/category.dart';

const Color primaryGreen = Color(0xFF10B981);
const Color bodyBackgroundColor = Color(0xFFf6fcfc);

class PublierMissionScreen extends StatefulWidget {
  const PublierMissionScreen({super.key});

  @override
  State<PublierMissionScreen> createState() => _PublierMissionScreenState();
}

class _PublierMissionScreenState extends State<PublierMissionScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _remunerationController = TextEditingController();
  final _localisationController = TextEditingController();
  final _competencesController = TextEditingController();
  LatLng? _selectedLatLng;

  DateTime? _dateDebut;
  DateTime? _dateFin;
  TimeOfDay? _timeFrom;
  TimeOfDay? _timeTo;
  String? _categorie;
  String? _validationBanner; // message d'avertissement (date/heure incohérentes)
  bool _isSubmitting = false;
  bool _isLoadingCategories = true;
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_onFieldChanged);
    _descriptionController.addListener(_onFieldChanged);
    _remunerationController.addListener(_onFieldChanged);
    _localisationController.addListener(_onFieldChanged);
    _competencesController.addListener(_onFieldChanged);
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      setState(() => _isLoadingCategories = true);
      final cats = await CategoryService.getAllCategories();
      setState(() {
        _categories = cats;
        _isLoadingCategories = false;
      });
    } catch (e) {
      setState(() => _isLoadingCategories = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur chargement catégories: $e')),
      );
    }
  }

  List<String> get _categoryNames => _categories.map((c) => c.nom).toList();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _remunerationController.dispose();
    _localisationController.dispose();
    _competencesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _dateDebut = picked;
        } else {
          _dateFin = picked;
        }
      });
      _updateValidationBanner();
    }
  }

  Future<void> _pickTime({required bool isFrom}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _timeFrom = picked;
        } else {
          _timeTo = picked;
        }
      });
      _updateValidationBanner();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isValid = _isFormValid();
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: const CustomHeader(
        title: 'Publier une Nouvelle Mission',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Veillez Remplir le formulaire publier une nouvelle mission',
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
                ),
                if (_validationBanner != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF4E5),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFFFC107)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.error_outline, color: Color(0xFFFFC107)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _validationBanner!,
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 14),

                _buildTextField(_titleController, hint: 'Titre de la mission'),
                const SizedBox(height: 10),
                _buildMultilineField(_descriptionController, hint: 'description'),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: _buildPickerField(
                        label: _dateDebut == null
                            ? 'Date Début'
                            : _formatDate(_dateDebut!),
                        icon: Icons.calendar_today_outlined,
                        onTap: () => _pickDate(isStart: true),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildPickerField(
                        label: _dateFin == null
                            ? 'Date Fin'
                            : _formatDate(_dateFin!),
                        icon: Icons.calendar_today_outlined,
                        onTap: () => _pickDate(isStart: false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                if (_dateDebut != null && _dateFin != null && _isSameDay(_dateDebut!, _dateFin!))
                  Row(
                    children: [
                      Expanded(
                        child: _buildPickerField(
                          label: _timeFrom == null
                              ? 'DE:'
                              : _formatTime(_timeFrom!),
                          icon: Icons.access_time,
                          onTap: () => _pickTime(isFrom: true),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildPickerField(
                          label: _timeTo == null
                              ? 'A:'
                              : _formatTime(_timeTo!),
                          icon: Icons.access_time,
                          onTap: () => _pickTime(isFrom: false),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 10),

                _isLoadingCategories
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: primaryGreen, strokeWidth: 2)),
                        ),
                      )
                    : _buildDropdownField(
                  value: _categorie,
                  hint: 'Catégorie',
                  onChanged: (v) => setState(() => _categorie = v),
                ),
                const SizedBox(height: 10),
                _buildTextField(_remunerationController, hint: 'Rémunération', keyboardType: TextInputType.number),
                const SizedBox(height: 10),
                _buildLocationPickerField(),
                const SizedBox(height: 10),
                _buildTextField(_competencesController, hint: 'Compétences requis'),

                const SizedBox(height: 18),
                SizedBox(
                  height: 46,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isValid && !_isSubmitting ? primaryGreen : Colors.grey,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      elevation: 3,
                    ),
                    child: _isSubmitting
                        ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text(
                      'Publier la mission',
                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  String _formatTime(TimeOfDay t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  Widget _buildTextField(TextEditingController controller, {required String hint, TextInputType? keyboardType}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: Colors.black54),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildMultilineField(TextEditingController controller, {required String hint}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        minLines: 3,
        maxLines: 5,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: Colors.black54),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildPickerField({required String label, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black.withOpacity(0.1)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(color: Colors.black87, fontSize: 13),
              ),
            ),
            Icon(icon, size: 18, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationPickerField() {
    final String label = _localisationController.text.isNotEmpty
        ? _localisationController.text
        : (_selectedLatLng == null
            ? 'Localisation'
            : '${_selectedLatLng!.latitude.toStringAsFixed(5)}, ${_selectedLatLng!.longitude.toStringAsFixed(5)}');
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black.withOpacity(0.1)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final result = await Navigator.of(context).push<LatLng>(
                  MaterialPageRoute(
                    builder: (context) => LocationPickerScreen(initialLocation: _selectedLatLng),
                  ),
                );
                if (result != null) {
                  await _setAddressFromLatLng(result);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                child: Row(
                  children: [
                    const Icon(Icons.place_outlined, size: 18, color: Colors.black54),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        label,
                        style: GoogleFonts.poppins(color: Colors.black87, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: _useCurrentLocation,
            icon: const Icon(Icons.my_location, size: 18),
            label: Text('Ma position', style: GoogleFonts.poppins(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Future<void> _useCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Activez la localisation.')));
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Permission localisation refusée.')));
        return;
      }

      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      await _setAddressFromLatLng(LatLng(pos.latitude, pos.longitude));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur localisation: $e')));
    }
  }

  Future<void> _setAddressFromLatLng(LatLng latLng) async {
    try {
      final placemarks = await geocoding.placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      String? address;
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final parts = [
          p.street,
          p.subLocality,
          p.locality,
          p.administrativeArea,
          p.country,
        ].where((e) => e != null && e!.trim().isNotEmpty).map((e) => e!.trim()).toList();
        address = parts.join(', ');
      }
      setState(() {
        _selectedLatLng = latLng;
        if (address != null && address!.isNotEmpty) {
          _localisationController.text = address!;
        } else {
          _localisationController.text = '${latLng.latitude.toStringAsFixed(5)}, ${latLng.longitude.toStringAsFixed(5)}';
        }
      });
    } catch (_) {
      setState(() {
        _selectedLatLng = latLng;
        _localisationController.text = '${latLng.latitude.toStringAsFixed(5)}, ${latLng.longitude.toStringAsFixed(5)}';
      });
    }
  }

  Widget _buildDropdownField({required String? value, required String hint, required ValueChanged<String?> onChanged}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black.withOpacity(0.1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Text(hint, style: GoogleFonts.poppins(color: Colors.black54)),
          items: _categoryNames.map((c) => DropdownMenuItem(value: c, child: Text(c, style: GoogleFonts.poppins()))).toList(),
          onChanged: onChanged,
          icon: const Icon(Icons.expand_more),
        ),
      ),
    );
  }

  void _submit() {
    if (!_validateFormAndShowErrors()) return;
    _showConfirmPublishDialog();
  }

  void _showConfirmPublishDialog() {
    final raw = _remunerationController.text.trim();
    final baseAmount = double.tryParse(raw) ?? 0;
    final fee = baseAmount * 0.02;
    final total = baseAmount + fee;

    String _formatAmount(double value) {
      final intVal = value.round();
      final str = intVal.toString();
      final reg = RegExp(r'(?=(?!^)(\d{3})+\b)');
      return str.replaceAllMapped(reg, (m) => ' ' + m.group(0)!);
    }

    final baseText = _formatAmount(baseAmount) + ' CFA';
    final feeText = _formatAmount(fee) + ' CFA';
    final totalText = _formatAmount(total) + ' CFA';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: primaryGreen.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.info, color: primaryGreen),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Confirmer la publication',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Avant de publier cette mission, veuillez confirmer le montant associé à la mission ainsi que les frais appliqués.',
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87, height: 1.4),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Montant de la mission', style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87)),
                          Text(baseText, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Frais de la mission', style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87)),
                          Text(feeText, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
                        ],
                      ),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Montant total à payer', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
                          Text(totalText, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: primaryGreen)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade400),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                        ),
                        child: Text(
                          'Annuler',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.black87),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          _publishMission();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                          elevation: 0,
                        ),
                        child: Text(
                          'Confirmer',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _publishMission() async {
    if (!_validateFormAndShowErrors()) return;
    try {
      setState(() => _isSubmitting = true);

      final payload = _buildApiPayload();
      final result = await MissionService.createMission(payload);

      if (result.success) {
      _showPublishSuccessDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Publication échouée: ${result.message}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur publication: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Map<String, dynamic> _buildApiPayload() {
    final dateFmt = DateFormat('yyyy-MM-dd');
    String? heureDebut;
    String? heureFin;
    if (_isSameDay(_dateDebut!, _dateFin!)) {
      if (_timeFrom != null) {
        heureDebut = _formatTime(_timeFrom!);
      }
      if (_timeTo != null) {
        heureFin = _formatTime(_timeTo!);
      }
    }

    return <String, dynamic>{
      'titre': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'dateDebut': dateFmt.format(_dateDebut!),
      'dateFin': dateFmt.format(_dateFin!),
      'exigence': _competencesController.text.trim(),
      'remuneration': double.tryParse(_remunerationController.text.trim()) ?? 0,
      if (heureDebut != null) 'heureDebut': heureDebut,
      if (heureFin != null) 'heureFin': heureFin,
      'categorieNom': _categorie!,
      if (_selectedLatLng != null) 'latitude': _selectedLatLng!.latitude,
      if (_selectedLatLng != null) 'longitude': _selectedLatLng!.longitude,
      if (_localisationController.text.trim().isNotEmpty) 'adresse': _localisationController.text.trim(),
    };
  }

  void _resetForm() {
    _titleController.clear();
    _descriptionController.clear();
    _remunerationController.clear();
    _localisationController.clear();
    _competencesController.clear();
    setState(() {
      _dateDebut = null;
      _dateFin = null;
      _timeFrom = null;
      _timeTo = null;
      _categorie = null;
      _selectedLatLng = null;
      _validationBanner = null;
    });
  }

  void _showPublishSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: primaryGreen.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: primaryGreen, size: 32),
                  ),
                ),
                const SizedBox(height: 14),
                Center(
                  child: Text(
                    'Mission Publier !',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Votre mission est maintenant publiée, et les candidats peuvent commencer à postuler. Vous serez averti dès que de nouvelles candidatures seront présentées.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87, height: 1.4),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      final missionData = _buildMissionData();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (c) => DetailMissionRecruteurScreen(missionData: missionData),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                      elevation: 0,
                    ),
                    child: Text('Voir la mission', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 44,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      _resetForm();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: primaryGreen, width: 1.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                    ),
                    child: Text('Publier une autre Mission', style: GoogleFonts.poppins(color: primaryGreen, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 44,
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (c) => const HomeRecruteurScreen()),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 18),
                    label: Text(
                      "Retour à l'Accueil",
                      style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w600),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
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

  bool _validateFormAndShowErrors() {
    String? error;
    if (_titleController.text.trim().isEmpty) {
      error = 'Le titre de la mission est obligatoire.';
    } else if (_descriptionController.text.trim().isEmpty) {
      error = 'La description est obligatoire.';
    } else if (_dateDebut == null) {
      error = 'La date de début est obligatoire.';
    } else if (_dateFin == null) {
      error = 'La date de fin est obligatoire.';
    } else if (_dateDebut != null && _dateFin != null && _dateFin!.isBefore(_dateDebut!)) {
      error = 'La date de fin ne peut pas être inférieure à la date de début.';
    } else if (_isSameDay(_dateDebut!, _dateFin!) && _timeFrom == null) {
      error = 'L\'heure de début est obligatoire pour une mission d\'une journée.';
    } else if (_isSameDay(_dateDebut!, _dateFin!) && _timeTo == null) {
      error = 'L\'heure de fin est obligatoire pour une mission d\'une journée.';
    } else if (_isSameDay(_dateDebut!, _dateFin!) && _timeFrom != null && _timeTo != null) {
      final fromMinutes = _timeFrom!.hour * 60 + _timeFrom!.minute;
      final toMinutes = _timeTo!.hour * 60 + _timeTo!.minute;
      if (toMinutes - fromMinutes <= 0) {
        error = 'L\'heure de fin doit être supérieure à l\'heure de début.';
      }
    } else if (_categorie == null || _categorie!.trim().isEmpty) {
      error = 'La catégorie est obligatoire.';
    } else if (_remunerationController.text.trim().isEmpty) {
      error = 'La rémunération est obligatoire.';
    } else if (double.tryParse(_remunerationController.text.trim()) == null) {
      error = 'La rémunération doit être un nombre valide.';
    } else if (_selectedLatLng == null) {
      error = 'La localisation est obligatoire.';
    }

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      setState(() {
        _validationBanner = error;
      });
      return false;
    }
    setState(() {
      _validationBanner = null;
    });
    return true;
  }

  bool _isFormValid() {
    if (_titleController.text.trim().isEmpty) return false;
    if (_descriptionController.text.trim().isEmpty) return false;
    if (_dateDebut == null || _dateFin == null) return false;
    if (_dateFin!.isBefore(_dateDebut!)) return false;
    if (_isSameDay(_dateDebut!, _dateFin!)) {
      if (_timeFrom == null || _timeTo == null) return false;
      final fromMinutes = _timeFrom!.hour * 60 + _timeFrom!.minute;
      final toMinutes = _timeTo!.hour * 60 + _timeTo!.minute;
      if (toMinutes - fromMinutes <= 0) return false;
    }
    if (_categorie == null || _categorie!.trim().isEmpty) return false;
    if (_remunerationController.text.trim().isEmpty) return false;
    if (double.tryParse(_remunerationController.text.trim()) == null) return false;
    if (_selectedLatLng == null) return false;
    return true;
  }

  Map<String, dynamic> _buildMissionData() {
    final String title = _titleController.text.trim();
    final String? description = _descriptionController.text.trim();
    final String? locationLabel = _localisationController.text.trim().isEmpty
        ? null
        : _localisationController.text.trim();

    String? duration;
    if (_timeFrom != null && _timeTo != null) {
      duration = 'Estimé: ${_timeFrom!.format(context)} - ${_timeTo!.format(context)}';
    }

    String? dateLimit;
    if (_dateFin != null) {
      dateLimit = 'Date Limite: ${_formatDate(_dateFin!)}';
    }

    return <String, dynamic>{
      'missionTitle': title,
      if (description != null && description.isNotEmpty) 'description': description,
      if (_selectedLatLng != null) 'latitude': _selectedLatLng!.latitude,
      if (_selectedLatLng != null) 'longitude': _selectedLatLng!.longitude,
      if (locationLabel != null) 'location': locationLabel,
      if (duration != null) 'duration': duration,
      if (dateLimit != null) 'dateLimit': dateLimit,
      if (_competencesController.text.trim().isNotEmpty) 'competences': _competencesController.text.trim(),
      if (_dateDebut != null) 'dateDebut': _formatDate(_dateDebut!),
      if (_dateFin != null) 'dateFin': _formatDate(_dateFin!),
      if (_isSameDay(_dateDebut ?? DateTime(0), _dateFin ?? DateTime(1)) && _timeFrom != null) 'timeFrom': _formatTime(_timeFrom!),
      if (_isSameDay(_dateDebut ?? DateTime(0), _dateFin ?? DateTime(1)) && _timeTo != null) 'timeTo': _formatTime(_timeTo!),
    };
  }

  void _updateValidationBanner() {
    String? msg;
    if (_dateDebut != null && _dateFin != null && _dateFin!.isBefore(_dateDebut!)) {
      msg = 'La date de fin ne peut pas être inférieure à la date de début.';
    } else if (_dateDebut != null && _dateFin != null && _isSameDay(_dateDebut!, _dateFin!) && _timeFrom != null && _timeTo != null) {
      final fromMinutes = _timeFrom!.hour * 60 + _timeFrom!.minute;
      final toMinutes = _timeTo!.hour * 60 + _timeTo!.minute;
      if (toMinutes - fromMinutes <= 0) {
        msg = 'L\'heure de fin doit être supérieure à l\'heure de début.';
      }
    }
    setState(() {
      _validationBanner = msg;
    });
  }

  void _onFieldChanged() {
    // Met à jour la couleur du bouton en temps réel
    setState(() {});
  }
}



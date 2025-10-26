import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/custom_header.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'location_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

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

  final List<String> _categories = const [
    'Ménage', 'Baby-sitting', 'Cuisine', 'Livraison', 'Événementiel', 'Autre'
  ];

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: const CustomHeader(
        title: 'Publier une Nouvelle Mission',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
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

                _buildDropdownField(
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
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      elevation: 3,
                    ),
                    child: Text(
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
          items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: GoogleFonts.poppins()))).toList(),
          onChanged: onChanged,
          icon: const Icon(Icons.expand_more),
        ),
      ),
    );
  }

  void _submit() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mission publiée (mock)')),
    );
  }
}



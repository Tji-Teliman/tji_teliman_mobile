import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
// Pour GoogleMap, utilisons un AppBar standard afin d'éviter tout overlay

const Color bodyBackgroundColor = Color(0xFFf6fcfc);
const Color primaryGreen = Color(0xFF10B981);

class LocationPickerScreen extends StatefulWidget {
  final LatLng? initialLocation;
  const LocationPickerScreen({super.key, this.initialLocation});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _mapController;
  LatLng? _selected;
  String? _selectedAddress;

  static const LatLng _defaultCenter = LatLng(12.6392, -8.0029); // Bamako par défaut

  @override
  Widget build(BuildContext context) {
    final LatLng start = widget.initialLocation ?? _selected ?? _defaultCenter;
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2f9bcf),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Choisir une Localisation',
            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: start, zoom: 13),
              onMapCreated: (c) => _mapController = c,
              onTap: (pos) async {
                setState(() {
                  _selected = pos;
                  _selectedAddress = null; // reset while loading
                });
                await _reverseGeocode(pos);
              },
              markers: _selected == null
                  ? {}
                  : {
                      Marker(
                        markerId: const MarkerId('selected'),
                        position: _selected!,
                      ),
                    },
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              compassEnabled: true,
              zoomControlsEnabled: true,
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: MediaQuery.of(context).padding.bottom + 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _selected == null
                      ? 'Touchez la carte pour choisir un point.'
                      : (_selectedAddress != null && _selectedAddress!.isNotEmpty
                          ? _selectedAddress!
                          : 'Point sélectionné: ${_selected!.latitude.toStringAsFixed(5)}, ${_selected!.longitude.toStringAsFixed(5)}'),
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 46,
                  child: ElevatedButton(
                    onPressed: _selected == null
                        ? null
                        : () => Navigator.of(context).pop<LatLng>(_selected),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Confirmer la position',
                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _reverseGeocode(LatLng pos) async {
    try {
      final placemarks = await geocoding.placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final addressParts = [
          p.street,
          p.subLocality,
          p.locality,
          p.administrativeArea,
          p.country,
        ].where((e) => e != null && e!.trim().isNotEmpty).map((e) => e!.trim()).toList();
        setState(() {
          _selectedAddress = addressParts.join(', ');
        });
      }
    } catch (_) {
      // ignore geocoding errors, keep coordinates fallback
    }
  }
}



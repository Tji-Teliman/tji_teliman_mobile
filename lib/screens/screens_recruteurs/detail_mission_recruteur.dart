import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../widgets/custom_header.dart';
import 'candidature_missions.dart';
import '../../services/mission_service.dart';

const Color primaryGreen = Color(0xFF10B981);
const Color primaryBlue = Color(0xFF2563EB);
const Color bodyBackgroundColor = Color(0xFFf6fcfc);

class MapMissionCardRecruiter extends StatelessWidget {
  final LatLng location;

  const MapMissionCardRecruiter({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    const double mapHeight = 200.0;
    final Set<Marker> markers = {
      Marker(
        markerId: const MarkerId('missionLocation'),
        position: location,
        infoWindow: const InfoWindow(title: 'Lieu de la Mission'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    };

    return Container(
      height: mapHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(target: location, zoom: 15),
          markers: markers,
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {},
        ),
      ),
    );
  }
}

class DetailMissionRecruteurScreen extends StatelessWidget {
  final Map<String, dynamic> missionData;

  const DetailMissionRecruteurScreen({super.key, required this.missionData});

  static const LatLng _fallbackLocation = LatLng(12.639232, -8.002888);

  Widget _buildRequirement(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: primaryGreen, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailIcon({required IconData icon, required String label}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.black, size: 28),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            label,
            style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.black54),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double lat = (missionData['latitude'] as double?) ?? _fallbackLocation.latitude;
    final double lng = (missionData['longitude'] as double?) ?? _fallbackLocation.longitude;
    final LatLng missionLocation = LatLng(lat, lng);

    final String missionTitle = missionData['missionTitle'] ?? 'Aide Déménagement';
    final bool isLongTitle = missionTitle.length > 24;
    final String status = (missionData['statut'] ?? missionData['status'] ?? '').toString().toLowerCase().trim();
    final String normalized = status.replaceAll(' ', '').replaceAll('_', '');
    final bool canDelete = normalized.contains('attente') || normalized.contains('pending') || normalized == 'enattente';
    final dynamic rawId = missionData['missionId'] ?? missionData['id'];
    final int? missionId = (rawId is int) ? rawId : (rawId is String ? int.tryParse(rawId) : null);

    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: CustomHeader(
        title: missionTitle,
        useCompactStyle: isLongTitle,
        onBack: () => Navigator.of(context).pop(),
        customRightWidget: canDelete && missionId != null
            ? GestureDetector(
                onTap: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) {
                      return Dialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 54,
                                height: 54,
                                decoration: BoxDecoration(color: Colors.red.withOpacity(0.12), shape: BoxShape.circle),
                                child: const Icon(Icons.delete_outline, color: Colors.red, size: 30),
                              ),
                              const SizedBox(height: 12),
                              Text('Confirmer la suppression', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 6),
                              Text(
                                'Voulez-vous supprimer cette mission ?',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => Navigator.of(ctx).pop(false),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: Colors.grey.shade300),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                      ),
                                      child: Text('Annuler', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87)),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () => Navigator.of(ctx).pop(true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                      ),
                                      child: Text('Supprimer', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
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
                  if (confirmed == true) {
                    try {
                      final ok = await MissionService.deleteMission(missionId);
                      if (!context.mounted) return;
                      if (ok) {
                        await showDialog(
                          context: context,
                          builder: (ctx) {
                            return Dialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 54,
                                      height: 54,
                                      decoration: BoxDecoration(color: primaryGreen.withOpacity(0.15), shape: BoxShape.circle),
                                      child: const Icon(Icons.check, color: primaryGreen, size: 30),
                                    ),
                                    const SizedBox(height: 12),
                                    Text('Mission supprimée', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 6),
                                    Text(
                                      'La mission a été supprimée avec succès.',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
                                    ),
                                    const SizedBox(height: 14),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 42,
                                      child: ElevatedButton(
                                        onPressed: () => Navigator.of(ctx).pop(),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryGreen,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        ),
                                        child: Text('OK', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                        Navigator.of(context).pop(true);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Échec de la suppression de la mission')),
                        );
                      }
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erreur: ${e.toString()}')),
                      );
                    }
                  }
                },
                child: const Icon(Icons.delete_outline, color: Colors.white, size: 24),
              )
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description de la Mission',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    missionData['description'] ??
                        "Déménagement d'un appartement situé au 2e étage sans ascenseur. Aide au transport de cartons et de quelques meubles démontés jusqu'au camion de déménagement. Une autre personne sera présente pour prêter main-forte.\n\nRendez-vous à 9h.",
                    style: GoogleFonts.poppins(fontSize: 15, color: Colors.black54, height: 1.4),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            if ((missionData['competences'] as String?) != null && (missionData['competences'] as String).trim().isNotEmpty)
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Exigences Clés',
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 10),
                    ...((missionData['competences'] as String)
                            .split(',')
                            .map((e) => e.trim())
                            .where((e) => e.isNotEmpty)
                            .map((e) => _buildRequirement(e))
                            .toList()),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: _buildDetailIcon(
                        icon: Icons.location_on_outlined,
                        label: missionData['location'] ?? 'Kalaban Coura (Lat: ${missionLocation.latitude.toStringAsFixed(3)})',
                      ),
                    ),
                    const VerticalDivider(width: 24, thickness: 1, color: Color(0xFFE5E7EB)),
                    Expanded(
                      child: _buildDetailIcon(
                        icon: _durationIcon(missionData),
                        label: _computeDurationOrDate(missionData),
                      ),
                    ),
                    const VerticalDivider(width: 24, thickness: 1, color: Color(0xFFE5E7EB)),
                    Expanded(
                      child: _buildDetailIcon(
                        icon: Icons.calendar_today_outlined,
                        label: _dateLimitLabel(missionData),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Localisation sur la Carte',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            MapMissionCardRecruiter(location: missionLocation),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5)),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                final String title = (missionData['missionTitle'] as String?) ?? 'Mission';
                final dynamic rawId = missionData['missionId'] ?? missionData['id'];
                final int? missionId = (rawId is int)
                    ? rawId
                    : (rawId is String ? int.tryParse(rawId) : null);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CandidatureMissionsScreen(
                      missionTitle: title,
                      missionId: missionId,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 0,
              ),
              child: Text(
                'Voir Candidature',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _computeDurationOrDate(Map<String, dynamic> data) {
    final String? dateDebut = data['dateDebut'] as String?; // format dd/MM/yyyy
    final String? dateFin = data['dateFin'] as String?; // format dd/MM/yyyy
    final String? timeFrom = data['timeFrom'] as String?; // format HH:mm
    final String? timeTo = data['timeTo'] as String?; // format HH:mm

    if (dateDebut == null) {
      return data['duration'] as String? ?? 'Estimation indisponible';
    }

    if (dateFin != null && dateFin != dateDebut) {
      // Dates différentes: calculer nombre de jours (robuste aux changements d'heure)
      final dStart = _parseDateUtc(dateDebut);
      final dEnd = _parseDateUtc(dateFin);
      if (dStart != null && dEnd != null) {
        final diffDays = dEnd.difference(dStart).inDays; // exclusif (29-27 = 2)
        final safeDays = diffDays < 1 ? 1 : diffDays;
        final label = safeDays == 1 ? '1 jour' : '$safeDays jours';
        return 'Estimé: $label';
      }
      return 'Estimé: n/j';
    }

    // Même jour
    if (timeFrom != null && timeTo != null) {
      try {
        final partsFrom = timeFrom.split(':');
        final partsTo = timeTo.split(':');
        final fromMinutes = int.parse(partsFrom[0]) * 60 + int.parse(partsFrom[1]);
        final toMinutes = int.parse(partsTo[0]) * 60 + int.parse(partsTo[1]);
        int diff = toMinutes - fromMinutes;
        if (diff < 0) diff += 24 * 60; // gestion dépassement minuit
        final hours = diff ~/ 60;
        final minutes = diff % 60;
        final buffer = StringBuffer('Estimé: ');
        if (hours > 0) buffer.write('$hours h');
        if (minutes > 0) buffer.write(hours > 0 ? ' $minutes min' : '$minutes min');
        if (hours == 0 && minutes == 0) buffer.write('0 min');
        return buffer.toString();
      } catch (_) {
        return 'Début: $dateDebut';
      }
    }

    // Même jour mais pas d'heures précises -> afficher la date
    return 'Début: $dateDebut';
  }

  IconData _durationIcon(Map<String, dynamic> data) {
    final String? dateDebut = data['dateDebut'] as String?;
    final String? dateFin = data['dateFin'] as String?;
    final String? timeFrom = data['timeFrom'] as String?;
    final String? timeTo = data['timeTo'] as String?;

    if (dateDebut != null && dateFin != null && dateFin != dateDebut) {
      // durée en jours -> icône horloge
      return Icons.access_time;
    }
    final bool isDuration = dateDebut != null && dateFin == dateDebut && timeFrom != null && timeTo != null;
    return isDuration ? Icons.access_time : Icons.calendar_today_outlined;
  }

  String _dateLimitLabel(Map<String, dynamic> data) {
    final String? dateDebut = data['dateDebut'] as String?;
    if (dateDebut != null) return 'Date début: $dateDebut';
    return data['dateLimit'] as String? ?? 'Date début: -';
  }

  DateTime? _parseDateUtc(String s) {
    try {
      final parts = s.split('/');
      return DateTime.utc(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
    } catch (_) {
      return null;
    }
  }
}



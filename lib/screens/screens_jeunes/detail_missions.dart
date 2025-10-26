import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Importation nécessaire pour Google Maps
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ⚠️ Assurez-vous d'importer le bon chemin pour le CustomHeader
import '../../widgets/custom_header.dart'; 
import '../../widgets/custom_bottom_nav_bar.dart'; // Si vous avez une barre de navigation en bas
import 'motivation.dart';
import 'signaler_mission.dart';

// --- COULEURS ET CONSTANTES (réutilisées depuis missions_screens.dart) ---
const Color primaryGreen = Color(0xFF10B981); 
const Color darkGreen = Color(0xFF00C78C); 
const Color primaryBlue = Color(0xFF2563EB); 
const Color bodyBackgroundColor = Color(0xFFf6fcfc); 

// Widget dédié à l'affichage de la carte
class MapMissionCard extends StatelessWidget {
  final LatLng location;

  const MapMissionCard({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    // Hauteur fixe pour la carte (ajustez selon votre design)
    const double mapHeight = 200.0;
    
    // Marqueur représentant la mission
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
          initialCameraPosition: CameraPosition(
            target: location,
            zoom: 15, // Niveau de zoom proche
          ),
          markers: markers,
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          // La gestion du contrôleur (MapController) n'est pas nécessaire pour une carte statique
          onMapCreated: (GoogleMapController controller) {
            // Optionnel: vous pouvez stocker le contrôleur ici si vous voulez le manipuler plus tard
          },
        ),
      ),
    );
  }
}

class DetailMissionScreen extends StatelessWidget {
  // Vous pouvez passer l'ID ou les données de la mission ici
  final Map<String, dynamic> missionData;

  const DetailMissionScreen({super.key, required this.missionData});

  // Coordonnées de repli (si les données réelles sont manquantes)
  // J'utilise ici un exemple de localisation à Bamako.
  static const LatLng _fallbackLocation = LatLng(12.639232, -8.002888); 

  // Helper pour afficher les étoiles
  Widget _buildRatingStars(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    
    for (int i = 0; i < 5; i++) {
      stars.add(
        Icon(
          i < fullStars ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 18,
        ),
      );
    }
    return Row(children: stars);
  }

  // Helper pour les informations sous la description (Localisation, Durée, Date Limite)
  // NOTE: Icône en noir (Colors.black)
  Widget _buildDetailIcon({required IconData icon, required String label}) {
    return Column(
      mainAxisSize: MainAxisSize.min, // S'assure que la colonne prend le moins d'espace vertical
      children: [
        // Icône en NOIR, comme demandé
        Icon(icon, color: Colors.black, size: 28), 
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
            maxLines: 2, // Limite le texte pour qu'il ne dépasse pas le trait de séparation
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Helper pour les exigences clés (checkmarks)
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
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Logique pour extraire les coordonnées réelles
    // ⚠️ COORDONNÉES DE DÉMONSTRATION: Si missionData ne contient pas lat/lng, 
    // les valeurs par défaut sont utilisées pour afficher la carte.
    final double? lat = missionData['latitude'] as double? ?? _fallbackLocation.latitude;
    final double? lng = missionData['longitude'] as double? ?? _fallbackLocation.longitude;
    
    // Le point de localisation de la mission
    final LatLng missionLocation = LatLng(lat!, lng!);
      
    // Titre de mission et détection d'un titre long (affiché sur 2 lignes)
    final String missionTitle = missionData['missionTitle'] ?? 'Aide Déménagement';
    final bool isLongTitle = missionTitle.length > 24; // seuil simple pour réduire la taille

    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      
      // 1. Header Personnalisé
      appBar: CustomHeader(
        title: missionTitle,
        // Réduit légèrement la taille pour les titres sur 2 lignes uniquement
        useCompactStyle: isLongTitle,
        customRightWidget: GestureDetector(
          onTap: () {
            // Navigation vers la page signaler mission
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SignalerMission()),
            );
          },
          child: const Icon(
            Icons.warning_amber_outlined,
            color: Colors.white,
            size: 24,
          ),
        ),
        onBack: () => Navigator.of(context).pop(),
      ),

      // 2. Corps de la Page
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            
            // --- SECTION 1 : RECRUTEUR ET DESCRIPTION ---
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
                    'Recruteur',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Infos Recruteur (Photo, Nom, Note)
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage('assets/images/amadou.jpg'), // ⚠️ Remplacer par la vraie image
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Amadou B.',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          _buildRatingStars(4.5), // Note 4.5/5
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Description de la Mission
                  Text(
                    'Description de la Mission',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    missionData['description'] ?? 
                      "Déménagement d'un appartement situé au 2e étage sans ascenseur. Aide au transport de cartons et de quelques meubles démontés jusqu'au camion de déménagement. Une autre personne sera présente pour prêter main-forte.\n\nRendez-vous à 9h.",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- SECTION 2 : EXIGENCES CLÉS ---
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
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildRequirement('Force physique à sécurité'),
                  _buildRequirement('Disponibilité le matin'),
                ],
              ),
            ),
            
            const SizedBox(height: 20),

            // --- SECTION 3 : INFOS HORAIRES / LOCALISATION (Modifiée avec séparateurs) ---
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
              child: IntrinsicHeight( // Permet aux VerticalDivider de prendre la hauteur maximale
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // 1. Localisation
                    Expanded(
                      child: _buildDetailIcon(
                        // Afficher les coordonnées de démo si l'adresse textuelle n'est pas fournie
                        icon: Icons.location_on_outlined, 
                        label: missionData['location'] ?? 'Kalaban Coura (Lat: ${missionLocation.latitude.toStringAsFixed(3)})',
                      ),
                    ),
                    
                    // Trait de séparation
                    const VerticalDivider(
                      width: 24, // Espace autour du trait
                      thickness: 1, 
                      color: Color(0xFFE5E7EB), // Une couleur de trait légère
                    ),

                    // 2. Durée
                    Expanded(
                      child: _buildDetailIcon(
                        icon: Icons.access_time, 
                        label: missionData['duration'] ?? 'Estimé: 3heures',
                      ),
                    ),

                    // Trait de séparation
                    const VerticalDivider(
                      width: 24, // Espace autour du trait
                      thickness: 1, 
                      color: Color(0xFFE5E7EB),
                    ),
                    
                    // 3. Date Limite
                    Expanded(
                      child: _buildDetailIcon(
                        icon: Icons.calendar_today_outlined, 
                        label: missionData['dateLimit'] ?? 'Date Limite: 25/10/23',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),

            // --- SECTION 4 : AFFICHAGE DE LA CARTE GOOGLE MAPS ---
            Text(
              'Localisation sur la Carte',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            
            // Inclusion du nouveau widget de carte, utilisant les coordonnées réelles ou de repli
            MapMissionCard(location: missionLocation),
            
            const SizedBox(height: 20),
            
            // Le bouton "POSTULER À CETTE MISSION" est dans la bottomNavBar pour le fixer
            
          ],
        ),
      ),

      // 3. Bouton Fixe "Postuler" dans la BottomNavigationBar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                final String title = (missionData['missionTitle'] as String?) ?? 'Aide Déménagement';
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MotivationScreen(missionTitle: title),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen, 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: Text(
                'POSTULER À CETTE MISSION',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

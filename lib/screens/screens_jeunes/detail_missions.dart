import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Importation nécessaire pour Google Maps
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../config/api_config.dart';

// ⚠️ Assurez-vous d'importer le bon chemin pour le CustomHeader
import '../../widgets/custom_header.dart'; 
import '../../widgets/custom_bottom_nav_bar.dart'; // Si vous avez une barre de navigation en bas
import '../../services/mission_service.dart';
import '../../services/user_service.dart';
import '../../models/mission_detail_response.dart';
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

class DetailMissionScreen extends StatefulWidget {
  final int missionId;

  const DetailMissionScreen({super.key, required this.missionId});

  @override
  State<DetailMissionScreen> createState() => _DetailMissionScreenState();
}

class _DetailMissionScreenState extends State<DetailMissionScreen> {
  bool _isLoading = true;
  bool _hasError = false;
  MissionDetailData? _missionData;
  String? _recruteurName;
  String? _recruteurPhotoUrl;
  double _recruteurRating = 0.0;

  // Coordonnées de repli (si les données réelles sont manquantes)
  static const LatLng _fallbackLocation = LatLng(12.639232, -8.002888);

  @override
  void initState() {
    super.initState();
    _loadMissionData();
  }

  Future<void> _loadMissionData() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      print('🔄 Chargement de la mission ID: ${widget.missionId}...');
      final response = await MissionService.getMissionById(widget.missionId);
      
      if (response.success && response.data != null) {
        setState(() {
          _missionData = response.data;
          _isLoading = false;
        });

        // TODO: Charger les infos du recruteur si disponible
        // Pour l'instant, on utilise des valeurs par défaut car l'API ne les fournit pas
        _loadRecruteurInfo();
      } else {
        throw Exception('Erreur: ${response.message}');
      }
    } catch (e) {
      print('❌ Erreur lors du chargement de la mission: $e');
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadRecruteurInfo() async {
    // Charger les infos du recruteur depuis les données de la mission
    if (_missionData != null) {
      final fullName = '${_missionData!.recruteurPrenom} ${_missionData!.recruteurNom}'.trim();
      final photoPath = _missionData!.recruteurUrlPhoto;
      final rating = _missionData!.recruteurNote ?? 0.0;
      
      // Convertir le chemin de la photo en URL HTTP
      final photoUrl = _convertPhotoPathToUrl(photoPath);
      
      setState(() {
        _recruteurName = fullName.isNotEmpty ? fullName : 'Recruteur';
        _recruteurPhotoUrl = photoUrl;
        _recruteurRating = rating;
      });
      
      print('✅ Infos recruteur chargées:');
      print('   👤 Nom: $_recruteurName');
      print('   📷 Photo path: $photoPath');
      print('   📷 Photo URL: $_recruteurPhotoUrl');
      print('   ⭐ Note: $_recruteurRating');
    }
  } 

  // Helper pour convertir le chemin Windows en URL HTTP
  String? _convertPhotoPathToUrl(String? photoPath) {
    if (photoPath == null || photoPath.isEmpty) return null;
    
    // Si c'est déjà une URL HTTP, retourner tel quel
    if (photoPath.startsWith('http://') || photoPath.startsWith('https://')) {
      return photoPath;
    }
    
    // Si c'est un chemin local Windows avec "uploads", convertir en URL
    if (photoPath.contains('uploads')) {
      String base = ApiConfig.baseUrl;
      if (base.endsWith('/')) base = base.substring(0, base.length - 1);
      
      // Trouver l'index de "uploads" et extraire la partie après
      final uploadsIndex = photoPath.indexOf('uploads');
      if (uploadsIndex != -1) {
        // Extraire la partie après "uploads" (incluant le slash ou backslash)
        String relativePath = photoPath.substring(uploadsIndex + 'uploads'.length);
        // Normaliser les séparateurs de chemin
        relativePath = relativePath.replaceAll('\\', '/');
        // S'assurer qu'on commence par un slash
        if (!relativePath.startsWith('/')) {
          relativePath = '/$relativePath';
        }
        // Construire l'URL complète
        final url = '$base/uploads$relativePath';
        print('🖼️ Conversion chemin: $photoPath -> $url');
        return url;
      }
    }
    
    // Si le chemin commence directement par "uploads", ajouter juste l'URL de base
    if (photoPath.startsWith('uploads')) {
      String base = ApiConfig.baseUrl;
      if (base.endsWith('/')) base = base.substring(0, base.length - 1);
      String url = '$base/$photoPath';
      url = url.replaceAll('\\', '/');
      return url;
    }
    
    return null;
  }

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

  // Helper pour formater la durée
  String _formatDuree() {
    if (_missionData == null) return 'Non spécifié';
    if (_missionData!.dureJours > 0) {
      return '${_missionData!.dureJours} jour${_missionData!.dureJours > 1 ? 's' : ''}';
    } else {
      return '${_missionData!.dureHeures} heure${_missionData!.dureHeures > 1 ? 's' : ''}';
    }
  }

  // Helper pour formater la date
  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  // Helper pour formater le prix
  String _formatPrice() {
    if (_missionData?.remuneration != null) {
      final formatted = _missionData!.remuneration!.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]} ',
      );
      return '$formatted CFA';
    }
    return 'Non spécifié';
  }

  // Helper pour formater les heures
  String _formatHeures() {
    if (_missionData?.heureDebut != null && _missionData?.heureFin != null) {
      return '${_missionData!.heureDebut} - ${_missionData!.heureFin}';
    } else if (_missionData?.heureDebut != null) {
      return 'À partir de ${_missionData!.heureDebut}';
    } else if (_missionData?.heureFin != null) {
      return 'Jusqu\'à ${_missionData!.heureFin}';
    }
    return 'Horaires non spécifiés';
  }

  @override
  Widget build(BuildContext context) {
    // Gestion des états de chargement et d'erreur
    if (_isLoading) {
      return Scaffold(
        backgroundColor: bodyBackgroundColor,
        appBar: CustomHeader(
          title: 'Chargement...',
          onBack: () => Navigator.of(context).pop(),
        ),
        body: const Center(
          child: CircularProgressIndicator(color: primaryGreen),
        ),
      );
    }

    if (_hasError || _missionData == null) {
      return Scaffold(
        backgroundColor: bodyBackgroundColor,
        appBar: CustomHeader(
          title: 'Erreur',
          onBack: () => Navigator.of(context).pop(),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 64),
              const SizedBox(height: 16),
              Text(
                'Erreur de chargement',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Impossible de charger les détails de la mission',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadMissionData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                ),
                child: Text(
                  'Réessayer',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 1. Logique pour extraire les coordonnées réelles
    final LatLng missionLocation = LatLng(_missionData!.latitude, _missionData!.longitude);
      
    // Titre de mission et détection d'un titre long (affiché sur 2 lignes)
    final String missionTitle = _missionData!.titre;
    final bool isLongTitle = missionTitle.length > 24;

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
              MaterialPageRoute(
                builder: (context) => SignalerMission(
                  missionId: widget.missionId,
                  missionTitle: _missionData?.titre,
                ),
              ),
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
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: _recruteurPhotoUrl != null
                            ? NetworkImage(_recruteurPhotoUrl!)
                            : null,
                        child: _recruteurPhotoUrl == null
                            ? const Icon(Icons.person, size: 30)
                            : null,
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _recruteurName ?? 'Recruteur',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          _buildRatingStars(_recruteurRating),
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
                    _missionData!.description,
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
                  // Afficher les exigences depuis les données
                  if (_missionData!.exigence.isNotEmpty)
                    _buildRequirement(_missionData!.exigence)
                  else
                    _buildRequirement('Aucune exigence spécifique'),
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
                        icon: Icons.location_on_outlined, 
                        label: _missionData!.adresse,
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
                        label: _formatDuree(),
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
                        label: 'Au ${_formatDate(_missionData!.dateFin)}',
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MotivationScreen(
                      missionTitle: _missionData!.titre,
                      missionId: widget.missionId,
                    ),
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

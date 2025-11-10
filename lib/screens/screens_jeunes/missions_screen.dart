import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/custom_bottom_nav_bar.dart'; 
import '../../widgets/custom_header.dart';
import 'detail_missions.dart';
import 'home_jeune.dart';
import 'message_conversation.dart';
import 'mes_candidatures.dart';
import 'profil_jeune.dart';
import '../../services/mission_service.dart';
import '../../services/category_service.dart';
import '../../models/mission.dart';
import '../../models/category.dart';

// --- COULEURS ET CONSTANTES ---
const Color primaryGreen = Color(0xFF10B981); 
const Color darkGreen = Color(0xFF00C78C); 
const Color primaryBlue = Color(0xFF2563EB); 
const Color badgeOrange = Color(0xFFF59E0B); 
const Color urgentRed = Color(0xFFEF4444);
const Color lightGrey = Color(0xFFE0E0E0);
const Color darkGrey = Colors.black54;
const Color bodyBackgroundColor = Color(0xFFf6fcfc); 

class MissionsScreen extends StatefulWidget {
  const MissionsScreen({super.key});

  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen> {
  int _selectedIndex = 0; 
  int _selectedCategoryIndex = 0; 
  bool _isLoading = true;
  bool _hasError = false;
  bool _isLoadingCategories = true;
  List<Mission> _allMissions = [];
  List<Mission> _filteredMissions = [];
  List<Category> _categories = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadMissions();
  }

  // Charger les catégories depuis le backend
  Future<void> _loadCategories() async {
    try {
      setState(() {
        _isLoadingCategories = true;
      });

      print('🔄 Chargement des catégories...');
      final categories = await CategoryService.getAllCategories();
      
      setState(() {
        _categories = categories;
        _isLoadingCategories = false;
      });

      print('✅ ${categories.length} catégories chargées avec succès');

    } catch (e) {
      print('❌ Erreur lors du chargement des catégories: $e');
      setState(() {
        _isLoadingCategories = false;
      });
      // En cas d'erreur, on continue avec une liste vide
    }
  }

  // Obtenir la liste des catégories avec "Toutes" en premier
  List<String> get _categoryNames {
    final List<String> names = ['Toutes'];
    names.addAll(_categories.map((cat) => cat.nom).toList());
    return names;
  }

  // Charger les missions depuis le backend
  Future<void> _loadMissions() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      print('🔄 Chargement des missions...');
      final missions = await MissionService.getAllMissions();
      
      setState(() {
        _allMissions = missions;
        _filteredMissions = missions;
        _isLoading = false;
      });

      print('✅ ${missions.length} missions chargées avec succès');

    } catch (e) {
      print('❌ Erreur lors du chargement des missions: $e');
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  void _selectCategory(int index) {
    setState(() {
      _selectedCategoryIndex = index;
      _applyFilters();
    });
  }

  void _applyFilters() {
  List<Mission> filtered = _allMissions;

  // EXCLURE les missions urgentes de la liste normale
  final urgentMissionIds = _featuredMissions.map((m) => m.id).toSet();
  filtered = filtered.where((mission) => !urgentMissionIds.contains(mission.id)).toList();

    // Filtre par catégorie
    if (_selectedCategoryIndex > 0 && _categoryNames.isNotEmpty) {
      final selectedCategoryName = _categoryNames[_selectedCategoryIndex];
      // Filtrer par nom de catégorie (comparaison insensible à la casse)
        filtered = filtered.where((mission) => 
        mission.categorieNom.toLowerCase() == selectedCategoryName.toLowerCase() ||
        mission.categorieNom.toLowerCase().contains(selectedCategoryName.toLowerCase())
        ).toList();
    }

    // Filtre par recherche
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((mission) =>
        mission.titre.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        mission.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        mission.adresse.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        mission.categorieNom.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    setState(() {
      _filteredMissions = filtered;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFilters();
  }

  // Obtenir la date et heure de début complète d'une mission
  DateTime? _getMissionStartDateTime(Mission mission) {
    try {
      final startDate = DateTime.parse(mission.dateDebut);
      
      // Si une heure de début est spécifiée, l'ajouter à la date
      if (mission.heureDebut != null && mission.heureDebut!.isNotEmpty) {
        try {
          // Parse l'heure (format attendu: "HH:mm" ou "HH:mm:ss")
          final timeParts = mission.heureDebut!.split(':');
          if (timeParts.length >= 2) {
            final hour = int.parse(timeParts[0]);
            final minute = int.parse(timeParts[1]);
            return DateTime(
              startDate.year,
              startDate.month,
              startDate.day,
              hour,
              minute,
            );
          }
        } catch (e) {
          // Si l'heure ne peut pas être parsée, utiliser seulement la date
          return startDate;
        }
      }
      
      return startDate;
    } catch (e) {
      return null;
    }
  }

  // Obtenir les missions mises en avant (urgentes) - LOGIQUE MODIFIÉE avec filtrage par catégorie
  List<Mission> get _featuredMissions {
    final now = DateTime.now();
    
    var urgentMissions = _allMissions.where((mission) {
      final startDateTime = _getMissionStartDateTime(mission);
      if (startDateTime == null) return false;
      
      final difference = startDateTime.difference(now);
      
      // Mission urgente si elle commence dans moins de 48 heures
      return difference.inHours <= 48 && difference.inHours >= 0;
    }).toList();

    // Appliquer le filtre de catégorie si une catégorie est sélectionnée
    if (_selectedCategoryIndex > 0 && _categoryNames.isNotEmpty) {
      final selectedCategoryName = _categoryNames[_selectedCategoryIndex];
      urgentMissions = urgentMissions.where((mission) => 
        mission.categorieNom.toLowerCase() == selectedCategoryName.toLowerCase() ||
        mission.categorieNom.toLowerCase().contains(selectedCategoryName.toLowerCase())
      ).toList();
    }

    // Trier par date et heure de début la plus proche
    urgentMissions.sort((a, b) {
      final aStart = _getMissionStartDateTime(a);
      final bStart = _getMissionStartDateTime(b);
      if (aStart == null || bStart == null) return 0;
        return aStart.compareTo(bStart);
    });

    return urgentMissions.take(3).toList();
  }

  // Obtenir la couleur d'urgence selon le temps restant
 Color _getUrgencyColor(Mission mission) {
  return primaryGreen; // Vert pour le dégradé bleu-vert
}

  // Obtenir le texte d'urgence selon le temps restant avec "RESTANTE"
 String _getUrgencyText(Mission mission) {
    final startDateTime = _getMissionStartDateTime(mission);
    if (startDateTime == null) {
      return 'DATE INVALIDE';
    }
    
    final now = DateTime.now();
    final difference = startDateTime.difference(now);
    
    if (difference.isNegative) {
      return 'COMMENCÉE';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}J RESTANT${difference.inDays > 1 ? 'ES' : 'E'}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}H RESTANTE';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}MIN RESTANTE';
    } else {
      return 'MAINTENANT';
    }
}


  // Fonction pour naviguer vers la page de détail d'une mission
  void _navigateToDetail(Mission mission) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailMissionScreen(
          missionId: mission.id,
        ),
      ),
    );
  }

  // Widget pour l'indicateur de chargement
  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: primaryGreen,
          ),
          const SizedBox(height: 16),
          Text(
            'Chargement des missions...',
            style: GoogleFonts.poppins(
              color: Colors.black54,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // Widget pour l'état d'erreur
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'Erreur de chargement',
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Impossible de charger les missions',
            style: GoogleFonts.poppins(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadMissions,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor, 
      
      // 1. Barre d'Application (AppBar) - Utilisation de CustomHeader
      appBar: CustomHeader(
        title: 'Toutes les Missions',
        onBack: () => Navigator.of(context).pop(),
        bottomWidget: Container(
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: darkGrey),
              hintText: 'Recherche',
              hintStyle: GoogleFonts.poppins(color: darkGrey.withOpacity(0.7)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
          ),
        ),
      ),
      
      // 2. Corps de la Page (Scrollable)
      body: _isLoading 
          ? _buildLoadingIndicator()
          : _hasError
              ? _buildErrorState()
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      
                      const SizedBox(height: 10), 
                      
                      // 2a. Section des Filtres (Tags)
                      _isLoadingCategories
                          ? const SizedBox(
                              height: 40,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: primaryGreen,
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                                children: List.generate(_categoryNames.length, (index) {
                            final bool isSelected = index == _selectedCategoryIndex;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: _TagButton(
                                      label: _categoryNames[index],
                                color: isSelected ? primaryGreen : darkGrey,
                                onTap: () => _selectCategory(index),
                              ),
                            );
                          }),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // 2b. SECTION DES MISSIONS MISES EN AVANT (Top Missions) - MODIFIÉ
                      if (_featuredMissions.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Missions Urgentes',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: _featuredMissions.asMap().entries.map((entry) {
                                  final mission = entry.value;
                                  final urgencyColor = _getUrgencyColor(mission);
                                  final urgencyText = _getUrgencyText(mission);
                                  
                                  return Padding(
                                    padding: EdgeInsets.only(left: 0.0, right: 15.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.75, 
                                      child: GestureDetector(
                                        onTap: () => _navigateToDetail(mission),
                                        child: _TopMissionCard(
                                          title: mission.titre,
                                          price: mission.formattedPrice,
                                          timeRemaining: urgencyText,
                                          urgencyColor: urgencyColor,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      
                      // 2c. Liste des Missions
                      Text(
                        _filteredMissions.isEmpty ? 'Aucune mission trouvée' : 'Missions Disponibles',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      
                      // Liste des missions
                      Column(
                        children: _filteredMissions.map((mission) => Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: GestureDetector(
                            onTap: () => _navigateToDetail(mission),
                            child: _DefaultMissionCard(
                              mission: mission,
                              onTap: () => _navigateToDetail(mission),
                            ),
                          ),
                        )).toList(),
                      ),
                      
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
    );
  }
}

// -----------------------------------------------------------------------------
// --- WIDGETS DES COMPOSANTS ---
// -----------------------------------------------------------------------------

// Widget pour les Boutons de Filtre (Tags) - INCHANGÉ
class _TagButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _TagButton({
    required this.label, 
    required this.color, 
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color == primaryGreen ? primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color),
          boxShadow: color == primaryGreen ? [
              BoxShadow(
                color: primaryGreen.withOpacity(0.3),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ] : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: color == primaryGreen ? Colors.white : Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// Widget pour la Carte de Mission Supérieure (Gradients) - MODIFIÉ
class _TopMissionCard extends StatelessWidget {
  final String title;
  final String price;
  final String timeRemaining;
  final Color urgencyColor;

  const _TopMissionCard({
    required this.title,
    required this.price,
    required this.timeRemaining,
    required this.urgencyColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [primaryBlue, primaryGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryGreen.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  price,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis, 
                ),
              ),
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: badgeOrange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  timeRemaining,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget pour les Cartes de Mission Standard - INCHANGÉ
class _DefaultMissionCard extends StatelessWidget {
  final Mission mission;
  final VoidCallback? onTap;

  const _DefaultMissionCard({
    required this.mission,
    this.onTap,
  });

  // Helper pour construire une ligne d'information avec icône et texte
  Widget _buildInfoRow({required IconData icon, required String text, required bool isPrice, bool useExpanded = true}) {
    return Row(
      mainAxisSize: useExpanded ? MainAxisSize.max : MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: darkGrey),
        const SizedBox(width: 5),
        useExpanded
            ? Expanded(
          child: Text(
          text,
          style: GoogleFonts.poppins(
              fontSize: 13,
            color: isPrice ? primaryBlue : darkGrey,
            fontWeight: isPrice ? FontWeight.bold : FontWeight.normal,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
              )
            : Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: isPrice ? primaryBlue : darkGrey,
                  fontWeight: isPrice ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
        ),
      ],
    );
  }

 @override
Widget build(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(15.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Ligne 1 : Titre et Prix
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
              mission.titre,
              style: GoogleFonts.poppins(
                  fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              mission.formattedPrice,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: primaryBlue,
              ),
            ),
          ],
        ),
        const Divider(height: 15, thickness: 0.5, color: lightGrey),
        
        // Ligne 2 : Lieu (gauche) et Durée (droite) - alignés horizontalement
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Lieu: Icône de localisation (gauche)
            Expanded(
              child: _buildInfoRow(
                icon: Icons.location_on_outlined, 
                text: mission.adresse, 
                isPrice: false,
                useExpanded: true,
              ),
            ),
            // Durée: Icône de temps remplie (droite)
            _buildInfoRow(
                icon: Icons.access_time_filled, 
                text: mission.formattedDuree, 
              isPrice: false,
              useExpanded: false,
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Ligne 3 : Date Début (gauche) et Date Fin (droite) - alignés horizontalement
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Date Début: Icône Calendrier (gauche)
            Expanded(
              child: _buildInfoRow(
                icon: Icons.calendar_today_outlined, 
                text: 'Du ${mission.formattedDateDebut}', 
                isPrice: false,
                useExpanded: true,
              ),
            ),
            // Date Fin: Icône Calendrier (droite)
            _buildInfoRow(
                icon: Icons.calendar_today_outlined, 
                text: 'Au ${mission.formattedDateFin}', 
              isPrice: false,
              useExpanded: false,
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Ligne 4 : Heures (SEULEMENT SI DISPONIBLES) et Bouton Voir Plus - alignés horizontalement
        if (mission.hasHeures)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Heure: Icône Horloge (gauche)
              Expanded(
                child: _buildInfoRow(
                  icon: Icons.access_time, 
                  text: mission.formattedHeures, 
                  isPrice: false,
                  useExpanded: true,
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Bouton Voir Plus (droite)
              ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: 0,
                  minimumSize: const Size(90, 30),
                ),
                child: Text(
                  'Voir Plus',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        
        // Si pas d'heures, afficher seulement le bouton à droite
        if (!mission.hasHeures)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: 0,
                  minimumSize: const Size(90, 30),
                ),
                child: Text(
                  'Voir Plus',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
      ],
    ),
  );
}
}
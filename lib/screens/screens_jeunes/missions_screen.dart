import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/custom_bottom_nav_bar.dart'; 
import '../../widgets/custom_header.dart';
import 'detail_missions.dart';
import 'home_jeune.dart';
import 'message_conversation.dart';
import 'mes_candidatures.dart';
import 'profil_jeune.dart';

// --- COULEURS ET CONSTANTES ---
const Color primaryGreen = Color(0xFF10B981); 
const Color darkGreen = Color(0xFF00C78C); 
const Color primaryBlue = Color(0xFF2563EB); 
const Color badgeOrange = Color(0xFFF59E0B); 
const Color lightGrey = Color(0xFFE0E0E0);
const Color darkGrey = Colors.black54;
const Color bodyBackgroundColor = Color(0xFFf6fcfc); 

// --- DÉFINITION STATIQUE DE LA PAGE ---

class MissionsScreen extends StatefulWidget {
  const MissionsScreen({super.key});

  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen> {
  int _selectedIndex = 0; 
  int _selectedCategoryIndex = 0; 
  
  // Liste des catégories de filtres (inchangée)
  final List<String> categories = [
    'Urgent',
    'Livraison',
    'Aide Domestique',
    'Cours Particuliers',
    'Bricolage',
    'Jardinage',
    'Déménagement',
  ];
  
  // Liste des missions Mises en Avant (avec dégradé) - (inchangée)
  final List<Map<String, String>> featuredMissions = [
    {
      'title': 'LIVRAISON EXPRESS - MARCHE CENTRAL',
      'price': '5.000 CFA',
      'timeRemaining': '1H RESTANTE',
    },
    {
      'title': 'COURS DE DESSIN - ÉLÉMENTAIRE',
      'price': '4.500 CFA',
      'timeRemaining': '3 JOURS RESTANTS',
    },
    {
      'title': 'JARDINAGE COMPLET - VILLA A',
      'price': '8.000 CFA',
      'timeRemaining': '2 HEURES RESTANTES',
    },
  ];

  // ⚠️ Liste des missions standards avec les coordonnées GPS de DÉMO
  // Ces coordonnées seront utilisées pour afficher la carte.
  final List<Map<String, dynamic>> staticMissions = [
    {
      'title': 'Cours de Maths-Lycée',
      'location': 'A Garantibougou',
      'price': '3.000 CFA',
      'period': '3 heures / Jours', 
      'date_start': 'Du 10/10/2025',
      'date_end': 'Au 13/10/2025',
      'time': 'à 14H :00',
      'latitude': 12.6074, // Coordonnée démo 1
      'longitude': -7.9940,
    },
    {
      'title': 'Aide Domestique',
      'location': 'Quartier du Lac',
      'price': '2.500 CFA',
      'period': '4 heures / Jours', 
      'date_start': 'Du 15/10/2025',
      'date_end': 'Au 20/10/2025',
      'time': 'à 10H :00',
      'latitude': 12.6300, // Coordonnée démo 2
      'longitude': -8.0300,
    },
    {
      'title': 'Bricolage - Étagères',
      'location': 'Sogoniko',
      'price': '6.000 CFA',
      'period': '1 journée', 
      'date_start': 'Le 25/10/2025',
      'date_end': 'Le 25/10/2025',
      'time': 'à 09H :00',
      'latitude': 12.6450, // Coordonnée démo 3
      'longitude': -8.0050,
    },
  ];

  void _selectCategory(int index) {
    setState(() {
      _selectedCategoryIndex = index;
    });
  }

  // Fonction pour naviguer vers la page de détail d'une mission
  void _navigateToDetail(Map<String, dynamic> mission) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailMissionScreen(
          missionData: {
            'missionTitle': mission['title'],
            'description': 'Description détaillée de la mission ${mission['title']}. Cette mission nécessite une personne motivée et disponible pour accomplir les tâches demandées.',
            'location': mission['location'],
            'duration': mission['period'],
            'dateLimit': mission['date_end'],
            // 🎯 Ajout des coordonnées pour l'affichage de la carte
            'latitude': mission['latitude'],
            'longitude': mission['longitude'],
          },
        ),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            
            // La barre de recherche est désormais gérée par CustomHeader.bottomWidget
            const SizedBox(height: 10), 
            
            // 2a. Section des Filtres (Tags) - Correction du débordement
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(categories.length, (index) {
                  final bool isSelected = index == _selectedCategoryIndex;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: _TagButton(
                      label: categories[index],
                      color: isSelected ? primaryGreen : darkGrey,
                      onTap: () => _selectCategory(index),
                    ),
                  );
                }),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 2b. SECTION DES MISSIONS MISES EN AVANT (Top Missions) - (inchangée)
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: featuredMissions.asMap().entries.map((entry) {
                    final index = entry.key;
                    final mission = entry.value;
                    
                    final double leftPadding = index == 0 ? 0.0 : 0.0;
                    
                    return Padding(
                      padding: EdgeInsets.only(left: leftPadding, right: 15.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75, 
                        child: GestureDetector(
                          // ⚠️ Note: Les missions mises en avant n'ont pas de coordonnées pour l'instant.
                          // Utilisation d'un dictionnaire temporaire pour l'appel.
                          onTap: () => _navigateToDetail({
                              ...mission,
                              'latitude': 12.6392, // Coordonnée de repli pour la carte
                              'longitude': -8.0028, 
                              'period': 'Durée variable', // Ajout de la durée manquante
                              'date_end': mission['timeRemaining'], // Utilisation du temps restant comme date limite de démo
                            }),
                          child: _TopMissionCard(
                            title: mission['title']!,
                            price: mission['price']!,
                            timeRemaining: mission['timeRemaining']!,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            
            // 2c. Le reste du contenu (missions standards)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Liste des Missions Inférieures (Liste des Cartes)
                ...staticMissions.map((mission) => Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: GestureDetector(
                    onTap: () => _navigateToDetail(mission),
                    child: _DefaultMissionCard(
                      title: mission['title']! as String, 
                      location: mission['location']! as String, 
                      price: mission['price']! as String,
                      period: mission['period']! as String, 
                      dateStart: mission['date_start']! as String, 
                      dateEnd: mission['date_end']! as String,
                      time: mission['time']! as String,
                      onTap: () => _navigateToDetail(mission),
                    ),
                  ),
                )).toList(),
                
                const SizedBox(height: 100),
              ],
            ),
          ],
        ),
      ),
      
    );
  }
}

// -----------------------------------------------------------------------------
// --- WIDGETS DES COMPOSANTS ---
// -----------------------------------------------------------------------------

// Widget pour les Boutons de Filtre (Tags) - (inchangé)
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

// Widget pour la Carte de Mission Supérieure (Gradients) - (inchangée)
class _TopMissionCard extends StatelessWidget {
  final String title;
  final String price;
  final String timeRemaining;

  const _TopMissionCard({required this.title, required this.price, required this.timeRemaining});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [primaryBlue, darkGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withOpacity(0.4),
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

// Widget pour les Cartes de Mission Standard (Fonds Blanc)
class _DefaultMissionCard extends StatelessWidget {
  final String title;
  final String location;
  final String price;
  final String period; // Durée par jour
  final String dateStart;
  final String dateEnd;
  final String time;
  final VoidCallback? onTap;

  const _DefaultMissionCard({
    required this.title,
    required this.location,
    required this.price,
    required this.period,
    required this.dateStart,
    required this.dateEnd,
    required this.time,
    this.onTap,
  });

  // Helper pour construire une ligne d'information avec icône et texte
  Widget _buildInfoRow({required IconData icon, required String text, required bool isPrice}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: darkGrey),
        const SizedBox(width: 5),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: isPrice ? primaryBlue : darkGrey,
            fontWeight: isPrice ? FontWeight.bold : FontWeight.normal,
          ),
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
          // Ligne 1 : Titre et Prix (inchangée)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                price,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: primaryBlue,
                ),
              ),
            ],
          ),
          const Divider(height: 15, thickness: 0.5, color: lightGrey),
          
          // ⚠️ NOUVELLE STRUCTURE D'INFORMATIONS :
          
          // Ligne 2 : Lieu et Durée par jour
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Lieu: Icône de localisation
              Expanded(
                child: _buildInfoRow(icon: Icons.location_on_outlined, text: location, isPrice: false),
              ),
              // Durée par jour: Icône de temps remplie
              Expanded(
                child: _buildInfoRow(icon: Icons.access_time_filled, text: period, isPrice: false),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Ligne 3 : Date Début et Date Fin
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Date Début: Icône Calendrier
              Expanded(
                child: _buildInfoRow(icon: Icons.calendar_today_outlined, text: dateStart, isPrice: false),
              ),
              // Date Fin: Icône Calendrier
              Expanded(
                child: _buildInfoRow(icon: Icons.calendar_today_outlined, text: dateEnd, isPrice: false),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Ligne 4 : Heure et Bouton Voir Plus
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Heure: Icône Horloge (Expanded pour éviter le débordement)
              Expanded(
                child: _buildInfoRow(icon: Icons.access_time, text: time, isPrice: false),
              ),
              
              SizedBox(
                height: 30, 
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    elevation: 0,
                  ),
                  child: Text(
                    'Voir Plus',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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

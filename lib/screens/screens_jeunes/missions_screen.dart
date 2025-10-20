import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// ⚠️ Assurez-vous que ce chemin d'importation est correct.
import '../../widgets/custom_bottom_nav_bar.dart'; 

// --- COULEURS ET CONSTANTES ---
const Color primaryGreen = Color(0xFF10B981); 
const Color darkGreen = Color(0xFF00C78C); 
const Color primaryBlue = Color(0xFF2563EB); 
const Color badgeOrange = Color(0xFFF59E0B); 
const Color lightGrey = Color(0xFFE0E0E0);
const Color darkGrey = Colors.black54;
const Color bodyBackgroundColor = Color(0xFFF5F5F5); 

// --- DÉFINITION STATIQUE DE LA PAGE ---

class MissionsScreen extends StatefulWidget {
  const MissionsScreen({super.key});

  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen> {
  int _selectedIndex = 0; 
  // Index de la catégorie de filtre actuellement sélectionnée
  int _selectedCategoryIndex = 0; 
  
  // Liste des catégories de filtres
  final List<String> categories = [
    'Urgent',
    'Livraison',
    'Aide Domestique',
    'Cours Particuliers',
    'Bricolage',
    'Jardinage',
    'Déménagement',
  ];
  
  // Liste des missions Mises en Avant (avec dégradé)
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

  // Liste des missions standards
  final List<Map<String, String>> staticMissions = [
    {
      'title': 'Cours de Maths-Lycée',
      'location': 'A Garantibougou',
      'price': '3.000 CFA',
      'period': '3 heures / Jours',
      'date_start': 'Du 10/10/2025',
      'date_end': 'Au 13/10/2025',
      'time': 'à 14H :00',
    },
    {
      'title': 'Cours de Maths-Lycée',
      'location': 'A Garantibougou',
      'price': '3.000 CFA',
      'period': 'Du 10/10/2025',
      'date_start': 'Du 10/10/2025',
      'date_end': 'Au 13/10/2025',
      'time': 'à 14H :00',
    },
    {
      'title': 'Cours de Maths-Lycée',
      'location': 'A Garantibougou',
      'price': '3.000 CFA',
      'period': 'Du 10/10/2025',
      'date_start': 'Du 10/10/2025',
      'date_end': 'Au 13/10/2025',
      'time': 'à 14H :00',
    },
  ];

  void _selectCategory(int index) {
    setState(() {
      _selectedCategoryIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor, 
      
      // 1. Barre d'Application (AppBar)
      appBar: AppBar(
        automaticallyImplyLeading: false, 
        backgroundColor: primaryBlue,
        toolbarHeight: 70, 
        
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(35), 
            bottomRight: Radius.circular(35),
          ),
        ),
        
        // Contenu de la zone supérieure de l'AppBar
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            children: [
              const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text(
                'Toutes les Missions',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        
        // Barre de recherche (bottom)
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0), 
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: lightGrey),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Recherche',
                  hintStyle: TextStyle(color: Colors.black54),
                  prefixIcon: Icon(Icons.search, color: darkGrey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                ),
              ),
            ),
          ),
        ),
      ),
      
      // 2. Corps de la Page (Scrollable)
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            
            const SizedBox(height: 20), 
            
            // 2a. Section des Filtres (Tags) - Défilement Horizontal
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 20.0),
              child: SingleChildScrollView(
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
            ),
            
            // 2b. SECTION DES MISSIONS MISES EN AVANT (Top Missions) - Défilement Horizontal
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: featuredMissions.asMap().entries.map((entry) {
                    final index = entry.key;
                    final mission = entry.value;
                    
                    // Padding à gauche pour la première carte
                    final double leftPadding = index == 0 ? 20.0 : 0.0;
                    
                    return Padding(
                      padding: EdgeInsets.only(left: leftPadding, right: 15.0),
                      child: SizedBox(
                        // La carte occupe 75% de la largeur de l'écran
                        width: MediaQuery.of(context).size.width * 0.75, 
                        child: _TopMissionCard(
                          title: mission['title']!,
                          price: mission['price']!,
                          timeRemaining: mission['timeRemaining']!,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            
            // 2c. Le reste du contenu (missions standards)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Text(
                    'Missions Similaires',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  
                  const SizedBox(height: 15),
                  
                  // Liste des Missions Inférieures (Liste des Cartes)
                  ...staticMissions.map((mission) => Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: _DefaultMissionCard(
                      title: mission['title']!, location: mission['location']!, price: mission['price']!,
                      period: mission['period']!, dateStart: mission['date_start']!, dateEnd: mission['date_end']!,
                      time: mission['time']!,
                    ),
                  )).toList(),
                  
                  const SizedBox(height: 100), 
                ],
              ),
            ),
          ],
        ),
      ),
      
      // 3. Barre de Navigation Personnalisée (BottomNavBar)
      bottomNavigationBar: CustomBottomNavBar(
        initialIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// --- WIDGETS DES COMPOSANTS ---
// -----------------------------------------------------------------------------

// Widget pour les Boutons de Filtre (Tags)
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

// Widget pour la Carte de Mission Supérieure (Gradients)
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
          
          // LIGNE CORRIGÉE CONTRE LE DÉBORDEMENT
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Utilisation d'Expanded pour s'assurer que le prix ne déborde pas
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
              
              // Badge de Temps Restant (fixe)
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
  final String period;
  final String dateStart;
  final String dateEnd;
  final String time;

  const _DefaultMissionCard({
    required this.title,
    required this.location,
    required this.price,
    required this.period,
    required this.dateStart,
    required this.dateEnd,
    required this.time,
  });

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
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoRow(icon: Icons.person_outline, text: location, isPrice: false),
              _buildInfoRow(icon: Icons.access_time_filled, text: period, isPrice: false),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoRow(icon: Icons.location_on_outlined, text: dateStart, isPrice: false),
              _buildInfoRow(icon: Icons.calendar_today_outlined, text: dateEnd, isPrice: false),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Correction de débordement pour les cartes standards
              Expanded(
                child: _buildInfoRow(icon: Icons.access_time, text: time, isPrice: false),
              ),
              
              SizedBox(
                height: 30, 
                child: ElevatedButton(
                  onPressed: () {},
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
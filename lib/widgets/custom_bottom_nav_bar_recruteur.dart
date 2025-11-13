import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/message_service.dart';

// Définition de la couleur verte pour les icônes sélectionnées
const Color selectedIconColor = Color(0xFF27AE60); 
const Color lightGreenBackground = Color(0xFFE8F5E9); // Vert très clair pour l'arrière-plan
const Color messageBadgeColor = Color(0xFFE11D48); // Rouge pour les messages non lus

// --- 1. CLASSE PRINCIPALE ---
class CustomBottomNavBarRecruteur extends StatefulWidget {
  final int initialIndex; 
  final Function(int) onItemSelected; 
  final int? unreadMessagesCount;

  const CustomBottomNavBarRecruteur({
    super.key,
    this.initialIndex = 0, 
    required this.onItemSelected,
    this.unreadMessagesCount,
  });

  @override
  State<CustomBottomNavBarRecruteur> createState() => _CustomBottomNavBarRecruteurState();
}

// --- 2. GESTION DE L'ÉTAT ET DE LA LOGIQUE ---
class _CustomBottomNavBarRecruteurState extends State<CustomBottomNavBarRecruteur> {
  late int _selectedIndex;
  int _badgeCount = 0;
  bool _isFetchingBadge = false;

  final List<Map<String, dynamic>> navItems = [
    {'icon': Icons.home, 'label': 'Accueil'}, 
    {'icon': Icons.assignment_outlined, 'label': 'Missions'},
    {'icon': Icons.person_outline, 'label': 'Profil'},
    {'icon': Icons.chat_bubble_outline, 'label': 'Discussions'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    if (widget.unreadMessagesCount != null) {
      _badgeCount = _normalizeCount(widget.unreadMessagesCount!);
    } else {
      _loadUnreadMessages();
    }
  }

  @override
  void didUpdateWidget(covariant CustomBottomNavBarRecruteur oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.unreadMessagesCount != null) {
      if (widget.unreadMessagesCount != oldWidget.unreadMessagesCount) {
        setState(() {
          _badgeCount = _normalizeCount(widget.unreadMessagesCount!);
        });
      }
    } else if (oldWidget.unreadMessagesCount != null) {
      _loadUnreadMessages();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onItemSelected(index); 
  }

  Future<void> _loadUnreadMessages() async {
    if (_isFetchingBadge) return;
    _isFetchingBadge = true;
    try {
      final total = await MessageService.getTotalUnreadMessagesCount();
      if (!mounted) return;
      setState(() {
        _badgeCount = _normalizeCount(total);
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _badgeCount = 0;
      });
    } finally {
      _isFetchingBadge = false;
    }
  }

  int _normalizeCount(int value) {
    if (value <= 0) return 0;
    if (value > 9999) return 9999;
    return value;
  }
  
  // Crée l'élément avec label OU un espace vide si sélectionné
  Widget _buildItemWithLabelOrEmptySpace(int index) {
    final item = navItems[index];
    final isSelected = _selectedIndex == index;
    // COULEUR POUR LES ICÔNES ET TEXTES NON SÉLECTIONNÉS (MODIFIÉ)
    final Color defaultColor = Colors.black;
    final bool isDiscussionIcon = index == 3;
    final bool showBadge = _badgeCount > 0 && isDiscussionIcon;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        child: isSelected 
            ? const SizedBox.shrink() // Espace vide à la place de l'item sélectionné
            : SizedBox(
                height: 70, // Hauteur de l'item (non modifiée, s'intègre au nouveau fond)
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Icône (couleur modifiée en noir)
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(item['icon'], color: defaultColor, size: 24),
                        if (showBadge)
                          Positioned(
                            top: -6,
                            right: -6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: messageBadgeColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white, width: 1.2),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                _badgeCount > 99
                                    ? '99+'
                                    : _badgeCount.toString(),
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ), 
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        item['label'],
                        style: TextStyle(
                          fontSize: 12,
                          // Poids de la police modifié
                          fontWeight: FontWeight.bold, 
                          // Couleur du texte modifiée en noir
                          color: defaultColor, 
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  // Crée le widget flottant (icône verte dans cercle blanc)
  Widget _buildActiveFloatingItem(double targetPositionX) {
    final double itemSize = 60; // Taille du cercle blanc flottant
    final double leftOffset = targetPositionX - (itemSize / 2);

    return Positioned(
      left: leftOffset,
      bottom: 25, // Positionne l'élément à la bonne hauteur (au-dessus de la courbe)
      child: IgnorePointer( // Ignore les taps sur le cercle pour ne pas bloquer l'écran
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: itemSize, 
              height: itemSize,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: selectedIconColor.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 45, // Taille du cercle vert clair
                  height: 45,
                  decoration: BoxDecoration(
                    color: lightGreenBackground.withOpacity(0.8), 
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      navItems[_selectedIndex]['icon'], 
                      color: selectedIconColor,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
            if (_selectedIndex == 3 && _badgeCount > 0)
              Positioned(
                top: -6,
                right: -6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: messageBadgeColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 1.2),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    _badgeCount > 99
                        ? '99+'
                        : _badgeCount.toString(),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth / navItems.length;
    final targetPositionX = itemWidth * _selectedIndex + (itemWidth / 2);

    return SafeArea(
      top: false,
      child: Container(
        // HAUTEUR PRINCIPALE AUGMENTÉE (MODIFIÉ)
        height: 120, // Augmenté de 110 à 120
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // 1. Fond blanc de la Barre de Navigation (avec la découpe par CustomPainter)
            Container(
              // HAUTEUR DU FOND BLANC AUGMENTÉE (MODIFIÉ)
              height: 100, // Augmenté de 90 à 100
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
        
              ),
              child: CustomPaint(
                // TAILLE DU PAINTER AUGMENTÉE (MODIFIÉ)
                size: const Size.fromHeight(100), // Augmenté de 90 à 100
              painter: NavBarPainter(
                selectedIndex: _selectedIndex,
                itemWidth: itemWidth,
                backgroundColor: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(navItems.length, (index) => _buildItemWithLabelOrEmptySpace(index)),
              ),
            ),
          ),
          
          // 2. Icône sélectionnée flottante
          _buildActiveFloatingItem(targetPositionX),
        ],
      ),
      ),
    );
  }
}

// --- 3. CUSTOM PAINTER POUR LA FORME DE VAGUE ---
class NavBarPainter extends CustomPainter {
  final int selectedIndex;
  final double itemWidth;
  final Color backgroundColor;

  NavBarPainter({
    required this.selectedIndex,
    required this.itemWidth,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    
    // Décalage X du centre de l'élément sélectionné
    final double centerOffset = (selectedIndex * itemWidth) + (itemWidth / 2);

    // Taille de la courbe (largeur et profondeur)
    final double notchRadius = itemWidth * 0.45; // Largeur de la découpe

    final Paint paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final Path path = Path();
    
    // 1. Point de départ: Coin supérieur gauche
    path.moveTo(0, 20); // Commence après l'arrondi (20px)

    // 2. Ligne horizontale jusqu'au début de la courbe
    path.lineTo(centerOffset - notchRadius, 20);

    // 3. La courbe (vague) : Simule la forme du notch
    // Courbe de Bézier pour créer l'effet de vague douce
    path.cubicTo(
      centerOffset - notchRadius + 10, 5,   // Contrôle 1 (tiré vers le haut et l'intérieur)
      centerOffset - 10, 0,                 // Contrôle 2 (le point le plus haut de la courbe)
      centerOffset, 0,                      // Point d'inflexion (milieu, sur l'axe X)
    );
    
    // Suite de la courbe après le centre
    path.cubicTo(
      centerOffset + 10, 0,                 // Contrôle 3 (symétrique)
      centerOffset + notchRadius - 10, 5,   // Contrôle 4 (symétrique)
      centerOffset + notchRadius, 20,       // Fin de la vague, rejoignant la ligne droite
    );

    // 4. Ligne horizontale jusqu'au coin supérieur droit
    path.lineTo(w, 20);

    // 5. Bas de la barre (complète la forme)
    path.lineTo(w, h);
    path.lineTo(0, h);
    path.lineTo(0, 20);
    
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant NavBarPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex || oldDelegate.itemWidth != itemWidth;
  }
}
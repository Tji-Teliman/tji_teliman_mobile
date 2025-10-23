import 'package:flutter/material.dart';
import 'package:tji_teliman_mobile/widgets/profil/customAppBar.dart';
import 'package:tji_teliman_mobile/widgets/profil/idCardUploadSection.dart';
import 'package:tji_teliman_mobile/widgets/profil/profilePictureSection.dart';
import 'package:tji_teliman_mobile/widgets/custom_header.dart'; 



// --- COULEURS ET STYLES ---
const Color primaryGreen = Color(0xFF10B981); 
const Color primaryBlue = Color(0xFF2563EB);
const Color backgroundLight = Color(0xFFF8F8F8); 
const Color greyText = Color(0xFF888888); 
const Color lightGreyBorder = Color(0xFFE0E0E0);

// 1. CONVERSION en StatefulWidget
class ProfilCompletionScreen extends StatefulWidget {
  const ProfilCompletionScreen({super.key});

  @override
  State<ProfilCompletionScreen> createState() => _ProfilCompletionScreenState();
}

class _ProfilCompletionScreenState extends State<ProfilCompletionScreen> {
  // 2. Déclaration des contrôleurs de texte pour gérer les données
  final TextEditingController nameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController(); 
  // Ajoutez d'autres contrôleurs si vous avez plus de champs
  
  // 3. Implémentation de dispose() pour libérer les ressources
  @override
  void dispose() {
    nameController.dispose();
    firstNameController.dispose();
    dateOfBirthController.dispose();
    // Pensez à disposer tous les autres contrôleurs ici
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Crée la section d'entrées en passant les contrôleurs
    final inputFields = InputFieldsSection(
      dateOfBirthController: dateOfBirthController,
      nameController: nameController,
      firstNameController: firstNameController,
    );
    
    return Scaffold(
      backgroundColor: backgroundLight,
      body: CustomScrollView(
        slivers: [
          const CustomAppBar(),
          // 1. UTILISATION DU NOUVEAU WIDGET CustomHeader ENVELOPPÉ DANS SliverAppBar
          SliverAppBar(
            // La propriété 'pinned: true' permet au header de rester visible lors du défilement
            pinned: true, 
            // La propriété 'toolbarHeight' doit correspondre à la taille préférée du CustomHeader
            toolbarHeight: 0, 
            automaticallyImplyLeading: false,
            // FlexibleSpace est utilisé pour insérer un widget qui prend de la place dans le Sliver
            flexibleSpace: CustomHeader(
              title: 'Finaliser Mon Profil',
              // Définit la fonction de retour (qui pop la page)
              onBack: () => Navigator.of(context).pop(), 
              // Vous pouvez ajouter une icône à droite si besoin
              // rightIcon: Icons.notifications_none,
            ),
            // Définir la hauteur maximale/minimale pour SliverAppBar. 
            // Nous utilisons PreferredSize du CustomHeader
            expandedHeight: const CustomHeader(title: '').preferredSize.height,
          ), 
           
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // PROGRESSION
                  const ProgressMessage(),
                  const SizedBox(height: 30),
                  // PHOTO DE PROFIL
                  const profilePictureSection(),
                  const SizedBox(height: 30),
                  // CHAMPS DE SAISIE (avec Focus Animé et Date Picker)
                  inputFields, 
                  const SizedBox(height: 30),
                  // UPLOAD ID
                  const idCardUploadSection(),
                  const SizedBox(height: 40),
                  // BOUTON SAUVEGARDER
                  const saveButton(),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

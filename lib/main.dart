import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tji_teliman_mobile/screens/screens_jeunes/signaler_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/screens_jeunes/missions_screen.dart';
import 'screens/screens_jeunes/home_jeune.dart';
import 'package:tji_teliman_mobile/screens/screens_jeunes/profil_completion_screen.dart';
import 'package:tji_teliman_mobile/screens/screens_jeunes/signaler_screen.dart';

Future<void> main() async {
  // Assure que les widgets sont initialisés
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialisation du formatage des dates en français
  await initializeDateFormatting('fr', null); 
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tji Teliman',
      theme: ThemeData(
        // Un thème simple pour le démarrage
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      // L'écran de démarrage est défini ici
      home: const SignalerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

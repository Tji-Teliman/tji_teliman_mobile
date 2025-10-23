// Fichier : custom_animated_input_field.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 

const Color primaryBlue = Color(0xFF2563EB);
const Color primaryGreen = Color(0xFF4CAF50);
const Color lightGreyBorder = Color(0xFFEEEEEE);
const Color greyText = Color(0xFF888888); 


class CustomAnimatedInputField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final bool isDateField; // Indique si c'est un champ de date
  final TextEditingController controller;

  const CustomAnimatedInputField({
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.isDateField = false,
    super.key,
  });

  @override
  State<CustomAnimatedInputField> createState() => _CustomAnimatedInputFieldState();
}

class _CustomAnimatedInputFieldState extends State<CustomAnimatedInputField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    // Annule le focus si c'est un champ de date après avoir sélectionné
    if (widget.isDateField && _focusNode.hasFocus) {
        // La gestion du focus est déjà dans _selectDate, mais on s'assure de l'état
    }
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }
  
  
  // Fonction pour afficher le calendrier
  Future<void> _selectDate(BuildContext context) async {
    // Si c'est un champ de date, on enlève le focus pour masquer le clavier
    _focusNode.unfocus(); 
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryGreen, 
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // Met à jour le contrôleur pour afficher la date formatée
        widget.controller.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Définition de la bordure (Gris par défaut, Transparent si Focus pour laisser l'AnimatedContainer agir)
    final Color borderColor = _isFocused ? Colors.transparent : lightGreyBorder;
    const double borderWidth = 2.0; 

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      //AnimatedContainer pour l'effet de Survol/Focus
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // Affichage de l'ombre/surbrillance lors du focus
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    // Utiliser primaryBlue comme couleur principale pour l'effet d'ombre
                    color: primaryBlue.withOpacity(0.4), 
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : null,
          // Bordure unie si pas en focus
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
          color: Colors.white,
        ),
        
        // Le champ de saisie réel
        child: TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          // Si c'est un champ de date, on l'empêche de s'ouvrir avec le clavier
          readOnly: widget.isDateField, 
          // Si c'est un champ de date, on ouvre le sélecteur au tap
          onTap: widget.isDateField ? () => _selectDate(context) : null,
          
          decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: widget.hintText,
            
            //  Icône et action pour le champ de date
            suffixIcon: widget.isDateField
                ? IconButton(
                    icon: const Icon(Icons.calendar_today, color: primaryGreen),
                    // Ouvre le calendrier au clic sur l'icône
                    onPressed: () => _selectDate(context), 
                  )
                : null,
            
            // Les bordures internes du TextFormField sont toutes transparentes
            // pour laisser l'AnimatedContainer gérer l'apparence.
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.transparent, width: 0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.transparent, width: 0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.transparent, width: 0),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ),
    );
  }
}
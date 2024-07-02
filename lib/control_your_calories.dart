import 'package:flutter/material.dart';

class ControlYourCaloriesPage extends StatelessWidget {
  const ControlYourCaloriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Controla tus calorías'),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
        backgroundColor: Colors.deepPurple,
      ),
      // Agrega el contenido de la página aquí
    );
  }
}

import 'package:flutter/material.dart';

class FoodRegistryPage extends StatelessWidget {
  const FoodRegistryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de alimentación'),
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

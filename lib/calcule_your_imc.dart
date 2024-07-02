import 'package:flutter/material.dart';

class CalculeYourIMCPage extends StatelessWidget {
  const CalculeYourIMCPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calcula tu IMC'),
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
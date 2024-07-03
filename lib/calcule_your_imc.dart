import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database_helper.dart';

class CalculeYourIMCPage extends StatefulWidget {
  const CalculeYourIMCPage({super.key});

  @override
  _CalculeYourIMCPageState createState() => _CalculeYourIMCPageState();
}

class _CalculeYourIMCPageState extends State<CalculeYourIMCPage> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  List<String> imcRecords = [];

  String calculateHealthStatus(double imc) {
    if (imc < 18.5) {
      return 'Bajo peso';
    } else if (imc >= 18.5 && imc < 24.9) {
      return 'Normal';
    } else if (imc >= 25 && imc < 29.9) {
      return 'Sobrepeso';
    } else {
      return 'Obesidad';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calcula tu IMC'),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'Peso (kg)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu peso';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(
                  labelText: 'Altura (cm)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu altura';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    int userId = prefs.getInt('userId') ?? 0;
                    final weight = double.parse(_weightController.text);
                    final height = double.parse(_heightController.text) / 100;
                    final imc = weight / (height * height);
                    final healthStatus = calculateHealthStatus(imc);
                    final currentDate = DateTime.now();
                    final imcParsed = imc.toStringAsFixed(2);
                    // Guardar el IMC en la base de datos
                    await DatabaseHelper().insertIMC(userId, {
                      'imc': imc,
                      'weight': weight,
                      'height': height,
                      'date': currentDate.toString().split(' ')[0],
                    });
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Tu IMC es: $imcParsed \n '
                              'tu estado de salud es: $healthStatus '),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('Calcular'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

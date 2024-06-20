import 'package:flutter/material.dart';

import 'physical_activity_page.dart';
import 'sleep_control_page.dart';
import 'stress_management_page.dart';
import 'food_registry_page.dart';
import 'login_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Stack(
        children: [
          Center(
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 4.0,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              padding: const EdgeInsets.all(20),
              children: <Widget>[
                SizedBox(
                  height: 50, // Ajusta el valor según sea necesario
                  width: 50, // Ajusta el valor según sea necesario
                  child: ElevatedButton(
                    child: const Text('Seguimiento de actividad física'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PhysicalActivityPage()),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 50, // Ajusta el valor según sea necesario
                  width: 50, // Ajusta el valor según sea necesario
                  child: ElevatedButton(
                    child: const Text('Registro de alimentación'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FoodRegistryPage()),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 50, // Ajusta el valor según sea necesario
                  width: 50, // Ajusta el valor según sea necesario
                  child: ElevatedButton(
                    child: const Text('Control del sueño'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SleepControlPage()),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 50, // Ajusta el valor según sea necesario
                  width: 50, // Ajusta el valor según sea necesario
                  child: ElevatedButton(
                    child: const Text('Gestión del estrés'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const StressManagementPage()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 30,
            bottom: 10,
            child: ElevatedButton(
              child: const Text('Logout'),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
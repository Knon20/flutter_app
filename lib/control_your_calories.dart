import 'package:flutter/material.dart';
import 'database_helper.dart';

class ControlYourCaloriesPage extends StatefulWidget {
  const ControlYourCaloriesPage({super.key});

  @override
  _ControlYourCaloriesPageState createState() => _ControlYourCaloriesPageState();
}

class _ControlYourCaloriesPageState extends State<ControlYourCaloriesPage> {
  final dbHelper = DatabaseHelper();
  Map<String, int> activityCaloriesPerMinute = {
    'Correr': 8,
    'Nadar': 10,
    'Caminar': 4,
    'Ciclismo': 6,
    'Saltar cuerda': 12,
  };

  int? totalCaloriesBurnedGlobal;
  int? totalCaloriesConsumedGlobal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controla tus calorías'),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          FutureBuilder<List<Map<String, dynamic>>>(
            future: dbHelper.getAllPhysicalActivities(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                int totalCaloriesBurned = 0;
                for (var physicalActivity in snapshot.data!) {
                  int caloriesPerMinute = activityCaloriesPerMinute[physicalActivity['activity']] ?? 0;
                  int duration = physicalActivity['duration'] as int? ?? 0;
                  totalCaloriesBurned += caloriesPerMinute * duration;
                }
                  totalCaloriesBurnedGlobal = totalCaloriesBurned;
                return Center(
                  child: Text(
                    'Total de calorías quemadas: $totalCaloriesBurned',
                    style: const TextStyle(fontSize: 24),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: dbHelper.getAllFoodRegistries(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Crear una lista para almacenar todas las Futures
                List<Future<int?>> foodCaloriesFutures = [];
                for (var foodRegistry in snapshot.data!) {
                  int foodId = foodRegistry['food_id'] as int? ?? 0;
                  // Añadir cada Future a la lista
                  foodCaloriesFutures.add(dbHelper.getFoodCalories(foodId));
                }
                // Esperar a que todas las Futures se completen
                return FutureBuilder(
                  future: Future.wait(foodCaloriesFutures),
                  builder: (context, AsyncSnapshot<List<int?>> snapshot) {
                    if (snapshot.hasData) {
                      int totalCaloriesConsumed = 0;
                      for (var foodCalories in snapshot.data!) {
                        totalCaloriesConsumed += foodCalories ?? 0;
                      }
                      totalCaloriesConsumedGlobal = totalCaloriesConsumed;
                      return Column(
                        children: [
                          Center(
                            child: Text(
                              'Total de calorías consumidas: $totalCaloriesConsumed',
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        if (totalCaloriesBurnedGlobal != null)
                          Center(
                            child: Text(
                              'Calorias restantes: ${totalCaloriesConsumedGlobal! - totalCaloriesBurnedGlobal!}',
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}
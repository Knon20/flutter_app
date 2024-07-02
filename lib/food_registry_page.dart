import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database_helper.dart';

class FoodRegistryPage extends StatefulWidget {
  const FoodRegistryPage({super.key});

  @override
  _FoodRegistryPageState createState() => _FoodRegistryPageState();
}

class _FoodRegistryPageState extends State<FoodRegistryPage> {
  final _formKey = GlobalKey<FormState>();
  final dbHelper = DatabaseHelper();

  final List<String> _meals = ['Desayuno', 'Onces Mañana', 'Almuerzo', 'Onces Tarde', 'Cena'];
  List<Map<String, dynamic>> _foods = [];
  int? _selectedFood;
  String? _selectedMeal;

  @override
  void initState() {
    super.initState();
    _loadFoods();
  }

  Map<int, String> _foodNames = {};

  Future<void> _loadFoods() async {
    List<Map<String, dynamic>> foods = await dbHelper.getAllFoods();
    setState(() {
      _foods = foods;
      _foodNames = {for (var food in foods) food['id']: food['name']};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de alimentos'),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbHelper.getAllFoodRegistries(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index]['meal']),
                  subtitle: Text(
                      'Fecha: ${snapshot.data![index]['date']}\nAlimento: '
                          '${_foodNames[snapshot.data![index]['food_id']]}'),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Agregar registro de alimento'),
                content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      DropdownButtonFormField<String>(
                        value: _selectedMeal,
                        items: _meals.map((meal) {
                          return DropdownMenuItem(
                            value: meal,
                            child: Text(meal),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedMeal = value;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Comida',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor seleccione una comida';
                          }
                          return null;
                        },
                      ),
                      DropdownButtonFormField<int>(
                        value: _selectedFood,
                        items: _foods.map((food) {
                          return DropdownMenuItem<int>(
                            value: food['id'] as int,
                            child: Text(food['name']),
                          );
                        }).toList(),
                        onChanged: (int? value) {
                          setState(() {
                            _selectedFood = value;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Alimento',
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Por favor seleccione un alimento';
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
                            int foodId = prefs.getInt('foodId') ?? 0;
                            await DatabaseHelper().insertFoodRegistry(userId,foodId,
                              {
                                'meal': _selectedMeal,
                                'food_id': _selectedFood,
                                'date': DateTime.now().toString().split(' ')[0],
                              });
                            if(mounted){
                              Navigator.pop(context);
                              setState(() {});
                            }
                          }
                        },
                        child: const Text('Guardar'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database_helper.dart';

class PhysicalActivityPage extends StatefulWidget {
  const PhysicalActivityPage({super.key});

  @override
  _PhysicalActivityPageState createState() => _PhysicalActivityPageState();
}

class _PhysicalActivityPageState extends State<PhysicalActivityPage> {
  final _formKey = GlobalKey<FormState>();
  final _durationController = TextEditingController();
  final dbHelper = DatabaseHelper();

  final List<String> _activityTypes = ['Correr', 'Nadar', 'Caminar', 'Ciclismo', 'Saltar cuerda'];
  final _dateController = TextEditingController(
    text: DateTime.now().toString().split(' ')[0], // Esto dará la fecha en formato 'YYYY-MM-DD'
  );

  String? _selectedActivity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seguimiento de actividad física'),
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbHelper.getAllPhysicalActivities(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index]['activity']),
                  subtitle: Text(
                      'Duración: ${snapshot.data![index]['duration']} minutos\nFecha: ${snapshot.data![index]['date']}'),
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
                  content: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        DropdownButtonFormField<String>(
                          value: _selectedActivity,
                          items: _activityTypes.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            labelText: 'Tipo de actividad',
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedActivity = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor seleccione el tipo de actividad';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _durationController,
                          decoration: const InputDecoration(
                            labelText: 'Duración (en minutos)',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese la duración';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _dateController,
                          decoration: const InputDecoration(
                            labelText: 'Fecha (YYYY-MM-DD)',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese la fecha';
                            }
                            return null;
                          },
                          onTap: () async {
                            FocusScope.of(context).requestFocus(new FocusNode()); // to remove the keyboard if shown
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              _dateController.text = pickedDate.toString().split(' ')[0];
                            }
                          },
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              int userId = prefs.getInt('userId') ?? 0;
                              await DatabaseHelper().insertPhysicalActivity(userId, {
                                'activity': _selectedActivity,
                                'duration': int.parse(_durationController.text),
                                'date': _dateController.text,
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
              });
        },
      ),
    );
  }
}

import 'package:abraham_flutter_app/increment_and_decrement.dart';
import 'package:flutter/material.dart';
import 'my_home_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50], // Cambia el color de fondo
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true, // Centra el texto en la barra de título
        backgroundColor:
          Colors.deepPurple, // Cambia el color de la barra de título
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment
              .center, // Centra los elementos en el eje principal
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border:
                    OutlineInputBorder(), // Agrega un borde alrededor del campo de texto
                filled: true, // Rellena el campo de texto con un color
                fillColor: Colors.white, // El color de relleno es blanco
              ),
            ),
            const SizedBox(
                height: 20), // Agrega un espacio entre los campos de texto
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border:
                    OutlineInputBorder(), // Agrega un borde alrededor del campo de texto
                filled: true, // Rellena el campo de texto con un color
                fillColor: Colors.white, // El color de relleno es blanco
              ),
              obscureText: true,
            ),
            const SizedBox(
                height:
                    20), // Agrega un espacio entre el campo de texto y el botón
            ElevatedButton(
              child: const Text('Login'),
              onPressed: () {
                final username = _usernameController.text;
                final password = _passwordController.text;

                // Simulate a login process
                if (username == 'admin' && password == 'admin') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const MyHomePage(title: 'Poli-Fitness')),
                  );
                } else {
                  // Show error message
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Invalid username or password'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

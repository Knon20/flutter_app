// import 'package:flutter/material.dart';
// import 'database_helper.dart';
//
// class RegisterPage extends StatelessWidget {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   RegisterPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blueGrey[50],
//       appBar: AppBar(
//         title: const Text('Register'),
//         centerTitle: true,
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             TextField(
//               controller: _usernameController,
//               decoration: const InputDecoration(
//                 labelText: 'Username',
//                 border: OutlineInputBorder(),
//                 filled: true,
//                 fillColor: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _passwordController,
//               decoration: const InputDecoration(
//                 labelText: 'Password',
//                 border: OutlineInputBorder(),
//                 filled: true,
//                 fillColor: Colors.white,
//               ),
//               obscureText: true,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               child: const Text('Register'),
//               onPressed: () async {
//                 final username = _usernameController.text;
//                 final password = _passwordController.text;
//
//                 // Insert the user into the database
//                 await DatabaseHelper().insertUser({
//                   'username': username,
//                   'password': password,
//                 });
//
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  RegisterPage({super.key});

  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Register'),
              onPressed: () async {
                final username = _usernameController.text;
                final password = hashPassword(_passwordController.text);

                // Insert the user into the database
                await DatabaseHelper().insertUser({
                  'username': username,
                  'password': password,
                });

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

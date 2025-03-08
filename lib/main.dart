import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hc_ps_bueno/firebase_options.dart';
import 'LoginPage.dart'; // Asegúrate de que este archivo exista

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HISTORIAS CLINICAS',
      theme: ThemeData(
        primaryColor: Color.fromARGB(214, 232, 56, 56),
      ),
      home: LoginPage(), // Cambiar a LoginPage
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tinder_itc/routes.dart';
import 'package:tinder_itc/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      routes: getApplicationRoutes(),
      home: const Login()
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_itc/app_preferences.dart';
import 'package:tinder_itc/provider/user_provider.dart';
import 'package:tinder_itc/routes.dart';
import 'package:tinder_itc/screens/login.dart';
import 'package:tinder_itc/screens/on_boarding_screen.dart';
import 'package:tinder_itc/settings/styles_settings.dart';
import 'package:tinder_itc/user_preferences_dev.dart';

import 'notifications.dart';

Future<void> backgroundMessageHandler(RemoteMessage message) async {
  showNotificacion(message.notification!.title!, message.notification!.body!);
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();
  await Firebase.initializeApp();
  await UserPreferencesDev.preferences();
  await AppPreferences.preferences();
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    String deviceToken = await getDeviceToken();
    print("-----------------------");
    print(deviceToken);
    print("-----------------------");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotificacion(
          message.notification!.title!, message.notification!.body!);
      // Mostrar la notificación recibida
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('La notificación fue abierta desde una app en segundo plano');
      showNotificacion(
          message.notification!.title!, message.notification!.body!);
      // Realizar acciones necesarias al abrir la notificación en segundo plano
    });

    // Realizar acciones necesarias al recibir una notificación en segundo plano

    // Resto del código de tu aplicación
  }

// Callback para manejar notificaciones en segundo plano

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: getApplicationRoutes(),
        title: 'Flutter Demo',
        theme: StylesSettings.darkTheme,
        home: AppPreferences.firstTimeOpen ? const OnBoardingScreen() : Login(),
      ),
    );
  }

  Future getDeviceToken() async {
    FirebaseMessaging _firebaseMessage = FirebaseMessaging.instance;

    String? deviceToken = await _firebaseMessage.getToken();
    return deviceToken ?? "";
  }
}

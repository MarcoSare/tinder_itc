import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tinder_itc/app_preferences.dart';
import 'package:tinder_itc/models/user_model.dart';
import 'package:tinder_itc/provider/filters_provider.dart';
import 'package:tinder_itc/provider/theme_provider.dart';
import 'package:tinder_itc/provider/user_provider.dart';
import 'package:tinder_itc/routes.dart';
import 'package:tinder_itc/screens/dashboard_screen.dart';
import 'package:tinder_itc/screens/details_user.dart';
import 'package:tinder_itc/screens/login.dart';
import 'package:tinder_itc/screens/messaging_screen.dart';
import 'package:tinder_itc/screens/on_boarding_screen.dart';
import 'package:tinder_itc/screens/settings_screen.dart';
import 'package:tinder_itc/settings/styles_settings.dart';
import 'package:tinder_itc/theme_preferences.dart';
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
  final userModel = await UserPreferencesDev.getUserObject();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
            create: (_) => UserProvider()..setUserData(userModel)),
        ChangeNotifierProvider<FiltersProvider>(
            create: (_) => FiltersProvider()),
      ],
      child: const MyApp(),
    ));
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool theme;
  late UserModel userModel;
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

  initData() async {
    ThemePreferences themePreferences = ThemePreferences();
    userModel = await UserPreferencesDev.getUserObject();
    theme = await themePreferences.getTheme() ?? true;
  }

  @override
  Widget build(BuildContext context) {
    //final userProvider = Provider.of<UserProvider>(context);
    return FutureBuilder(
        future: initData(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return const Center(
                  child: Center(child: CircularProgressIndicator()));

            case ConnectionState.done:
              return ChangeNotifierProvider(
                  create: (context) => ThemeProvider()..init(theme),
                  builder: (context, _) {
                    final themeProvider = Provider.of<ThemeProvider>(context);
                    return GetMaterialApp(
                        debugShowCheckedModeBanner: false,
                        routes: getApplicationRoutes(),
                        title: 'Flutter Demo',
                        themeMode: themeProvider.themeMode,
                        theme: StylesSettings.lightTheme,
                        darkTheme: StylesSettings.darkTheme,
                        home: Builder(
                          builder: (context) {
                            if (AppPreferences.firstTimeOpen == true) {
                              return const OnBoardingScreen();
                            } else if (UserPreferencesDev.user !=
                                '["no_user"]') {
                              return const DashBoardScreen();
                            } else {
                              return Login();
                            }
                          },
                        ));
                  });
          }
        });
  }

  /*
  MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: getApplicationRoutes(),
          title: 'Flutter Demo',
          theme: StylesSettings.darkTheme,
          home: Builder(
            builder: (context) {
              if (AppPreferences.firstTimeOpen == true) {
                return const OnBoardingScreen();
              } else if (UserPreferencesDev.user != '["no_user"]') {
                final user = Provider.of<UserProvider>(context);
                user.setUserData(UserPreferencesDev.getUserObject());
                return const DashBoardScreen();
              } else {
                return Login();
              }
            },
          )),
    );
  */

  Future getDeviceToken() async {
    FirebaseMessaging _firebaseMessage = FirebaseMessaging.instance;

    String? deviceToken = await _firebaseMessage.getToken();
    AppPreferences.tokenDivice = deviceToken!;
    return deviceToken;
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_itc/app_preferences.dart';
import 'package:tinder_itc/provider/user_provider.dart';
import 'package:tinder_itc/routes.dart';
import 'package:tinder_itc/screens/login.dart';
import 'package:tinder_itc/screens/on_boarding_screen.dart';
import 'package:tinder_itc/settings/styles_settings.dart';
import 'package:tinder_itc/user_preferences_dev.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserPreferencesDev.preferences();
  await AppPreferences.preferences();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider()
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: getApplicationRoutes(),
        title: 'Flutter Demo',
        theme: StylesSettings.darkTheme,
        home: AppPreferences.firstTimeOpen? const OnBoardingScreen() : Login(),
      ),
    );
  }
}
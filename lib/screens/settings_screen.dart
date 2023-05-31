import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_itc/firebase/email_auth.dart';
import 'package:tinder_itc/firebase/github_auth.dart';
import 'package:tinder_itc/firebase/google_auth.dart';
import 'package:tinder_itc/provider/theme_provider.dart';
import 'package:tinder_itc/provider/user_provider.dart';
import 'package:tinder_itc/theme_preferences.dart';
import 'package:tinder_itc/user_preferences_dev.dart';
import 'package:tinder_itc/widgets/alert_widget.dart';

import 'details_user.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  ThemePreferences themePreferences = ThemePreferences();
  void signout() {
    GithubAuth _git = GithubAuth();
    GoogleAuth _google = GoogleAuth();
    EmailAuth _email = EmailAuth();
    final providerId =
        FirebaseAuth.instance.currentUser!.providerData[0].providerId;
    switch (providerId) {
      case 'github.com':
        _git.signOutFromGitHub();
        break;

      case 'google.com':
        _google.signOutFromGoogle();
        break;

      case 'password':
        _email.signOutFromEmail();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> logoutActions = [
      ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('volver')),
      ElevatedButton(
          onPressed: () {
            signout();
            UserPreferencesDev.clearPrefs();
            Navigator.pushNamed(context, '/login');
          },
          child: const Text('cerrar sesión')),
    ];
    final userProvider = Provider.of<UserProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        "assets/images/favicon.png"), //fixe resolutions
                    fit: BoxFit.fill),
              ),
            ),
            const Text('Tinder ITC'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const Text(
            "Configuraciones",
            style: TextStyle(fontSize: 26),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage(userProvider.user!.profilePicture!),
                      backgroundColor: Colors.transparent,
                      radius: 60,
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle),
                          child: IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Theme.of(context).colorScheme.background,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/update_profile');
                            },
                          ),
                        )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          userProvider.user!.name!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.25)),
                          child: Column(children: [
                            SizedBox(
                              width: 200,
                              child: ListTile(
                                leading: const Icon(Icons.settings),
                                title: const Text("Configuración"),
                                onTap: () {
                                  showBottomSheet(themeProvider);
                                },
                              ),
                            ),
                            SizedBox(
                              width: 200,
                              child: ListTile(
                                leading: const Icon(Icons.account_circle),
                                title: const Text("Tu perfil"),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailsUser(
                                                user: userProvider.user!,
                                                isLiked: false,
                                              )));
                                },
                              ),
                            ),
                            SizedBox(
                              width: 200,
                              child: ListTile(
                                leading: Icon(
                                  Icons.logout_outlined,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                title: Text(
                                  "Cerrar sesión",
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.error),
                                ),
                                onTap: () {
                                  AlertWidget.showMessageWithActions(
                                      context,
                                      'Cerrando sesión',
                                      '¿Estas seguro?',
                                      logoutActions);
                                },
                              ),
                            )
                          ]),
                        )))
              ],
            ),
          )
        ]),
      ),
    );
  }

//light_mode
  void showBottomSheet(ThemeProvider themeProvider) => showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                  leading: Icon(themeProvider.isDarkMode
                      ? Icons.light_mode
                      : Icons.dark_mode),
                  title: const Text('Cambiar de tema'),
                  trailing: Switch.adaptive(
                    value: themeProvider.isDarkMode,
                    onChanged: (bool value) async {
                      themeProvider.toggleTheme(value);
                      await themePreferences.setTheme(value);
                    },
                  )),
              ListTile(
                leading: const Icon(Icons.tune),
                title: const Text('Ajustes de búsqueda'),
                onTap: () {
                  Navigator.pushNamed(context, '/filter_settings');
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Editar perfil'),
                onTap: () {
                  Navigator.pushNamed(context, '/update_profile');
                },
              )
            ],
          ));
}

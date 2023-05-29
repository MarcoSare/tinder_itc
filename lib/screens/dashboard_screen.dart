import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tinder_itc/firebase/email_auth.dart';
import 'package:tinder_itc/firebase/github_auth.dart';
import 'package:tinder_itc/firebase/google_auth.dart';
import 'package:tinder_itc/screens/home_screen.dart';
import 'package:tinder_itc/screens/likes_home_screen.dart';
import 'package:tinder_itc/screens/match_screen.dart';
import 'package:tinder_itc/user_preferences_dev.dart';
import 'package:tinder_itc/widgets/alert_widget.dart';

import '../provider/user_provider.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int _selectedIndex = 0;
  DateTime? currenBackTime;
  late Widget matchScreen;
  late List<Widget> _widgetOptions;
  int conunter = 0;
  final GlobalKey<RefreshIndicatorState> _screen0Key =
      GlobalKey<RefreshIndicatorState>();
  void reloadScreen0() {
    setState(() {
      _screen0Key.currentState?.show();
    });
  }

  @override
  void initState() {
    matchScreen = const MatchScreen();
    _widgetOptions = <Widget>[
      const MatchScreen(),
      const LikeHomeScreen(),
      const HomeScreen(),
      const Text("profile")
    ];
    super.initState();
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

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
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
                Text(
                  conunter.toString(),
                  style: const TextStyle(color: Colors.transparent),
                )
              ],
            ),
            actions: [
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.notifications)),
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/filter_settings');
                  },
                  icon: const Icon(Icons.tune)),
              IconButton(
                  onPressed: () {
                    AlertWidget.showMessageWithActions(context,
                        'Cerrando sesión', '¿Estas seguro?', logoutActions);
                  },
                  icon: const Icon(Icons.exit_to_app))
            ],
          ),
          body: IndexedStack(
            index: _selectedIndex,
            children: _widgetOptions,
          ),
          bottomNavigationBar: BottomAppBar(
            child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(143, 255, 179, 182),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.whatshot,
                        color: _selectedIndex == 0 ? Colors.red : null,
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 0;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.favorite,
                          color: _selectedIndex == 1 ? Colors.red : null),
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.manage_search,
                          color: _selectedIndex == 2 ? Colors.red : null),
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 2;
                        });
                      },
                    ),
                    getProfile(context)
                  ],
                )),
          )),
    );
  }

  Widget getProfile(BuildContext context) {
    return SizedBox(
        height: 60,
        width: 70,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60))),
          onPressed: () {
            Navigator.pushNamed(context, '/update_profile');
          },
          child: CircleAvatar(
            backgroundColor: Color.fromRGBO(23, 32, 42, 1),
            radius: 60,
            child: Selector<UserProvider, String>(
                selector: (_, provider) => provider.user!.profilePicture ?? 'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png',
                builder: (context, profilePicture, child) {
                  return CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 60,
                    backgroundImage: CachedNetworkImageProvider(profilePicture),
                  );
                }),
          ),
        ));
  }

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

  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if (currenBackTime == null ||
        now.difference(currenBackTime!) > const Duration(seconds: 15)) {
      currenBackTime = now;
      Fluttertoast.showToast(msg: '¿Seguro que quieres salir?');
      return false;
    } else {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      return false;
    }
  }
}

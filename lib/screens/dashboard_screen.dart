import 'package:flutter/material.dart';
import 'package:tinder_itc/screens/home_screen.dart';
import 'package:tinder_itc/screens/match_screen.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const MatchScreen(),
    const HomeScreen(),
    const Text("profile")
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              const Text('Tinder ITC')
            ],
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.tune))
          ],
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
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
                    icon: Icon(Icons.manage_search,
                        color: _selectedIndex == 1 ? Colors.red : null),
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                    },
                  ),
                  getProfile()
                ],
              )),
        ));
  }

  Widget getProfile() {
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
          onPressed: () {},
          child: const CircleAvatar(
            backgroundColor: Color.fromRGBO(23, 32, 42, 1),
            radius: 60,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 60,
              backgroundImage: NetworkImage(
                  'https://xsgames.co/randomusers/assets/avatars/male/74.jpg'),
            ),
          )),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_itc/provider/user_provider.dart';
import 'package:tinder_itc/screens/likes_screen.dart';
import 'package:tinder_itc/screens/your_like_screen.dart';
import 'package:tinder_itc/widgets/user_card_widget.dart';

class LikeHomeScreen extends StatefulWidget {
  const LikeHomeScreen({super.key});

  @override
  State<LikeHomeScreen> createState() => _LikeHomeScreenState();
}

class _LikeHomeScreenState extends State<LikeHomeScreen> {
  Widget likeScreen = const LikeScreen();
  Widget yourLikes = const YourLikes();
  final mFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Likes"),
            bottom: const TabBar(tabs: [
              Tab(text: "Likes"),
              Tab(
                text: "Tus likes",
              )
            ]),
          ),
          body: TabBarView(
            children: [likeScreen, yourLikes],
          )),
    );
  }
}

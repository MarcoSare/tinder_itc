import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_itc/provider/user_provider.dart';
import 'package:tinder_itc/widgets/user_card_widget.dart';

class LikeScreen extends StatefulWidget {
  const LikeScreen({super.key});

  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  final mFirestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: Center(
        child: StreamBuilder(
            stream: mFirestore
                .collection('usuarios')
                .doc(userProvider.user!.id)
                .collection('likes')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Text(
                  'No Data...',
                );
              } else {
                if (snapshot.data!.docs.isEmpty) {
                  return const Text("No tienes likes");
                } else {
                  return GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            (MediaQuery.of(context).size.width ~/ 170).toInt(),
                        childAspectRatio: .9,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return UserCardWidget(
                        idUser: snapshot.data!.docs[index]['idUser'].toString(),
                        isYourLike: false,
                      );
                    },
                  );
                }
              }
            }),
      ),
    );
  }
}

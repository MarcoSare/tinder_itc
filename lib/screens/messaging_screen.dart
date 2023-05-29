import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_itc/provider/user_provider.dart';
import 'package:tinder_itc/widgets/user_card_widget.dart';
import 'package:tinder_itc/widgets/user_match_card.dart';

class MessagingScreen extends StatefulWidget {
  const MessagingScreen({super.key});

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tus matchs'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("usuarios")
              .doc(userProvider.user!.id)
              .collection('matchs')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("Say Hi"),
                );
              }
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
                  return UserMatchCardWidget(
                      idUser: snapshot.data!.docs[index].id);
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}

Widget getCard({required img, required name, required carrer}) {
  return ListTile(
    leading: Container(
      margin: const EdgeInsets.all(5),
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: NetworkImage(name), fit: BoxFit.cover)),
    ),
    title: Text(name),
    subtitle: Text(carrer),
  );
}

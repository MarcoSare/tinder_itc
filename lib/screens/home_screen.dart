import 'package:flutter/material.dart';
import 'package:tinder_itc/firebase/users_firebase.dart';
import 'package:tinder_itc/models/user_model.dart';
import 'package:tinder_itc/widgets/user_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cerca'),
        ),
        body: Center(
          child: FutureBuilder(
            future: UsersFireBase.getAllUsers(),
            builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          (MediaQuery.of(context).size.width ~/ 170).toInt(),
                      childAspectRatio: .9,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return UserCardWidget(userModel: snapshot.data![index]);
                  },
                );
              } else if (snapshot.hasError) {
                return const Text("error");
              } else {
                return const Text("Loading");
              }
            },
          ),
        ));
  }
}

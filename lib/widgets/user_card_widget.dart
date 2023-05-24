import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tinder_itc/firebase/users_firebase.dart';
import 'package:tinder_itc/models/user_model.dart';

class UserCardWidget extends StatefulWidget {
  String idUser;
  UserCardWidget({super.key, required this.idUser});

  @override
  State<UserCardWidget> createState() => _UserCardWidgetState();
}

class _UserCardWidgetState extends State<UserCardWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: UsersFireBase.getUsers(widget.idUser),
        builder: (context, AsyncSnapshot<UserModel?> snapshot) {
          if (snapshot.hasData) {
            return Container(
              width: 200.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(snapshot.data!.profilePicture!),
                      fit: BoxFit.cover),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black54,
                        Colors.black87,
                      ],
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${snapshot.data!.name!} 23',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          height: 10,
                          width: 10,
                          decoration: const BoxDecoration(
                              color: Colors.green, shape: BoxShape.circle),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text("En linea"),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          } else {
            return SizedBox(
              width: 200.0,
              child: Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(0.25),
                  highlightColor: Colors.white.withOpacity(0.6),
                  child: Container(
                    width: 250.0,
                    height: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey),
                  )),
            );
          }
        });
  }

  /*
  
  */
}

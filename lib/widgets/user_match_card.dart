import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tinder_itc/firebase/users_firebase.dart';
import 'package:tinder_itc/models/user_model.dart';
import 'package:tinder_itc/screens/chat_screen.dart';

class UserMatchCardWidget extends StatefulWidget {
  String idUser;
  UserMatchCardWidget({super.key, required this.idUser});

  @override
  State<UserMatchCardWidget> createState() => _UserMatchCardWidgetState();
}

class _UserMatchCardWidgetState extends State<UserMatchCardWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: UsersFireBase.getUsers(widget.idUser),
        builder: (context, AsyncSnapshot<UserModel?> snapshot) {
          if (snapshot.hasData) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatScreen(
                              friendId: widget.idUser,
                              friendImage: snapshot.data!.profilePicture!,
                              friendName: snapshot.data!.name!,
                              device: snapshot.data!.tokenDevice,
                            )));
                //ChatScreen
              },
              child: CachedNetworkImage(
                  imageUrl: snapshot.data!.profilePicture!,
                  imageBuilder: (context, imageProvider) => Container(
                        width: 200.0,
                        height: 200,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15))),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
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
                                '${snapshot.data!.name!}',
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
                                        color: Colors.green,
                                        shape: BoxShape.circle),
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
                      )),
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

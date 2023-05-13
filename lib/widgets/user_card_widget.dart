import 'package:flutter/material.dart';
import 'package:tinder_itc/models/user_model.dart';

class UserCardWidget extends StatefulWidget {
  UserModel? userModel;
  UserCardWidget({super.key, this.userModel});

  @override
  State<UserCardWidget> createState() => _UserCardWidgetState();
}

class _UserCardWidgetState extends State<UserCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(widget.userModel!.profilePicture!),
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
              '${widget.userModel!.name!} 23',
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
  }
}

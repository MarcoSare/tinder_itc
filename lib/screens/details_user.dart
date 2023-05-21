import 'package:flutter/material.dart';
import 'package:tinder_itc/models/user_model.dart';

class DetailsUser extends StatefulWidget {
  UserModel user;
  DetailsUser({super.key, required this.user});

  @override
  State<DetailsUser> createState() => _DetailsUserState();
}

class _DetailsUserState extends State<DetailsUser> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        extendBody: true,
        body: ListView(
          children: [
            SizedBox(
              height: 500,
              width: width,
              child: Stack(
                children: [
                  Image.network(
                    widget.user.profilePicture!,
                    height: 450,
                    width: width,
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                      bottom: 0,
                      right: 50,
                      child: SizedBox(
                        height: 100,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pinkAccent,
                              shape: const CircleBorder()),
                          child: const Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.user.name!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "23",
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ],
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
                        child: Text(
                          "En linea",
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ],
                  ),
                  const Text(
                    "Sobre mí",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    widget.user.aboutMe!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            )
          ],
        ),
        bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const CircleBorder()),
                    child: const Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 32,
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const CircleBorder()),
                    child: const Icon(
                      Icons.star,
                      color: Colors.blue,
                      size: 32,
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const CircleBorder()),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.pinkAccent,
                      size: 32,
                    ),
                  ),
                ),
              ],
            )));
  }
}

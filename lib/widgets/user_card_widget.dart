import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tinder_itc/firebase/users_firebase.dart';
import 'package:tinder_itc/models/user_model.dart';
import 'package:tinder_itc/provider/user_provider.dart';
import 'package:tinder_itc/screens/details_user.dart';

class UserCardWidget extends StatefulWidget {
  String idUser;
  bool isYourLike;
  UserCardWidget({super.key, required this.idUser, required this.isYourLike});

  @override
  State<UserCardWidget> createState() => _UserCardWidgetState();
}

class _UserCardWidgetState extends State<UserCardWidget> {
  double initialX = 0.0;
  int opcion = 0;
  Widget getCard(UserModel? user) {
    return CachedNetworkImage(
        imageUrl: user!.profilePicture!,
        imageBuilder: (context, imageProvider) => Container(
              width: 200.0,
              height: 200,
              decoration: BoxDecoration(
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              child: Container(
                width: 200.0,
                height: 200,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
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
                      '${user.name!}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 10,
                          width: 10,
                          decoration: const BoxDecoration(
                              color: Colors.green, shape: BoxShape.circle),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              user.carrer!,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  Widget getCardFeedBack(UserModel? user) {
    return CachedNetworkImage(
        imageUrl: user!.profilePicture!,
        imageBuilder: (context, imageProvider) => Container(
              width: 200.0,
              height: 200,
              decoration: BoxDecoration(
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              child: Container(
                width: 200.0,
                height: 200,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black54,
                        Colors.black87,
                      ],
                    )),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return FutureBuilder(
        future: UsersFireBase.getUsers(widget.idUser),
        builder: (context, AsyncSnapshot<UserModel?> snapshot) {
          if (snapshot.hasData) {
            return GestureDetector(
              onTap: () {},
              child: Draggable(
                feedback: getCardFeedBack(snapshot.data),
                childWhenDragging: SizedBox(
                  child: Icon(
                    opcion > 0
                        ? opcion == 1
                            ? Icons.favorite
                            : Icons.close
                        : Icons.block,
                    color: opcion > 0
                        ? opcion == 1
                            ? Colors.pinkAccent
                            : Colors.red
                        : Theme.of(context).colorScheme.primary,
                    size: 100,
                  ),
                ),
                onDragStarted: () {
                  // Inicia el arrastre, guarda la posición inicial
                  initialX = 0.0;
                },
                onDragUpdate: (DragUpdateDetails details) {
                  // Actualiza la posición actual del arrastre
                  if (initialX == 0.0) {
                    initialX = details.globalPosition.dx;
                  } else {
                    double currentX = details.globalPosition.dx;
                    if (currentX > initialX) {
                      setState(() {
                        opcion = 1;
                      });
                    } else if ((initialX - currentX) >= 0 &&
                        (initialX - currentX) <= 30) {
                      setState(() {
                        opcion = 0;
                      });
                    } else {
                      setState(() {
                        opcion = 2;
                      });
                    }
                  }
                },
                onDragEnd: (DraggableDetails details) {
                  if (opcion == 1) {
                    if (!widget.isYourLike) {
                      UsersFireBase.like(
                              idFrom: userProvider.user!.id!,
                              toUser: snapshot.data!)
                          .then((value) {
                        if (value == 1) {
                          Get.snackbar(
                            "Haz hecho matchs",
                            "Ve a tus matchs para seguir",
                            icon: const Icon(Icons.favorite,
                                color: Colors.pinkAccent),
                            snackPosition: SnackPosition.TOP,
                          );
                        } else if (value == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            elevation: 6.0,
                            behavior: SnackBarBehavior.floating,
                            content: const Text("LIKE"),
                            duration: const Duration(milliseconds: 500),
                          ));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                            elevation: 6.0,
                            behavior: SnackBarBehavior.floating,
                            content: const Text("Ha ocurrido un error"),
                            duration: const Duration(milliseconds: 500),
                          ));
                        }
                      });
                    } else {
                      Get.snackbar(
                        "Ya le diste like a esta persona",
                        "Espera a que la otra persona responda a tu like para poder hacer match",
                        icon: const Icon(Icons.favorite,
                            color: Colors.pinkAccent),
                        snackPosition: SnackPosition.TOP,
                      );
                    }
                  } else if (opcion == 2) {
                    print("haz eliminado a esta persona");
                  }
                },
                child: getCard(snapshot.data),
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

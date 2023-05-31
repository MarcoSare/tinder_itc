import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';
import 'package:tinder_itc/app_preferences.dart';
import 'package:tinder_itc/firebase/users_firebase.dart';
import 'package:tinder_itc/models/user_model.dart';
import 'package:tinder_itc/network/api_users.dart';
import 'package:tinder_itc/provider/filters_provider.dart';
import 'package:tinder_itc/provider/user_provider.dart';
import 'package:tinder_itc/screens/details_user.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  bool like = false;
  bool nope = false;
  int counter = 0, counter2 = 0;
  int counterLike = 0;
  bool isEnd = false;
  late String idTo;
  List<UserModel> listUsers = List.empty(growable: true);
  final SwipeableCardSectionController _cardController =
      SwipeableCardSectionController();

  List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;

  initData(String idFrom) async {
    List<UserModel> response = await ApiUsers.getAllUsers(idFrom);

    for (UserModel u in response) {
      _swipeItems.add(
        SwipeItem(
            content: u,
            likeAction: () {
              UsersFireBase.like(idFrom: idFrom, toUser: u).then((value) {
                if (value == 1) {
                  Get.snackbar(
                    "Haz hecho matchs",
                    "Ve a tus matchs para seguir",
                    icon: const Icon(Icons.favorite, color: Colors.pinkAccent),
                    snackPosition: SnackPosition.TOP,
                  );
                } else if (value == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    elevation: 6.0,
                    behavior: SnackBarBehavior.floating,
                    content: const Text("LIKE"),
                    duration: const Duration(milliseconds: 500),
                  ));
                } else if (value == 2) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    elevation: 6.0,
                    behavior: SnackBarBehavior.floating,
                    content: const Text("Ya has dado like"),
                    duration: const Duration(milliseconds: 500),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    elevation: 6.0,
                    behavior: SnackBarBehavior.floating,
                    content: const Text("Ha ocurrido un error"),
                    duration: const Duration(milliseconds: 500),
                  ));
                }
              });
            },
            nopeAction: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                elevation: 6.0,
                behavior: SnackBarBehavior.floating,
                content: Text("NOPE"),
                duration: Duration(milliseconds: 500),
              ));
            }),
      );
    }
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    double height = MediaQuery.of(context).size.height;
    String? idFrom = userProvider.user!.id!;
    return Scaffold(
        body: Center(
            child: FutureBuilder(
                future: initData(idFrom),
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Stack(children: [
                      SizedBox(
                        height: height * 0.8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            !isEnd
                                ? Container(
                                    padding: const EdgeInsets.all(10),
                                    height: height * 0.79,
                                    width: double.infinity,
                                    child: SwipeCards(
                                      matchEngine: _matchEngine!,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return getCard(
                                            _swipeItems[index].content);
                                      },
                                      onStackFinished: () {
                                        setState(() {
                                          isEnd = true;
                                        });
                                      },
                                    ),
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.all(3.0),
                                          child: Text(
                                            "No se encontraron personas",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Text(
                                            "Revisa tus ajustes de búsqueda para encontar personas",
                                            style: TextStyle(fontSize: 16),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      like
                          ? Positioned(
                              left: 30,
                              top: 150,
                              child: FadeInUp(
                                delay: const Duration(microseconds: 1000),
                                child: Transform.rotate(
                                  angle: 345,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 5, color: Colors.red),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15))),
                                    child: const Text(
                                      "LIKE",
                                      style: TextStyle(
                                          fontSize: 32, color: Colors.red),
                                    ),
                                  ),
                                ),
                              ))
                          : const Text(""),
                      nope
                          ? Positioned(
                              right: 30,
                              top: 150,
                              child: FadeInUp(
                                delay: const Duration(microseconds: 1000),
                                child: Transform.rotate(
                                  angle: 345,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 5, color: Colors.red),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15))),
                                    child: const Text(
                                      "NOPE",
                                      style: TextStyle(
                                          fontSize: 32, color: Colors.red),
                                    ),
                                  ),
                                ),
                              ))
                          : const Text(""),
                      Positioned(
                          bottom: 0,
                          left: 50,
                          right: 50,
                          child: Container(
                            width: 250,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 100,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _matchEngine!.currentItem?.nope();
                                    },
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
                                    onPressed: () {
                                      _matchEngine!.currentItem?.like();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: const CircleBorder()),
                                    child: const Icon(
                                      Icons.favorite,
                                      color: Colors.pinkAccent,
                                      size: 32,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ))

                      //other children
                    ]);
                  } else if (snapshot.hasError) {
                    return const Text("error");
                  } else {
                    return SizedBox(
                      height: 200,
                      width: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          LoadingAnimationWidget.beat(
                              color: Colors.white, size: 120),
                          Positioned(
                            top: 50,
                            bottom: 50,
                            child: CircleAvatar(
                              backgroundColor:
                                  const Color.fromRGBO(23, 32, 42, 1),
                              radius: 50,
                              child: Selector<UserProvider, String>(
                                  selector: (_, provider) =>
                                      provider.user!.profilePicture!,
                                  builder: (context, profilePicture, child) {
                                    return CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 50,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              profilePicture),
                                    );
                                  }),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                })));
  }

  Widget getCard(UserModel user) {
    return CachedNetworkImage(
      imageUrl: user.profilePicture ??
          'https://idaip.org.mx/gobiernoabierto/wp-content/uploads/2018/09/avatar-300x300.png',
      imageBuilder: (context, imageProvider) => Container(
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              borderRadius: const BorderRadius.all(Radius.circular(15))),
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black87,
                    Colors.black,
                  ],
                )),
            child: Container(
              margin: const EdgeInsets.only(bottom: 100, left: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.name!} ${user.age}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
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
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(
                                () => DetailsUser(
                                      user: user,
                                      isLiked: true,
                                    ),
                                transition: Transition.downToUp,
                                duration: const Duration(milliseconds: 500));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: const CircleBorder()),
                          child: const Icon(
                            Icons.upgrade,
                            color: Colors.pinkAccent,
                            size: 28,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )),
      placeholder: (context, url) => SizedBox(
        width: 350,
        height: 650,
        child: Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.25),
            highlightColor: Colors.white.withOpacity(0.6),
            child: Container(
              width: 250.0,
              height: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.grey),
            )),
      ),
      errorWidget: (context, url, error) => SizedBox(
        width: 350,
        height: 650,
        child: Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.25),
            highlightColor: Colors.white.withOpacity(0.6),
            child: Container(
              width: 250.0,
              height: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.grey),
            )),
      ),
    );

    ;
  }
}

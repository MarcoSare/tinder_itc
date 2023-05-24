import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';
import 'package:tinder_itc/firebase/users_firebase.dart';
import 'package:tinder_itc/models/user_model.dart';
import 'package:tinder_itc/network/api_users.dart';
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
  int counter = 0;
  late String idTo;
  final SwipeableCardSectionController _cardController =
      SwipeableCardSectionController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final userProvider = Provider.of<UserProvider>(context);
    String idFrom = userProvider.user!.id!;
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: ApiUsers.getAllUsers(idFrom),
          builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
            if (snapshot.hasData) {
              return Stack(children: [
                SizedBox(
                  //padding: EdgeInsets.all(0),
                  //color: Colors.red,
                  height: height * 0.8,
                  child: Column(
                    children: [
                      SwipeableCardsSection(
                        cardHeightTopMul: 0.95,
                        cardHeightMiddleMul: 0.7,
                        cardWidthTopMul: 0.95,
                        cardWidthMiddleMul: 0.9,
                        cardController: _cardController,
                        context: context,
                        items: [
                          for (UserModel userModel in snapshot.data!)
                            getCard(user: userModel)
                        ],

                        onCardSwiped: (dir, index, widget) {
                          if (counter < snapshot.data!.length - 3) {
                            _cardController.addItem(
                                getCard(user: snapshot.data![index + 3]));
                            idTo = snapshot.data![counter].id!;
                            counter++;
                            print(counter);
                          }

                          if (dir == Direction.left) {
                            setState(() {
                              nope = true;
                            });
                            Future.delayed(Duration(milliseconds: 1000), () {
                              setState(() {
                                nope = false;
                              });
                            });
                          } else if (dir == Direction.right) {
                            UsersFireBase.like(idFrom: idFrom, idTo: idTo).then(
                              (value) {
                                setState(() {
                                  like = true;
                                });
                                Future.delayed(Duration(milliseconds: 1000),
                                    () {
                                  setState(() {
                                    like = false;
                                  });
                                });
                              },
                            );
                          }
                        },

                        //
                        enableSwipeUp: true,
                        enableSwipeDown: true,
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
                                  border:
                                      Border.all(width: 5, color: Colors.red),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15))),
                              child: const Text(
                                "LIKE",
                                style:
                                    TextStyle(fontSize: 32, color: Colors.red),
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
                                  border:
                                      Border.all(width: 5, color: Colors.red),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15))),
                              child: const Text(
                                "NOPE",
                                style:
                                    TextStyle(fontSize: 32, color: Colors.red),
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
                                _cardController.triggerSwipeLeft();
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
                                _cardController.triggerSwipeRight();
                                //
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
                    LoadingAnimationWidget.beat(color: Colors.white, size: 120),
                    Positioned(
                      top: 50,
                      bottom: 50,
                      child: CircleAvatar(
                        backgroundColor: const Color.fromRGBO(23, 32, 42, 1),
                        radius: 50,
                        child: Selector<UserProvider, String>(
                            selector: (_, provider) =>
                                provider.user!.profilePicture!,
                            builder: (context, profilePicture, child) {
                              return CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 50,
                                backgroundImage:
                                    CachedNetworkImageProvider(profilePicture),
                              );
                            }),
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

/*
Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        SwipeableCardsSection(
          cardController: _cardController,
          context: context,
          //add the first 3 cards (widgets)
          items: [],
          //Get card swipe event callbacks
          onCardSwiped: (dir, index, widget) {
            //Add the next card using _cardController

            //Take action on the swiped widget based on the direction of swipe
            //Return false to not animate cards
          },
          //
          enableSwipeUp: true,
          enableSwipeDown: true,
        ),
        //other children
      ]),
*/
  Widget getCard({required UserModel user}) {
    return CachedNetworkImage(
      imageUrl: user.profilePicture!,
      imageBuilder: (context, imageProvider) => Container(
          height: 650,
          width: 250,
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
                    '${user.name!} 23',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailsUser(
                                          user: user,
                                        )));
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

import 'package:flutter/material.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';
import 'package:tinder_itc/firebase/users_firebase.dart';
import 'package:tinder_itc/models/user_model.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  SwipeableCardSectionController _cardController =
      SwipeableCardSectionController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: UsersFireBase.getAllUsers(),
          builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
            if (snapshot.hasData) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 600,
                      child: SwipeableCardsSection(
                        cardController: _cardController,
                        context: context,

                        //add the first 3 cards (widgets)
                        items: [
                          for (UserModel userModel in snapshot.data!)
                            getCard(
                                img: userModel.profilePicture,
                                name: userModel.name)
                        ],
                        //Get card swipe event callbacks
                        onCardSwiped: (dir, index, widget) {
                          _cardController.addItem(getCard(
                              img: snapshot.data![index].profilePicture,
                              name: snapshot.data![index].name));
                          //Add the next card using _cardController

                          //Take action on the swiped widget based on the direction of swipe
                          //Return false to not animate cards
                        },
                        //
                        enableSwipeUp: true,
                        enableSwipeDown: true,
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          )
                        ],
                      ),
                    )
                    //other children
                  ]);
            } else if (snapshot.hasError) {
              return const Text("error");
            } else {
              return const Text("Loading");
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
  Widget getCard({String? img, String? name}) {
    return Container(
        height: 400,
        width: 250,
        decoration: BoxDecoration(
            image:
                DecorationImage(image: NetworkImage(img!), fit: BoxFit.cover),
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        child: Container(
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
                '${name!} 23',
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
        ));
  }
}

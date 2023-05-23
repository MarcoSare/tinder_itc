import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tinder_itc/app_preferences.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late PageController _pageController;
  int _pageIndex = 0;
  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: dataOnBoarding(false));
  }

  Widget dataOnBoarding(bool isTablet) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Positioned(
            bottom: -60,
            left: -60,
            child: Transform.rotate(
              angle: 90,
              child: Image.asset(
                "assets/images/graph.png",
                height: 200,
                width: 200,
              ),
            )),
        Positioned(
            bottom: 50,
            top: 50,
            right: -100,
            child: Transform.rotate(
              angle: 180,
              child: Image.asset(
                "assets/images/graph.png",
                height: 200,
                width: 200,
              ),
            )),
        Column(
          children: [
            Expanded(
              child: PageView.builder(
                  itemCount: demoData.length,
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _pageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) => OnboardContent(
                      title: demoData[index].title,
                      descripcion: demoData[index].description,
                      image: demoData[index].image,
                      isTablet: isTablet)),
            ),
          ],
        ),
        Container(
            height: 130,
            width: 130,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      "assets/images/logo_tinder_itc.png"), //fixe resolutions
                  fit: BoxFit.fill),
            ),
            margin: const EdgeInsets.all(30)),
        Positioned(
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.only(right: 30, left: 30),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          _pageController.nextPage(
                              duration: const Duration(seconds: 1),
                              curve: Curves.decelerate);
                          if (_pageIndex == 2) {
                            Navigator.pushNamed(context, '/login');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).colorScheme.primary),
                        child: const Text(
                          'Siguiente',
                          style: TextStyle(color: Colors.white),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate(
                            demoData.length,
                            ((index) => Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: DotIndicator(
                                    isActivate: index == _pageIndex)))),
                      ],
                    )
                  ],
                ),
              ),
            )),
      ],
    );
  }
}

class OnboardContent extends StatelessWidget {
  const OnboardContent(
      {Key? key,
      required this.title,
      required this.descripcion,
      required this.image,
      required this.isTablet})
      : super(key: key);
  final String title, descripcion, image;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeInUp(
              delay: const Duration(microseconds: 700),
              child: Image.asset(image, height: 300, width: 300)),
          FadeInDown(
            delay: const Duration(microseconds: 700),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Playfair Display',
                  fontSize: isTablet ? 38 : 22,
                  fontWeight: FontWeight.w800,
                  fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          FadeInLeftBig(
            delay: const Duration(microseconds: 700),
            child: Text(
              descripcion,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: isTablet ? 24 : 14),
            ),
          ),
        ],
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({Key? key, this.isActivate = false}) : super(key: key);
  final bool isActivate;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      height: isActivate ? 30 : 15,
      width: 15,
      decoration: BoxDecoration(
          color: isActivate
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.primary.withOpacity(0.4),
          shape: BoxShape.circle),
    );
  }
}

class Onboard {
  final String image, title, description;
  Onboard(
      {required this.image, required this.title, required this.description});
}

final List<Onboard> demoData = [
  Onboard(
      image: "assets/images/boarding/boarding_1.png",
      title: "WELCOME TO OUR COMMUNITY",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua"),
  Onboard(
      image: "assets/images/boarding/boarding_2.png",
      title: "enjoy the experience",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua"),
  Onboard(
      image: "assets/images/boarding/boarding_3.png",
      title: "WELCOME TO OUR COMMUNITY x3",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua")
];

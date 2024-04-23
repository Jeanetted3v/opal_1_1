// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appinio_swiper/appinio_swiper.dart';

import '../../Models/opal_model.dart';
import 'opal_details_screen.dart';
import 'round_buttons.dart';
import 'swipe_actions.dart';

enum SwipeDirection { left, right, none }

class CardWidget extends StatefulWidget {
  final List<OpalModel> opals;
  

  CardWidget({required this.opals});

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  //SwipeDirection _lastSwipeDirection = SwipeDirection.none;
  final AppinioSwiperController _controller = AppinioSwiperController();
  final int currentIndex = 0;
  

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                //height: size.height * 0.99,
                child: AppinioSwiper(
                  cardCount: opalList.length,
                  swipeOptions: const SwipeOptions.all(),
                  controller: _controller,
                  allowUnSwipe: true,
                  //onSwipeBegin: ,
                  onSwipeEnd: _swipeEnd,
                  //onEnd: _onEnd,
                  loop: true,

                  //CardBuilder
                  cardBuilder: (BuildContext context, int index) {
                    OpalModel opalDetails = widget.opals[index];
                    return GestureDetector(
                      child: Stack(
                        children: [
                          //Image
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                alignment: Alignment.center,
                                image: NetworkImage(opalDetails.opalPics!.first), //use ?? instead
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),

                          //Gradient
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.transparent, Colors.black54],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),

                          //Bottom description
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Spacer(),
                              //information row
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            opalDetails.opalTitle,
                                            softWrap: true,
                                            maxLines: 5,
                                            style: const TextStyle(
                                                fontSize: 24,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '${opalDetails.city}, ${opalDetails.country}',
                                            softWrap: true,
                                            maxLines: 3,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),

                                    //Information button
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          _createVerticalRoute(
                                            OpalDetailsScreen(
                                              opalDetails: opalDetails,
                                              onCrossButtonPressed:
                                                  (BuildContext ctx) async {
                                                Navigator.pop(ctx);
                                                await Future.delayed(
                                                    const Duration(
                                                        milliseconds: 500));
                                                _controller.swipeLeft();
                                                recordLeftSwipe(index);
                                              },
                                              onHeartButtonPressed:
                                                  (BuildContext ctx) async {
                                                Navigator.pop(ctx);
                                                await Future.delayed(
                                                    const Duration(
                                                        milliseconds: 500));
                                                _controller.swipeRight();
                                                recordRightSwipe(index);
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.info,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: size.height * 0.1),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          //Top Stack of Rounded Buttons
          Column(
            children: [
              const Spacer(),
              //Round Buttons, need to be on top of the stack, permanent
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // const SizedBox(
                    //   width: 10,
                    // ),
                    unswipeButton(_controller, currentIndex),
                    const SizedBox(
                      width: 20,
                    ),
                    swipeLeftButton(_controller, currentIndex),
                    const SizedBox(
                      width: 20,
                    ),
                    swipeRightButton(_controller, currentIndex),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height / 25),
            ],
          ),
        ],
      ),
    );
  }

  // Swipe Functions
  void _swipeEnd(int previousIndex, int targetIndex, SwiperActivity activity) {
    switch (activity) {
      case Swipe():
        print('The card was swiped to the : ${activity.direction}');
        print('previous index: $previousIndex, target index: $targetIndex');
        if (activity.direction == SwipeDirection.left) {
          recordLeftSwipe(targetIndex); // Logic for recording a left swipe
        } else if (activity.direction == SwipeDirection.right) {
          recordRightSwipe(targetIndex); // Logic for recording a right swipe
        }
        break;
      case Unswipe():
        print('A ${activity.direction.name} swipe was undone.');
        print('previous index: $previousIndex, target index: $targetIndex');
        recordUnSwipe(targetIndex);
        break;
      case CancelSwipe():
        print('A swipe was cancelled');
        break;
      case DrivenActivity():
        print('Driven Activity');
        break;
    }
  }
} //Class

//TO DetailScreen, Vertical
PageRouteBuilder _createVerticalRoute(Widget nextPage) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return nextPage;
    },
    transitionsBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      Animation<double> customCurveAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );

      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(customCurveAnimation),
        child: child,
      );
    },
  );
}
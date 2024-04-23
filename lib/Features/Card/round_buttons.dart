import 'package:flutter/material.dart';
import 'package:appinio_swiper/appinio_swiper.dart';

import 'swipe_actions.dart';

class ExampleButton extends StatelessWidget {
  final Function onTap;
  final Widget child;

  const ExampleButton({
    required this.onTap,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: child,
    );
  }
}

//swipe card to the right side
Widget swipeRightButton(AppinioSwiperController controller, int currentIndex) {
  return ExampleButton(
    onTap: () {
      controller.swipeRight();
      recordRightSwipe(currentIndex);
    },
    child: Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: Colors.green.shade300,
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.0),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(
        Icons.favorite_sharp,
        color: Colors.green.shade300,
        size: 30, // Increased icon size
      ),
    ),
  );
}

//swipe card to the left side
Widget swipeLeftButton(AppinioSwiperController controller, int currentIndex) {
  return ExampleButton(
    onTap: () {
      controller.swipeLeft();
      recordLeftSwipe(currentIndex);
    },
    child: Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: Color(0xFFE1515F),
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Icon(
        Icons.clear,
        color: Color(0xFFE1515F),
        size: 35, // Increased icon size
      ),
    ),
  );
}

//unswipe card
Widget unswipeButton(AppinioSwiperController controller, int currentIndex) {
  return ExampleButton(
    onTap: () {
      controller.unswipe();
      recordUnSwipe(currentIndex);
    },
    child: Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300.withOpacity(0.9),
            spreadRadius: -10,
            blurRadius: 20,
            offset: const Offset(0, 20), // changes position of shadow
          ),
        ],
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.rotate_left_rounded,
        color: Colors.white,
        size: 40,
      ),
    ),
  );
}
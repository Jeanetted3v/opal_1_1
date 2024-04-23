//import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

import '../../Models/opal_model.dart';


class OpalDetailsScreen extends StatefulWidget {
  final OpalModel opalDetails;
  final Function(BuildContext) onCrossButtonPressed;
  final Function(BuildContext) onHeartButtonPressed;

  const OpalDetailsScreen({
    super.key,
    required this.opalDetails,
    required this.onCrossButtonPressed,
    required this.onHeartButtonPressed,
  });

  @override
  State<OpalDetailsScreen> createState() => _OpalDetailsScreenState();
}

class _OpalDetailsScreenState extends State<OpalDetailsScreen> {
  final _pageController = PageController(viewportFraction: 0.99);
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final numberOfImages = widget.opalDetails.opalPics!.length;
    final edgeDotBuffer = 0.5;
    final dotWidth =
        (size.width - edgeDotBuffer * 2 - (numberOfImages - 1) * 3) /
            numberOfImages;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * 0.75,
                    child: Stack(
                      children: [
                        //Image
                        PageView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: numberOfImages,
                          itemBuilder: (BuildContext context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 3),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  widget.opalDetails.opalPics![index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                          controller: _pageController,
                        ),

                        //Dot indicator
                        Positioned(
                          top: 3,
                          left: edgeDotBuffer,
                          right: edgeDotBuffer,
                          child: Center(
                            child: DotsIndicator(
                              dotsCount: numberOfImages,
                              position: _currentPage.round(),
                              decorator: DotsDecorator(
                                  spacing: const EdgeInsets.symmetric(
                                      horizontal: 2.5),
                                  color: Colors.grey.shade300,
                                  activeColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(1.0)),
                                  activeShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3.0)),
                                  size: Size(dotWidth, 4),
                                  activeSize:
                                      Size(dotWidth / numberOfImages, 4)),
                            ),
                          ),
                        ),

                        //Downwards arrow
                        Positioned(
                          bottom: 5,
                          left: size.width / 1.2,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: IconButton(
                                icon: IconTheme(
                                  data: IconThemeData(
                                    size: 40, // Adjust the size as needed
                                    color: Colors.grey.shade200,
                                  ),
                                  child: const Icon(
                                      Icons.arrow_drop_down_circle_sharp),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Details
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //OpalTitle
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.opalDetails
                                    .opalTitle, //Need to limit the number of characters
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  //fontFamily: '',
                                ),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 4.0, right: 15),
                              child: Icon(Icons.verified,
                                  color: Colors.green, size: 24.0),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10.0),

                        //Location
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                color: Colors.grey),
                            const SizedBox(width: 5.0),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Currently in ${widget.opalDetails.city}, ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade600),
                                  ),
                                  Text(
                                    widget.opalDetails.country!,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        //Industry
                        Row(
                          children: [
                            const Icon(Icons.business_center_outlined,
                                color: Colors.grey),
                            const SizedBox(width: 5.0),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${widget.opalDetails.industry}, ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade600),
                                  ),
                                  Text(
                                    '${widget.opalDetails.industry.first}, ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Divider(),

                  //AboutOpal
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0, top: 10, bottom: 5),
                    child: Text(
                      'ABOUT THIS OPAL',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 6),
                    child: Text(
                      widget.opalDetails.aboutOpal,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),

                  const Divider(),

                  //Opal tags: Chips
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0, top: 10, bottom: 5),
                    child: Text(
                      'TAGs',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: -2,
                      children: [
                        ...List.generate(
                          widget.opalDetails.opalTags!.length,
                          (index) => Chip(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.grey.shade400, width: 1),
                                borderRadius: BorderRadius.circular(30)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 2),
                            backgroundColor: Colors.grey.shade100,
                            label: Text(
                              widget.opalDetails.opalTags![index],
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade800,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(),

                  //Share this Opal
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            'SHARE THIS OPAL',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          Text('See what a friend or colleague thinks')
                        ],
                      ),
                    ),
                  ),
                  const Divider(),

                  //Report this Opal
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'REPORT',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const Divider(),

                  //Space Bottom
                  const SizedBox(height: 80),
                ],
              ),
            ),

            //Round Buttons, need to be on top of the stack, permanent
            Column(
              children: [
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Cross button
                      ElevatedButton(
                        onPressed: () {
                          widget.onCrossButtonPressed(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade50,
                          elevation: 4,
                          shadowColor: Colors.grey.withOpacity(0.3),
                          shape: const CircleBorder(),
                        ),
                        child: SizedBox(
                          width: 55.0,
                          height: 55.0,
                          child: Icon(Icons.clear,
                              color: Colors.red.shade400, size: 38.0),
                        ),
                      ),

                      //const SizedBox(width: 10),

                      //Heart Button
                      ElevatedButton(
                        onPressed: () {
                          widget.onHeartButtonPressed(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade50,
                          elevation: 4,
                          shadowColor: Colors.grey.withOpacity(0.3),
                          shape: const CircleBorder(),
                        ),
                        child: SizedBox(
                          width: 55.0,
                          height: 55.0,
                          child: Icon(Icons.favorite,
                              color: Colors.green.shade400, size: 34.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
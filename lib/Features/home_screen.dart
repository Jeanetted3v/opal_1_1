import 'package:flutter/material.dart';
import '../Common/utils/colors.dart';
import '../Common/page_constants.dart';


class HomeScreen extends StatefulWidget {
  static const String routeName = '/home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (idx) {
          setState(() {
            pageIdx = idx;
          });
        },
        backgroundColor: backgroundColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: buttonColor,
        unselectedItemColor: Colors.grey.shade300,
        currentIndex: pageIdx,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        items: const [
          //Card Screen
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 35),
            label: 'Home',
          ),

          //Chat Screen
          BottomNavigationBarItem(
            icon: Icon(Icons.wechat_rounded, size: 35),
            label: 'Chat',
          ),

          //Add Opal Screen
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_rounded, size: 35),
            label: 'Add Opal',
          ),

          //Search Screen
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 35),
            label: 'Search',
          ),

          //Profile Screen
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 35),
            label: 'Profile',
          ),
        ],
      ),
      body: pages[pageIdx],
    );
  }
}
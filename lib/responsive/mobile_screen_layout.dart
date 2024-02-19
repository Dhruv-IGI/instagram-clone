import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/add_post_screen.dart';
import '../screens/favourite_Screen.dart';
import '../screens/feed_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';
import '../utils/colors.dart';
import '../utils/global_variables.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {

  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: [
          const FeedScreen(),
          const SearchScreen(),
          const AddPostScreen(),
          const FavouriteScreen(),
          ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
        ],
      ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: CupertinoTabBar(
              onTap: navigationTapped,
              backgroundColor: mobileBackgroundColor,
              activeColor: primaryColor,
              items: [
            BottomNavigationBarItem(icon: Icon(Icons.home, color: _page == 0 ? primaryColor : secondaryColor,), label: '', ),
            BottomNavigationBarItem(icon: Icon(Icons.search, color: _page == 1 ? primaryColor : secondaryColor,), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.add_box, color: _page == 2 ? primaryColor : secondaryColor,), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_border, color: _page == 3 ? primaryColor : secondaryColor,), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.person, color: _page == 4 ? primaryColor : secondaryColor,), label: ''),
          ]),
        ),
    );
  }

}

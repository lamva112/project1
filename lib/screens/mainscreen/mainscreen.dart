import 'package:flutter/material.dart';
import 'package:project1/utils/colors.dart';
import 'package:provider/provider.dart';

import '../../post/feed_screen.dart';
import '../../provider/user_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await _userProvider.refreshUser();
  }

  int index = 0;

  final screeen = [
    Center(
      child: Text(
        'My pet screen',
        style: TextStyle(fontSize: 72),
      ),
    ),
    Center(
      child: Text(
        'shop screen',
        style: TextStyle(fontSize: 72),
      ),
    ),
    FeedScreen(),
    Center(
      child: Text(
        'Messeger screen',
        style: TextStyle(fontSize: 72),
      ),
    ),
    Center(
      child: Text(
        'Profile',
        style: TextStyle(fontSize: 72),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        body: screeen[index],
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(indicatorColor: AppColors.red),
          child: NavigationBar(
              height: 83,
              backgroundColor: Color(0xFFf1f5fb),
              selectedIndex: index,
              onDestinationSelected: (index) =>
                  setState(() => this.index = index),
              destinations: [
                NavigationDestination(
                    icon: Icon(Icons.pets_outlined), label: 'My pet'),
                NavigationDestination(
                    icon: Icon(Icons.sell_outlined), label: 'Market'),
                NavigationDestination(
                    icon: Icon(Icons.feed_outlined), label: 'My feed'),
                NavigationDestination(
                    icon: Icon(Icons.message_outlined), label: 'mes'),
                NavigationDestination(
                    icon: Icon(Icons.person_outlined), label: 'profile'),
              ]),
        ),
      );
}

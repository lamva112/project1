import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project1/chat/chatscreen.dart';
import 'package:project1/provider/pet_provider.dart';
import 'package:project1/resources/cloud_data_management.dart';
import 'package:project1/screens/pet/petscreen.dart';
import 'package:project1/utils/colors.dart';
import 'package:provider/provider.dart';

import '../../chat/ChatRoom.dart';
import '../../post/feed_screen.dart';
import '../../provider/user_provider.dart';
import '../profile/profile_screen.dart';

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

    // AddPetData();
  }

  addData() async {
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await _userProvider.refreshUser();
  }

  int index = 0;

  final screeen = [
    const FeedScreen(),
    const Center(
      child: Text(
        'shop screen',
        style: TextStyle(fontSize: 72),
      ),
    ),
    PetScreen(),
    messsageScreen(
      uid: FirebaseAuth.instance.currentUser!.uid.toString(),
    ),
    ProfileScreen(
      uid: FirebaseAuth.instance.currentUser!.email.toString(),
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        body: screeen[index],
        bottomNavigationBar: NavigationBarTheme(
          data: const NavigationBarThemeData(indicatorColor: AppColors.red),
          child: NavigationBar(
              height: 83,
              backgroundColor: const Color(0xFFf1f5fb),
              selectedIndex: index,
              onDestinationSelected: (index) =>
                  setState(() => this.index = index),
              destinations: const [
                NavigationDestination(
                    icon: Icon(Icons.feed_outlined), label: 'My feed'),
                NavigationDestination(
                    icon: Icon(Icons.sell_outlined), label: 'Market'),
                NavigationDestination(icon: Icon(Icons.pets), label: 'My pet'),
                NavigationDestination(
                    icon: Icon(Icons.message_outlined), label: 'mes'),
                NavigationDestination(
                    icon: Icon(Icons.person_outlined), label: 'profile'),
              ]),
        ),
      );
}

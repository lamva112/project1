import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project1/provider/user_provider.dart';
import 'package:project1/screens/authentication/login/login.dart';
import 'package:project1/screens/onboardings/onboardingWrapper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

int initScreen = 0;

Future<void> main() async {
  WidgetsFlutterBinding();
  await Firebase.initializeApp();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen = (preferences.getInt('initScreen') ?? 0);
  await preferences.setInt('initScreen', 1);
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Fresh',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          dialogBackgroundColor: Colors.white,
          primarySwatch: Colors.grey,
          cardColor: Colors.white70,
          accentColor: Colors.white,
        ),
        initialRoute: initScreen == 0 ? 'signin' : 'onboarding',
        routes: {
          'onboarding': (context) => onboardingWrapper(),
          'signin': (context) => LoginScreen(),
        },
      ),
    );
  }
}

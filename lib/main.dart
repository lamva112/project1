import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project1/provider/pet_provider.dart';
import 'package:project1/provider/user_provider.dart';
import 'package:project1/screens/authentication/login/login.dart';
import 'package:project1/screens/onboardings/onboardingWrapper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

int initScreen = 0;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        ChangeNotifierProvider(
          create: (_) => PetProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Fresh',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          dialogBackgroundColor: Colors.white,
          cardColor: Colors.white70,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
              .copyWith(secondary: Colors.white),
        ),
        initialRoute: initScreen == 0 ? 'signin' : 'onboarding',
        routes: {
          'onboarding': (context) => const onboardingWrapper(),
          'signin': (context) => const LoginScreen(),
        },
      ),
    );
  }
}

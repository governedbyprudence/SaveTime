import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:savetime/core/presentation/routes/mainpage.dart';
import 'package:savetime/core/presentation/routes/splash.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Save Time',
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.iOS:OpenUpwardsPageTransitionsBuilder(),
            TargetPlatform.android:OpenUpwardsPageTransitionsBuilder()
          }
        ),
        primarySwatch: Colors.deepOrange,
      ),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName:(context)=>const SplashScreen(),
        MainPage.routeName:(context)=>const MainPage()
      },
    );
  }
}

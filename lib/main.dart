import 'package:flutter/material.dart';
import 'package:savetime/config.dart';
import 'package:savetime/core/presentation/routes/mainpage.dart';
import 'package:savetime/core/presentation/routes/splash.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/presentation/routes/qrScanPage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Supabase.initialize(url: supabaseUrl, anonKey: supabaseSecretKey);
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
        MainPage.routeName:(context)=>const MainPage(),
        QRScanPage.routeName:(context)=>const QRScanPage()
      },
    );
  }
}

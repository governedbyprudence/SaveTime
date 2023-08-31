import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  static const routeName = "/main";
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Widget> widgetList = const [QRListPage(),ProfilePage()];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetList[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index){
          setState(() {
            _currentIndex = 0;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person),label: "Person"),

        ],
      ),
    );
  }
}

class QRListPage extends StatefulWidget {
  const QRListPage({Key? key}) : super(key: key);

  @override
  State<QRListPage> createState() => _QRListPageState();
}

class _QRListPageState extends State<QRListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("List"),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

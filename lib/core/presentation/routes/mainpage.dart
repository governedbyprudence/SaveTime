import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savetime/core/bloc/cacheBloc/cacheBloc.dart';
import 'package:savetime/core/bloc/cacheBloc/cacheEvent.dart';
import 'package:savetime/core/bloc/cacheBloc/cacheState.dart';
import 'package:savetime/core/presentation/routes/qrScanPage.dart';

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
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
              Navigator.pushNamed(context, QRScanPage.routeName);
          }, icon: const Icon(Icons.qr_code))
        ],
      ),
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
    return BlocProvider(create: (_)=>CacheBloc()..add(CacheGetItemsEvent()),
      child: BlocConsumer<CacheBloc,CacheState>(
        builder: (context,state){
          if(state is CacheItemNotPresentState){
            return Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.topCenter,
              child: const Text("No QR codes saved !",
                style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
            );
          }
          return Container(child: const Text("hehe"),);
        },
        listener: (context,state){

        },
      ),
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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savetime/core/bloc/cacheBloc/cacheBloc.dart';
import 'package:savetime/core/bloc/cacheBloc/cacheEvent.dart';
import 'package:savetime/core/bloc/cacheBloc/cacheState.dart';
import 'package:savetime/core/models/qr.dart';
import 'package:savetime/core/presentation/routes/qrScanPage.dart';
import 'package:savetime/core/presentation/routes/qrViewPage.dart';

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
            _currentIndex = index;
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

  void _deleteAllItems(BuildContext mainContext){
    showDialog(context: mainContext, builder: (context){
      return Dialog(
        child: Container(
          height: 120,
          padding:const EdgeInsets.all(20),
          alignment: Alignment.center,
          child: Column(
            children: [
              const Text("Are you sure to delete all items ?"),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: (){
                      Navigator.pop(context);
                  }, child: const Text("Cancel")),
                  const SizedBox(width: 20,),
                  ElevatedButton(onPressed: (){
                    mainContext.read<CacheBloc>().add(CacheDeleteItemEvent());
                    Navigator.pop(context);
                  }, child: const Text("Delete"))
                ],
              )
            ],
          ),
        ),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_)=>CacheBloc()..add(CacheGetItemsEvent()),
      child: BlocConsumer<CacheBloc,CacheState>(
        builder: (context,state){
          if(state is CacheInitialState){
            return Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          }
          if(state is CacheItemNotPresentState){
            return Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(onPressed: (){
                    Navigator.pushNamed(context, QRScanPage.routeName).then((value) => context.read<CacheBloc>().add(CacheGetItemsEvent()));
                  }, icon: const Icon(Icons.qr_code))
                ],
              ),
              body: Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.topCenter,
                child: const Text("No QR codes saved !",
                  style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
              ),
            );
          }
          List<QRModel> data = (state as CacheItemPresentState).items;
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(onPressed: (){
                  _deleteAllItems(context);
                }, icon: const Icon(Icons.delete)),
                IconButton(onPressed: (){
                  Navigator.pushNamed(context, QRScanPage.routeName).then((value) => context.read<CacheBloc>().add(CacheGetItemsEvent()));
                }, icon: const Icon(Icons.qr_code))
              ],
            ),
            body: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context,index)=>SingleQRTile(qrModel: data[index])),
          );
        },
        listener: (context,state){

            },
          ),
    );
  }
}

class SingleQRTile extends StatelessWidget {
  final QRModel qrModel;
  const SingleQRTile({super.key,required this.qrModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow:  [
            BoxShadow(
                color: Colors.grey[200]!,
                offset: const Offset(0,1),
                spreadRadius: 2,
                blurRadius: 3
            )
          ]
      ),
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: Material(
        child: InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>QRViewPage(qrModel: qrModel)));
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:[
                    const CircleAvatar(child: Text("Q"),),
                    const SizedBox(width: 20,),
                    Text(qrModel.tag,style: const TextStyle(fontWeight: FontWeight.w500),),
                  ],
                ),
                IconButton(onPressed: (){
                    context.read<CacheBloc>().add(CacheDeleteItemByTagEvent(tag: qrModel.tag));
                }, icon: const Icon(Icons.delete))
              ],
            ),
          ),
        ),
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

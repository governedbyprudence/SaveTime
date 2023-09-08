import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:savetime/core/bloc/cacheBloc/cacheBloc.dart';
import 'package:savetime/core/bloc/cacheBloc/cacheEvent.dart';
import 'package:savetime/core/bloc/cacheBloc/cacheState.dart';
import 'package:savetime/core/models/qr.dart';
import 'package:savetime/core/presentation/routes/qrScanPage.dart';
import 'package:savetime/core/presentation/routes/qrViewPage.dart';
import 'package:savetime/core/utils/logger.dart';

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
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      //   elevation: 0,
      //   currentIndex: _currentIndex,
      //   onTap: (index){
      //     setState(() {
      //       _currentIndex = index;
      //     });
      //   },
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
      //     BottomNavigationBarItem(icon: Icon(Icons.person),label: "Person"),
      //
      //   ],
      // ),
    );
  }
}

class QRListPage extends StatefulWidget {
  const QRListPage({Key? key}) : super(key: key);

  @override
  State<QRListPage> createState() => _QRListPageState();
}

class _QRListPageState extends State<QRListPage> with SingleTickerProviderStateMixin{
  double _headerContainerHeight = 0;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(milliseconds: 100),(){
        setState(() {
          _headerContainerHeight = 150;
        });
      });
    });
  }
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
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(
                elevation: 0,
                actions: [
                  IconButton(onPressed: (){
                    Navigator.pushNamed(context, QRScanPage.routeName).then((value) => context.read<CacheBloc>().add(CacheGetItemsEvent()));
                  }, icon: const Icon(Icons.qr_code))
                ],
              ),
              body: Stack(
                children: [
                  AnimatedContainer(
                    decoration:BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(200),bottomLeft: Radius.circular(200))
                    ),
                    height: _headerContainerHeight, duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut,
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.topCenter,
                    child: const Text("No QR codes saved !",
                      style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16,color: Colors.white),),
                  ),
                ],
              ),
            );
          }
          List<QRModel> data = (state as CacheItemPresentState).items;
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: CustomScrollView(

              slivers: [
                SliverAppBar(
                  floating: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  centerTitle: true,
                  title:  Text("Your saved QRs",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14),),
                  elevation: 0,
                  actions: [
                    IconButton(onPressed: (){
                      _deleteAllItems(context);
                    }, icon:  Icon(Icons.delete,color: Theme.of(context).primaryColor,)),
                    IconButton(onPressed: (){
                      Navigator.pushNamed(context, QRScanPage.routeName).then((value) => context.read<CacheBloc>().add(CacheGetItemsEvent()));
                    },icon: Icon(Icons.qr_code,color: Theme.of(context).primaryColor,))
                  ],
                ),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (context,index){
                    return SingleQRTile(qrModel: data[index]);
                  },
                  childCount: data.length,
                ))
              ],
            ),
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
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).primaryColor,
        child: InkWell(

          splashColor: Colors.black,
            borderRadius: BorderRadius.circular(20),
            onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>QRViewPage(qrModel: qrModel)));
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:[
                    const Icon(Icons.qr_code_2_outlined,color: Colors.white,size: 50,),
                    const SizedBox(width: 20,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(qrModel.tag,style: const TextStyle(fontWeight: FontWeight.w800,color: Colors.white,fontSize: 26),),
                        const SizedBox(height: 5,),
                        Text(DateFormat("dd MMMM yy").format(qrModel.dateTime),style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 10,color: Colors.white,),),
                      ],
                    )
                  ],
                ),
                IconButton(onPressed: (){
                    context.read<CacheBloc>().add(CacheDeleteItemByTagEvent(tag: qrModel.tag));
                }, icon: const Icon(Icons.delete,color: Colors.white,))
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

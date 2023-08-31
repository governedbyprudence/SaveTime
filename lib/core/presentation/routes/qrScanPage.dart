import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanPage extends StatefulWidget {
  static const routeName = "/qrScan";
  const QRScanPage({Key? key}) : super(key: key);

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrController;
  ScrollController listScrollController = ScrollController();
  List<TextEditingController> textControllers =[];
  List<String> qrData = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Scan QR codes"),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(30),
          child: ElevatedButton(
            onPressed: _save,
            child:const Text("Save"),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
             Expanded(child: _qrScanner()),
              Expanded(child: _list())
            ],
          ),
        ),
      ),
    );
  }
  void _save(){
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        content:Text("Data saved",style: TextStyle(color: Colors.grey[900]),)));
  }
  void _onQRViewCreated(QRViewController controller) {
    qrController = controller;
    controller.scannedDataStream.listen((scanData) async{
      if(scanData.code!=null){
        if(!qrData.contains(scanData.code)){
          setState(() {
            qrData.add(scanData.code!);
            textControllers.add(TextEditingController());
            listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: const Duration(seconds: 2),
              curve: Curves.fastOutSlowIn,
            );
          });
        }
        await controller.pauseCamera();
        Future.delayed(
          const Duration(seconds: 4),
            (){
              controller.resumeCamera();
            }
        );
      }
    });
  }

  Widget _qrScanner(){
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated
      ),
    );
  }
  Widget _list(){
    return ListView.builder(
        controller: listScrollController,
        itemCount: qrData.length,
        itemBuilder: (context,index)=>Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                offset: Offset(0,1),
                color: Colors.grey,
                spreadRadius: 1,
                blurRadius: 1
              )
            ]
          ),
          margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text((index+1).toString()),
                  const SizedBox(width: 20,),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextFormField(
                        controller: textControllers[index],
                        decoration: InputDecoration(
                            labelText: "Enter Label for QR",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)
                          )
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 20,),
                  IconButton(onPressed: (){
                    setState(() {
                      qrData.removeAt(index);
                    });
                  },icon: const Icon(Icons.delete),),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Theme(
                      data: ThemeData().copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(title: const Text("Scanned Data"),

                        children: [
                        Container(
                            alignment:Alignment.centerLeft,
                            child: Text(qrData[index])),
                      ],),
                    ),
                  ),
                ],
              )

            ],
          ),
        ));
  }
}

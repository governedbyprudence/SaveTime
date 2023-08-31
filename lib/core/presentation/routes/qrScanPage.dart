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
  List<String> qrData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Scan QR codes"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Expanded(child: _qrScanner()),
            Expanded(flex: 4,child: _list())
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    qrController = controller;
    controller.scannedDataStream.listen((scanData) {
      if(scanData.code!=null){
        setState(() {
          qrData.add(scanData.code!);
        });
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
        itemCount: qrData.length,
        itemBuilder: (context,index)=>Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(child: TextFormField()),
              Expanded(child: Text(qrData[index])),
              Expanded(child: IconButton(onPressed: (){
                  setState(() {
                    qrData.removeAt(index);
                  });
              },icon: const Icon(Icons.delete),)),
            ],
          ),
        ));
  }
}

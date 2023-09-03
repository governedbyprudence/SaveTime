import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:savetime/core/models/qr.dart';

class QRViewPage extends StatefulWidget {
  final QRModel qrModel;
  const QRViewPage({Key? key,required this.qrModel}) : super(key: key);

  @override
  State<QRViewPage> createState() => _QRViewPageState();
}

class _QRViewPageState extends State<QRViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          padding:const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[200]!,
                        offset: const Offset(0,1),
                        spreadRadius: 2,
                        blurRadius: 3
                      )
                    ]
                  ),
                  padding: const EdgeInsets.all(20),
                  child: QrImage(
                    data: widget.qrModel.qrData,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                  child: Text(widget.qrModel.tag,style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                ),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                    child: Text(widget.qrModel.dateTime.toString().substring(0,10)),
                ),
              ],
            ),
          ),
        ),
    );
  }
}

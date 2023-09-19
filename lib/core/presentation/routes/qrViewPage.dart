import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:savetime/core/models/qr.dart';
import 'package:savetime/core/utils/logger.dart';
import 'package:savetime/core/utils/notification_service.dart';

class QRViewPage extends StatefulWidget {
  final QRModel qrModel;
  const QRViewPage({Key? key,required this.qrModel}) : super(key: key);

  @override
  State<QRViewPage> createState() => _QRViewPageState();
}

class _QRViewPageState extends State<QRViewPage> {

  final GlobalKey _imageSaveKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    NotificationService.isAllowed();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        iconTheme: IconThemeData(color: Theme.of(context).scaffoldBackgroundColor),
        actions: [
          IconButton(onPressed: (){
            _saveToGallery();
          }, icon: const Icon(Icons.save))
        ],
      ),
      body: DefaultTextStyle(
        style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
        child: Container(
            height: double.infinity,
            width: double.infinity,
            padding:const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RepaintBoundary(
                    key: _imageSaveKey,
                    child: Container(
                      margin: const EdgeInsets.all(20),
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
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                        child: Text(widget.qrModel.tag,style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 25),),
                      ),
                      const Text("------"),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                        child: Text(DateFormat("dd MMMM yy").format(widget.qrModel.dateTime),style: const TextStyle(fontSize: 14),),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: ()async{
                       DateTime? date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(3000));
                      if(date!=null){
                        if(context.mounted){TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime:TimeOfDay.now());
                        if(pickedTime!=null){
                              NotificationService.createScheduledNotification(DateTime(date.year,date.month,date.day,pickedTime.hour,pickedTime.minute), "Reminder for ${widget.qrModel.tag}");
                        }
                        }
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(20),
                      child: Row(
                        children: const [
                          Icon(Icons.notifications,size: 40,),
                          Text("Set a reminder",style: TextStyle(fontSize: 18),)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
      ),
    );
  }

  Future<void> _saveToGallery()async{
      RenderRepaintBoundary repaintBoundary = _imageSaveKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await repaintBoundary.toImage();
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List uint8List = byteData!.buffer.asUint8List();
      await ImageGallerySaver.saveImage(uint8List);
      if(context.mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Saved to gallery")));
  }
}

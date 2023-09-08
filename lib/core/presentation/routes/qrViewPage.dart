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

class QRViewPage extends StatefulWidget {
  final QRModel qrModel;
  const QRViewPage({Key? key,required this.qrModel}) : super(key: key);

  @override
  State<QRViewPage> createState() => _QRViewPageState();
}

class _QRViewPageState extends State<QRViewPage> {

  final GlobalKey _imageSaveKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[100],
        iconTheme: const IconThemeData(color: Colors.deepOrange),
        actions: [
          IconButton(onPressed: (){
            _saveToGallery();
          }, icon: const Icon(Icons.save))
        ],
      ),
      body: Container(
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                   Column(
                     children: [
                       Container(
                         padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                         child:const Text("Tag",style:  TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                       ),
                       Container(
                         padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                         child: Text(widget.qrModel.tag,style: const TextStyle(fontWeight: FontWeight.w600,),),
                       ),
                     ],
                   ),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                          child:const  Text("Created on",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                          child: Text(DateFormat("dd MMMM yy").format(widget.qrModel.dateTime).toString()),
                        ),
                      ],
                    )
                  ],
                )
              ],
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

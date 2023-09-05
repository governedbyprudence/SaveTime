import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
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
      appBar: AppBar(),
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                  child: Text(widget.qrModel.tag,style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                ),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                    child: Text(widget.qrModel.dateTime.toString().substring(0,10)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                  child: ElevatedButton(
                    onPressed: ()async{
                            try{
                              await _saveToGallery();
                              if(context.mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Saved successfully")));
                            }catch(e){
                              CustomLogger.error(e);
                            }
                    },
                    child: const Text("Save to Gallery"),
                  ),
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
  }
}

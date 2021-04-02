import 'dart:io';

import 'package:app/src/utils/notification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../widgets/app_bar.dart';
import '../../utils/permissions.dart';
import '../../utils/night_mode.dart';

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  Barcode result;
  QRViewController controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool nightMode = isNightMode();
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryVariant,
      appBar: appBar(
        backgroundColor: Theme.of(context).colorScheme.primaryVariant, 
        iconColor: nightMode? Colors.white: Colors.black
      ),
      body: Container(
        alignment: Alignment.topCenter,
        width: size.width,
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: QRView(
                key: qrKey,
                onQRViewCreated: scanQRCode,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scanQRCode(QRViewController controller) async {
    try {
      await cameraPermission();
      
      setState(() {
        this.controller = controller;
      });

      controller.scannedDataStream.listen((scanData) { 
        setState(() {
          dialog(
            context,
            message: "Data: ${scanData.code}",
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName("/home"));
            }
          );
        });
      });
    } on Exception catch(e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
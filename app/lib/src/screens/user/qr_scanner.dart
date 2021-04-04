import 'dart:async';
import 'dart:io';

import 'package:app/src/screens/services/store_vet/store_vet_detail.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../widgets/app_bar.dart';
import '../../utils/permissions.dart';
import '../../utils/night_mode.dart';
import '../../models/store_vet.dart' as VetModel;

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  String qrMessage;
  bool foundStoreVet = false;
  VetModel.StoreVet storeVet;
  QRViewController controller;
  List vetList;

  initState() {
    super.initState();
    vetList = [
      VetModel.StoreVet(
        "1",
        "Exotic Pet",
        "Email@vet.com",
        {
          "Monday": ["1:00", "2:00"],
          "Tuesday": ["1:00", "2:00"],
          "Wednesday": ["1:00", "2:00"],
          "Thursday": ["1:00", "2:00"],
          "Friday": ["1:00", "2:00"],
          "Weekend": ["1:00", "2:00"],
        },
        "123123123", 
        [
          {"lat": 4.6365921453154995, "lng": -74.09680067805952},
          {"lat": 4.634153971749186, "lng": -74.09474074161847},
          {"lat": 4.65310306395165, "lng": -74.11152064054464}
        ]
      ),
      VetModel.StoreVet(
        "2",
        "New Med Vet",
        "Email@vet.com",
        {
          "Lunes": ["1:00", "2:00"],
          "Martes": ["1:00", "2:00"],
        },
        "123123123", 
        [
          {"lat": 4.6365921453154995, "lng": -74.09680067805952},
          {"lat": 4.634153971749186, "lng": -74.09474074161847},
          {"lat": 4.65310306395165, "lng": -74.11152064054464}
        ]
      ),
      VetModel.StoreVet(
        "3",
        "The Golden Century",
        "Email@vet.com",
        {
          "Lunes": ["1:00", "2:00"],
          "Martes": ["1:00", "2:00"],
        },
        "123123123",
        [
          {"lat": 4.6365921453154995, "lng": -74.09680067805952},
          {"lat": 4.634153971749186, "lng": -74.09474074161847},
          {"lat": 4.65310306395165, "lng": -74.11152064054464}
        ]
      ),
      VetModel.StoreVet(
        "4",
        "Country Vet",
        "Email@vet.com",
        {
          "Lunes": ["1:00", "2:00"],
          "Martes": ["1:00", "2:00"],
        },
        "123123123",
        [
          {"lat": 4.6365921453154995, "lng": -74.09680067805952},
          {"lat": 4.634153971749186, "lng": -74.09474074161847},
          {"lat": 4.65310306395165, "lng": -74.11152064054464}
        ]
      ),
    ];
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    final image = AssetImage("assets/icons/snakes.png");
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
            Container(
              height: size.height * 0.5,
              child: QRView(
                key: qrKey,
                onQRViewCreated: scanQRCode,
                overlay: QrScannerOverlayShape(
                  borderColor: Theme.of(context).colorScheme.primaryVariant,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: size.width * 0.7
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: size.height * 0.05),
              child: Text(
                this.qrMessage?? "Scan the QR Code",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: size.height * 0.05),
              child: Visibility(
                visible: this.foundStoreVet,
                child: this.storeVet != null? Card(
                  color: nightMode? Colors.white60: Colors.black38,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: image,
                      backgroundColor: Colors.white,
                      maxRadius: size.height * 0.03,
                    ),
                    title: Text(
                      this.storeVet.name,
                      style: Theme.of(context).textTheme.headline6.copyWith(
                        color: nightMode? Colors.white: Colors.black
                      ),
                    ),
                    onTap: () => Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (_) => StoreVetDetail(this.storeVet)
                      )
                    ),
                  ),
                ): Text("Nada"),
              ),
            )
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
      StreamSubscription<Barcode> scanner;
      scanner = controller.scannedDataStream.listen((scanData) {
        setState(() {
          this.storeVet = findStoreVet(scanData.code);
          this.foundStoreVet = this.storeVet != null;
          this.qrMessage = this.foundStoreVet? "Found!": "No Results :(";
        });
        scanner.cancel();
      });
    } catch(e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
      );
    }
  }

  VetModel.StoreVet findStoreVet(String id) {
    for (VetModel.StoreVet storeVet in this.vetList) {
      if (id == storeVet.id) {
        return storeVet;
      }
    }
    return null;
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
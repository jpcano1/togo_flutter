import 'dart:async';
import 'dart:io';

import 'package:app/src/bloc/bloc_provider.dart';
import 'package:app/src/bloc/blocs/qr_scanner/qr_scanner_bloc.dart';
import 'package:app/src/screens/services/store_vet/store_vet_detail.dart';
import 'package:app/src/widgets/spinner.dart';
import 'package:app/src/widgets/toast_alert.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../widgets/app_bar.dart';
import '../../utils/permissions.dart';
import '../../utils/night_mode.dart';
import '../../models/store_vet.dart' as VetModel;

class QRScannerScreen extends StatefulWidget {

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  QRScannerScreen({this.analytics, this.observer});

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  String qrMessage;
  bool messageRead = false;
  String message = "";
  QRViewController controller;

  Future <void> _setCurrentScreen() async{
    await widget.analytics.setCurrentScreen(screenName: "QR Scanner");
  }

  initState() {
    super.initState();
    _setCurrentScreen();
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
    final bloc = Provider.of<QRScannerBloc>(context);
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
                visible: this.messageRead,
                child: FutureBuilder(
                  future: bloc.readStoreVet(this.message),
                  builder: (futureContext, futureSnapshot) {
                    if (futureSnapshot.connectionState == ConnectionState.done) {
                      return StreamBuilder(
                        stream: bloc.vetStoreOut,
                        builder: (streamContext, streamSnapshot) {
                          if (streamSnapshot.hasData) {
                            var image;
                            VetModel.StoreVet storeVet = streamSnapshot.data;

                            if (storeVet.imagePath.isNotEmpty) {
                              image = NetworkImage(storeVet.imagePath);
                            } else {
                              image = AssetImage("assets/icons/snakes.png");
                            }

                            return Card(
                              elevation: 3.0,
                              color: Theme.of(context).colorScheme.primaryVariant,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Theme.of(context).colorScheme.primaryVariant,
                                  backgroundImage: image,
                                ),
                                title: Text(
                                  storeVet.name,
                                  style: Theme.of(context).textTheme.headline6.copyWith(
                                    color: Colors.white
                                  ),
                                ),
                                onTap: () => Navigator.pushReplacement(
                                  context, 
                                  MaterialPageRoute(
                                    builder: (_) => StoreVetDetail(storeVet)
                                  )
                                ),
                              ),
                            );
                          }
                          if (streamSnapshot.hasError) {
                            return Center(
                              child: Text(
                                streamSnapshot.error,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            );
                          }
                          return Center(
                            child: LoadingSpinner(),
                          );
                        },
                      );
                    }
                    if (futureSnapshot.hasError) {
                      return Center(
                        child: Text(futureSnapshot.error),
                      );
                    }
                    return Center(
                      child: LoadingSpinner(),
                    );
                  },
                )
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
          this.messageRead = true;
          this.message = scanData.code;
          // this.storeVet = findStoreVet(scanData.code);
          // this.foundStoreVet = this.storeVet != null;
          // this.qrMessage = this.foundStoreVet? "Found!": "No Results :(";
        });
        scanner.cancel();
      });
    } catch(e) {
      showToast(e.toString(), context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }
}

// this.storeVet != null? Card(
//                   color: nightMode? Colors.white60: Colors.black38,
//                   child: ListTile(
//                     leading: CircleAvatar(
//                       backgroundImage: image,
//                       backgroundColor: Colors.white,
//                       maxRadius: size.height * 0.03,
//                     ),
//                     title: Text(
//                       this.storeVet.name,
//                     ),
//                   ),
//                 ): Text("Nothing"),
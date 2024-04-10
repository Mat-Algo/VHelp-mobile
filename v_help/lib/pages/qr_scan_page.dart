import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:v_help/pages/laundry_form.dart';
import 'package:v_help/pages/updateStatusPage.dart';
import 'package:v_help/pages/user_laundry_data.dart';

class QRScanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isDialogShowing = false; // Ensure this flag is class-level
  bool isNavigating = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
  this.controller = controller;
  controller.scannedDataStream.listen((scanData) async {
    final String? code = scanData.code;
    if (code != null && !isDialogShowing && !isNavigating) {
      final userDetails = json.decode(code);
      final String regno = userDetails['regno'];

      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('LaundryStore')
          .where('regno', isEqualTo: regno)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot doc = querySnapshot.docs.first;
        if (doc['status'] == true) {
          // Navigate to UpdateStatusPage
          isNavigating = true;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UpdateStatusPage(onUpdate: () {
              FirebaseFirestore.instance.collection('LaundryStore').doc(doc.id).update({'status': true})
                  .then((value) => Navigator.of(context).pop()) // Pop UpdateStatusPage
                  .catchError((error) => print("Failed to update status: $error"));
            })),
          ).then((_) {
            isNavigating = false;
            controller.resumeCamera();
          });
        } else {
          // Proceed with LaundryFormPage
          isNavigating = true;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LaundryFormPage(scannedData: code)),
          ).then((_) {
            isNavigating = false;
            controller.resumeCamera();
          });
        }
      } else {
        // If regno doesn't exist, proceed with LaundryFormPage
        isNavigating = true;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LaundryFormPage(scannedData: code)),
        ).then((_) {
          isNavigating = false;
          controller.resumeCamera();
        });
      }
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 250,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              // Consumer listens for changes and rebuilds the Text widget accordingly
              child: Consumer<UserLaundryData>(
                builder: (context, userData, child) {
                  return Text(
                    // Displaying the scanned QR data or a placeholder
                    userData.qrDataRaw ?? 'Scan a QR Code',
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

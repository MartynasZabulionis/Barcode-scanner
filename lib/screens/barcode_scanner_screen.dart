import 'dart:async';

import 'package:barcode_scanner_app/dialogs/barcode_result_dialog.dart';
import 'package:barcode_scanner_app/dialogs/close_app_dialog.dart';
import 'package:barcode_scanner_app/dialogs/interrruption_dialog.dart';
import 'package:barcode_scanner_app/services/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'scan_results_screen.dart';

class BarcodeScannerScreen extends StatefulWidget {
  @override
  _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen>
    with WidgetsBindingObserver {
  final qrKey = GlobalKey();

  bool paused = false;
  bool isTorchOn = false;
  bool canShowInterruptionDialog = true;
  QRViewController? controller;

  Timer? timer;

  void onBarcodeDetected(Barcode barcode) async {
    if (paused) return;
    canShowInterruptionDialog = false;
    pauseCamera();
    resetTimer();
    (await PrefsService.instance).saveCode(barcode.code);
    await BarcodeResultDialog.show(context, barcode.code);
    resumeCamera();
    canShowInterruptionDialog = true;
  }

  void pauseCamera() {
    paused = true;
    controller!.stopCamera();
  }

  void resumeCamera() {
    paused = false;
    controller!.resumeCamera();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    resetTimer();
  }

  void resetTimer() {
    timer?.cancel();
    timer = Timer(
      const Duration(minutes: 20),
      () async {
        if (paused) {
          resetTimer();
          return;
        }
        canShowInterruptionDialog = false;
        pauseCamera();
        if (await CloseAppDialog.show(context) == false) {
          resumeCamera();
          resetTimer();
          canShowInterruptionDialog = true;
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      Future.delayed(
        const Duration(milliseconds: 100),
        () async {
          pauseCamera();
          if (canShowInterruptionDialog) {
            canShowInterruptionDialog = false;
            await InterruptionDialog.show(context);
            resumeCamera();
            canShowInterruptionDialog = true;
          }
        },
      );
    }
  }

  void onFabPressed() async {
    canShowInterruptionDialog = false;
    pauseCamera();
    timer?.cancel();
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return ScanResultsScreen();
      },
    ));
    resumeCamera();
    resetTimer();
    canShowInterruptionDialog = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan barcode'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onFabPressed,
        label: const Text('Check results of last 10 scans'),
      ),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            formatsAllowed: const [BarcodeFormat.code128],
            overlay: QrScannerOverlayShape(),
            onQRViewCreated: (controller) {
              this.controller = controller;
              controller.scannedDataStream.listen(onBarcodeDetected);
            },
          ),
          Positioned(
            left: 20,
            bottom: 20,
            child: StatefulBuilder(
              builder: (context, setState) {
                return IconButton(
                  iconSize: 40,
                  icon: Icon(
                    isTorchOn ? Icons.lightbulb : Icons.lightbulb_outline,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    isTorchOn = !isTorchOn;
                    controller?.toggleFlash();
                    setState(() {});
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

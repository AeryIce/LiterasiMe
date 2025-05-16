import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final MobileScannerController cameraController = MobileScannerController();

  @override
  void dispose() {
    cameraController.dispose(); // 🔥 Pastikan kamera dimatikan
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan ISBN')),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (BarcodeCapture capture) {
          final Barcode barcode = capture.barcodes.first;
          final String? code = barcode.rawValue;

          if (code != null && code.length >= 10) {
            cameraController.stop();
            Navigator.pop(context, code);
          }
        },
      ),
    );
  }
}

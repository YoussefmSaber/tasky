import 'package:flutter/material.dart';

import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:tasky/routes.dart';

class QRScannerPage extends StatelessWidget {
  const QRScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: MobileScanner(
        overlayBuilder: (context, constraints) {
          return QRScannerOverlay(
            borderColor: Colors.red,
            borderWidth: 3,
            overlayColor: Colors.black.withOpacity(0.5),
          );
        },
        onDetect: (BarcodeCapture barcodeCapture) {
          final List<Barcode> barcodes = barcodeCapture.barcodes;

          // Iterate through all detected barcodes
          for (final barcode in barcodes) {
            if (barcode.rawValue != null) {
              final String code = barcode.rawValue!;
              // Navigate with the scanned code
              Navigator.of(context)
                  .popAndPushNamed(RouteGenerator.details, arguments: code);
              break; // Process only the first valid QR code
            }
          }
        },
      ),
    );
  }
}

class QRScannerOverlay extends StatelessWidget {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;

  const QRScannerOverlay({
    super.key,
    required this.borderColor,
    required this.borderWidth,
    required this.overlayColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth * 0.8;
        final double height = constraints.maxHeight * 0.4;

        return Stack(
          children: [
            // Overlay background
            Container(
              color: overlayColor,
            ),
            // Transparent cutout for the scanner
            Align(
              alignment: Alignment.center,
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: borderColor,
                    width: borderWidth,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:tasky/routes.dart';

/// A page that displays a QR code scanner.
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
            overlayColor: Colors.black.withValues(alpha: 0.5),
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

/// A widget that provides an overlay for the QR code scanner.
class QRScannerOverlay extends StatelessWidget {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;

  /// Creates a QRScannerOverlay.
  ///
  /// The [borderColor] parameter specifies the color of the border around the
  /// scanner cutout. The [borderWidth] parameter specifies the width of the
  /// border. The [overlayColor] parameter specifies the color of the overlay
  /// background.
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
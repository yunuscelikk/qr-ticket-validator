import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';

class QrScanScreen extends StatefulWidget {
  final int eventId;

  const QrScanScreen({super.key, required this.eventId});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    returnImage: false,
  );

  bool _isProcessing = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty || barcodes.first.rawValue == null) return;

    final String code = barcodes.first.rawValue!;

    setState(() {
      _isProcessing = true;
    });

    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final result = await eventProvider.checkInParticipant(widget.eventId, code);

    if (!mounted) return;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _buildResultDialog(ctx, result),
    );
    setState(() {
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giriş Kontrol'),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, state, child) {
                return Icon(
                  state.torchState == TorchState.on
                      ? Icons.flash_on
                      : Icons.flash_off,
                  color: Colors.grey[800],
                );
              },
            ),
            onPressed: () => controller.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(controller: controller, onDetect: _onDetect),
          Container(
            decoration: ShapeDecoration(
              shape: QrScannerOverlayShape(
                borderColor: Theme.of(context).primaryColor,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
                overlayColor: Colors.black.withOpacity(0.7),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(32),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                'QR Kodu karenin içine tutun',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultDialog(BuildContext context, Map<String, dynamic> result) {
    final bool success = result['success'];
    final String message = result['message'];
    final participantName = result['participant']?['full_name'] ?? '';

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: success ? Colors.green.shade100 : Colors.red.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              success ? Icons.check_circle : Icons.cancel,
              size: 60,
              color: success ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            success ? 'Giriş Başarılı!' : 'Hata!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: success ? Colors.green.shade800 : Colors.red.shade800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),

          if (success && participantName.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              participantName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: success ? Colors.green : Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Tamam'),
          ),
        ),
      ],
    );
  }
}

// Mobile Scanner Overlay için özel bir sınıf (Kütüphaneden gelmiyorsa manuel eklenir)
// Not: MobileScanner son sürümlerinde overlay built-in gelmeyebilir,
// o yüzden aşağıya manuel ShapeBorder ekliyorum.
// EĞER KÜTÜPHANE HATASI ALIRSAN BUNU KULLAN:
class QrScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  const QrScannerOverlayShape({
    this.borderColor = Colors.red,
    this.borderWidth = 10.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 10.0,
    this.borderLength = 20.0,
    this.cutOutSize = 250.0,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.right, rect.top);
    }

    return getLeftTopPath(rect)
      ..addRect(
        Rect.fromCenter(
          center: rect.center,
          width: cutOutSize,
          height: cutOutSize,
        ),
      )
      ..fillType = PathFillType.evenOdd;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final borderWidthSize = width / 2;
    final height = rect.height;
    final borderOffset = borderWidth / 2;
    final mBorderLength = borderLength > cutOutSize / 2 + borderWidth * 2
        ? borderWidthSize / 2
        : borderLength;
    final mCutOutSize = cutOutSize < width ? cutOutSize : width - borderWidth;

    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final boxPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill;

    final cutOutRect = Rect.fromCenter(
      center: rect.center,
      width: mCutOutSize,
      height: mCutOutSize,
    );

    canvas
      ..saveLayer(rect, backgroundPaint)
      ..drawRect(rect, backgroundPaint)
      ..drawRRect(
        RRect.fromRectAndRadius(cutOutRect, Radius.circular(borderRadius)),
        Paint()..blendMode = BlendMode.clear,
      )
      ..restore();

    final path = Path()
      ..moveTo(cutOutRect.left, cutOutRect.top + mBorderLength)
      ..lineTo(cutOutRect.left, cutOutRect.top + borderRadius)
      ..quadraticBezierTo(
        cutOutRect.left,
        cutOutRect.top,
        cutOutRect.left + borderRadius,
        cutOutRect.top,
      )
      ..lineTo(cutOutRect.left + mBorderLength, cutOutRect.top)
      ..moveTo(cutOutRect.right, cutOutRect.top + mBorderLength)
      ..lineTo(cutOutRect.right, cutOutRect.top + borderRadius)
      ..quadraticBezierTo(
        cutOutRect.right,
        cutOutRect.top,
        cutOutRect.right - borderRadius,
        cutOutRect.top,
      )
      ..lineTo(cutOutRect.right - mBorderLength, cutOutRect.top)
      ..moveTo(cutOutRect.right, cutOutRect.bottom - mBorderLength)
      ..lineTo(cutOutRect.right, cutOutRect.bottom - borderRadius)
      ..quadraticBezierTo(
        cutOutRect.right,
        cutOutRect.bottom,
        cutOutRect.right - borderRadius,
        cutOutRect.bottom,
      )
      ..lineTo(cutOutRect.right - mBorderLength, cutOutRect.bottom)
      ..moveTo(cutOutRect.left, cutOutRect.bottom - mBorderLength)
      ..lineTo(cutOutRect.left, cutOutRect.bottom - borderRadius)
      ..quadraticBezierTo(
        cutOutRect.left,
        cutOutRect.bottom,
        cutOutRect.left + borderRadius,
        cutOutRect.bottom,
      )
      ..lineTo(cutOutRect.left + mBorderLength, cutOutRect.bottom);

    canvas.drawPath(path, borderPaint);
  }

  @override
  ShapeBorder scale(double t) {
    return QrScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
    );
  }
}

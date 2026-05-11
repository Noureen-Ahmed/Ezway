import 'dart:typed_data';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import '../services/data_service.dart';

class AvatarCropScreen extends StatefulWidget {
  final XFile imageFile;

  const AvatarCropScreen({super.key, required this.imageFile});

  @override
  State<AvatarCropScreen> createState() => _AvatarCropScreenState();
}

class _AvatarCropScreenState extends State<AvatarCropScreen>
    with SingleTickerProviderStateMixin {
  Uint8List? _imageBytes;
  int? _origWidth, _origHeight;
  final TransformationController _transformationController =
      TransformationController();

  double? _cropRadius;
  Size? _viewportSize;
  bool _initialized = false;
  bool _isSaving = false;

  // Tracked scale for the slider
  double _sliderScale = 1.0;
  static const double _minScale = 1.0;
  static const double _maxScale = 5.0;

  @override
  void initState() {
    super.initState();
    _loadImage();
    _transformationController.addListener(_onTransformChanged);
  }

  @override
  void dispose() {
    _transformationController.removeListener(_onTransformChanged);
    _transformationController.dispose();
    super.dispose();
  }

  void _onTransformChanged() {
    final s = _transformationController.value
        .getMaxScaleOnAxis()
        .clamp(_minScale, _maxScale);
    if ((s - _sliderScale).abs() > 0.01) {
      setState(() => _sliderScale = s);
    }
  }

  Future<void> _loadImage() async {
    try {
      final bytes = await widget.imageFile.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image != null && mounted) {
        setState(() {
          _imageBytes = bytes;
          _origWidth = image.width;
          _origHeight = image.height;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to load image: $e'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  void _initialize() {
    if (_initialized || _origWidth == null || _origHeight == null) return;
    final size = context.size;
    if (size == null || size.isEmpty) return;

    final vW = size.width;
    final vH = size.height;

    // Crop circle: 80% of the shorter screen dimension, centered
    final cropRadius = min(vW, vH) * 0.40;
    final cropDiameter = cropRadius * 2;

    // Scale image so it fully COVERS the crop circle (never smaller than circle)
    final scaleX = cropDiameter / _origWidth!;
    final scaleY = cropDiameter / _origHeight!;
    final initialScale = max(scaleX, scaleY);

    final childW = _origWidth! * initialScale;
    final childH = _origHeight! * initialScale;

    // Center the scaled image on screen
    final tx = (vW - childW) / 2;
    final ty = (vH - childH) / 2;

    _transformationController.value =
        Matrix4.identity()
          ..setEntry(0, 0, initialScale)
          ..setEntry(1, 1, initialScale)
          ..setEntry(0, 3, tx)
          ..setEntry(1, 3, ty);

    if (mounted) {
      setState(() {
        _cropRadius = cropRadius;
        _viewportSize = size;
        _sliderScale = initialScale.clamp(_minScale, _maxScale);
        _initialized = true;
      });
    }
  }

  void _setScale(double newScale) {
    newScale = newScale.clamp(_minScale, _maxScale);
    final current = _transformationController.value;
    final currentScale = current.getMaxScaleOnAxis();
    if (currentScale == 0) return;
    final factor = newScale / currentScale;
    final tx = current.storage[12];
    final ty = current.storage[13];
    final center = Offset(
        (_viewportSize?.width ?? 400) / 2, (_viewportSize?.height ?? 800) / 2);
    final newTx = (1 - factor) * center.dx + factor * tx;
    final newTy = (1 - factor) * center.dy + factor * ty;

    _transformationController.value = Matrix4.identity()
      ..setEntry(0, 0, newScale)
      ..setEntry(1, 1, newScale)
      ..setEntry(0, 3, newTx)
      ..setEntry(1, 3, newTy);
  }

  Rect _mapRect(Matrix4 matrix, Rect rect) {
    final s = matrix.storage;
    final m00 = s[0], m01 = s[4], m03 = s[12];
    final m10 = s[1], m11 = s[5], m13 = s[13];
    double tx(double x, double y) => x * m00 + y * m01 + m03;
    double ty(double x, double y) => x * m10 + y * m11 + m13;
    final pts = [
      Offset(tx(rect.left, rect.top), ty(rect.left, rect.top)),
      Offset(tx(rect.right, rect.top), ty(rect.right, rect.top)),
      Offset(tx(rect.left, rect.bottom), ty(rect.left, rect.bottom)),
      Offset(tx(rect.right, rect.bottom), ty(rect.right, rect.bottom)),
    ];
    return Rect.fromLTRB(
      pts.map((p) => p.dx).reduce(min),
      pts.map((p) => p.dy).reduce(min),
      pts.map((p) => p.dx).reduce(max),
      pts.map((p) => p.dy).reduce(max),
    );
  }

  Future<void> _save() async {
    if (_viewportSize == null || _cropRadius == null || _imageBytes == null)
      return;
    setState(() => _isSaving = true);
    try {
      final matrix = _transformationController.value;
      final inverse = Matrix4.inverted(matrix);

      final center =
          Offset(_viewportSize!.width / 2, _viewportSize!.height / 2);
      final radius = _cropRadius!;
      final circleViewport = Rect.fromCenter(
          center: center, width: radius * 2, height: radius * 2);
      final childRect = _mapRect(inverse, circleViewport);

      final currentScale = matrix.getMaxScaleOnAxis();
      final scaleFactor = 1 / currentScale;

      final x = (childRect.left * scaleFactor).round();
      final y = (childRect.top * scaleFactor).round();
      var side = (childRect.width * scaleFactor).round();

      final cx = x.clamp(0, _origWidth! - 1);
      final cy = y.clamp(0, _origHeight! - 1);
      if (cx + side > _origWidth!) side = _origWidth! - cx;
      if (cy + side > _origHeight!) side = _origHeight! - cy;
      if (side <= 0) throw Exception('Invalid crop area');

      final original = img.decodeImage(_imageBytes!)!;
      final cropped =
          img.copyCrop(original, x: cx, y: cy, width: side, height: side);
      final resized =
          img.copyResize(cropped, width: 512, height: 512, maintainAspect: false);
      final pngBytes = Uint8List.fromList(img.encodePng(resized));

      final url = await DataService.uploadFile(pngBytes, 'avatar.png',
          type: 'profile');
      if (mounted) {
        if (url != null) {
          Navigator.pop(context, url);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Upload failed'),
                backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (!_initialized &&
                _origWidth != null &&
                constraints.maxWidth > 0) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _viewportSize =
                    Size(constraints.maxWidth, constraints.maxHeight);
                _initialize();
              });
            }

            final vpW = constraints.maxWidth;
            final vpH = constraints.maxHeight;
            final cropR = _cropRadius ?? min(vpW, vpH) * 0.40;

            // Provisional child size before initialized
            final origW = (_origWidth ?? 1).toDouble();
            final origH = (_origHeight ?? 1).toDouble();
            final provisionalScale = max(
              (cropR * 2) / origW,
              (cropR * 2) / origH,
            );
            final childW = _initialized
                ? origW * _transformationController.value.getMaxScaleOnAxis()
                : origW * provisionalScale;
            final childH = _initialized
                ? origH * _transformationController.value.getMaxScaleOnAxis()
                : origH * provisionalScale;

            return Column(
              children: [
                // ─── Top bar ────────────────────────────────────────────
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 16)),
                      ),
                      const Expanded(
                        child: Text(
                          'Crop Avatar',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      _isSaving
                          ? const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Color(0xFFFDC800))),
                            )
                          : TextButton(
                              onPressed: _initialized ? _save : null,
                              child: const Text('Save',
                                  style: TextStyle(
                                      color: Color(0xFFFDC800),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700)),
                            ),
                    ],
                  ),
                ),

                // ─── Image + overlay ────────────────────────────────────
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Pannable / zoomable image
                      InteractiveViewer(
                        transformationController: _transformationController,
                        boundaryMargin:
                            const EdgeInsets.all(double.infinity),
                        minScale: _minScale,
                        maxScale: _maxScale,
                        constrained: false,
                        child: SizedBox(
                          width: max(childW, vpW),
                          height: max(childH, vpH),
                          child: _imageBytes != null
                              ? Image.memory(_imageBytes!, fit: BoxFit.fill,
                                  width: childW, height: childH)
                              : const Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.white)),
                        ),
                      ),

                      // Dark overlay with transparent crop circle
                      IgnorePointer(
                        child: CustomPaint(
                          painter: _CropOverlayPainter(
                              radius: cropR,
                              vpW: vpW,
                              vpH: vpH),
                        ),
                      ),

                      // Instructions
                      Positioned(
                        top: 16,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Pinch to zoom  •  Drag to reposition',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ─── Zoom slider ────────────────────────────────────────
                Container(
                  color: Colors.black,
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Row(
                    children: [
                      const Icon(Icons.zoom_out,
                          color: Colors.white54, size: 22),
                      Expanded(
                        child: SliderTheme(
                          data: SliderThemeData(
                            activeTrackColor: const Color(0xFFFDC800),
                            inactiveTrackColor: Colors.white24,
                            thumbColor: Colors.white,
                            overlayColor:
                                Colors.white.withOpacity(0.1),
                            trackHeight: 3,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 10),
                          ),
                          child: Slider(
                            value: _sliderScale.clamp(_minScale, _maxScale),
                            min: _minScale,
                            max: _maxScale,
                            onChanged: _initialized ? _setScale : null,
                          ),
                        ),
                      ),
                      const Icon(Icons.zoom_in,
                          color: Colors.white54, size: 22),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CropOverlayPainter extends CustomPainter {
  final double radius;
  final double vpW;
  final double vpH;

  const _CropOverlayPainter(
      {required this.radius, required this.vpW, required this.vpH});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width > 0 ? size.width : vpW;
    final h = size.height > 0 ? size.height : vpH;
    final center = Offset(w / 2, h / 2);

    // Dark overlay everywhere except inside the circle
    final outer = Path()..addRect(Rect.fromLTWH(0, 0, w, h));
    final circle =
        Path()..addOval(Rect.fromCircle(center: center, radius: radius));
    final overlay = Path.combine(PathOperation.difference, outer, circle);

    canvas.drawPath(
      overlay,
      Paint()
        ..color = Colors.black.withOpacity(0.65)
        ..style = PaintingStyle.fill,
    );

    // White border ring around the crop circle
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white.withOpacity(0.9)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke,
    );

    // Four subtle corner L-brackets just outside the circle
    _drawCornerBrackets(canvas, center, radius);
  }

  void _drawCornerBrackets(Canvas canvas, Offset center, double r) {
    const len = 18.0;
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final corners = [
      Offset(center.dx - r, center.dy - r), // top-left
      Offset(center.dx + r, center.dy - r), // top-right
      Offset(center.dx - r, center.dy + r), // bottom-left
      Offset(center.dx + r, center.dy + r), // bottom-right
    ];
    final dx = [1.0, -1.0, 1.0, -1.0];
    final dy = [1.0, 1.0, -1.0, -1.0];

    for (var i = 0; i < 4; i++) {
      final c = corners[i];
      canvas.drawLine(c, Offset(c.dx + dx[i] * len, c.dy), paint);
      canvas.drawLine(c, Offset(c.dx, c.dy + dy[i] * len), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CropOverlayPainter old) =>
      old.radius != radius || old.vpW != vpW || old.vpH != vpH;
}

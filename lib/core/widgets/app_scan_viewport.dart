import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../theme/theme.dart';
import '../strings/app_strings.dart';

/// Dark face-scan viewport with camera preview, corner brackets,
/// oval scan ring, animated laser line, and LIVE indicator.
///
/// Pass [cameraController] when camera permission is granted; otherwise a
/// dark placeholder is shown.
class AppScanViewport extends StatefulWidget {
  const AppScanViewport({super.key, this.cameraController});

  final CameraController? cameraController;

  @override
  State<AppScanViewport> createState() => _AppScanViewportState();
}

class _AppScanViewportState extends State<AppScanViewport>
    with SingleTickerProviderStateMixin {
  late final AnimationController _laser;
  late final Animation<double> _laserY;

  @override
  void initState() {
    super.initState();
    _laser = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _laserY = Tween<double>(begin: 0.1, end: 0.9).animate(
      CurvedAnimation(parent: _laser, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _laser.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 340,
      decoration: BoxDecoration(
        color: const Color(0xFF0B0F19),
        borderRadius: BorderRadius.circular(AppRadius.viewport),
        boxShadow: AppShadows.darkShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Camera preview or dark placeholder.
          if (widget.cameraController != null &&
              widget.cameraController!.value.isInitialized)
            Positioned.fill(child: CameraPreview(widget.cameraController!))
          else
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    colors: [Color(0x66182436), Color(0xF20B0F19)],
                    radius: 0.8,
                  ),
                ),
              ),
            ),

          // Gradient overlays.
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.5),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Corner brackets.
          ..._corners(),

          // Oval scan ring + laser.
          Center(
            child: SizedBox(
              width: 188,
              height: 236,
              child: Stack(
                children: [
                  // Oval ring.
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(AppRadius.ovalScan),
                        border: Border.all(
                          color: const Color(0x6610B981),
                        ),
                      ),
                    ),
                  ),
                  // Animated laser.
                  AnimatedBuilder(
                    animation: _laserY,
                    builder: (context, child) => Positioned(
                      left: 0,
                      right: 0,
                      top: _laserY.value * 236 - 1,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0x0010B981),
                              Color(0xFF10B981),
                              Color(0x0010B981),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF10B981),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // LIVE indicator top-left.
          Positioned(
            left: 16,
            top: 12,
            child: Opacity(
              opacity: 0.8,
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.scanLive,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    AppStrings.liveLabel,
                    style: AppTextStyles.monoLIVE.copyWith(
                      color: AppColors.scanLiveText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _corners() {
    const size = 24.0;
    const strokeW = 2.0;
    const color = AppColors.scanLive;
    const r = AppRadius.bracket;
    return [
      Positioned(
        left: 0,
        top: 0,
        child: _CornerBracket(
          r: r, size: size, color: color, sw: strokeW,
          drawTop: true, drawLeft: true,
        ),
      ),
      Positioned(
        right: 0,
        top: 0,
        child: _CornerBracket(
          r: r, size: size, color: color, sw: strokeW,
          drawTop: true, drawRight: true,
        ),
      ),
      Positioned(
        left: 0,
        bottom: 0,
        child: _CornerBracket(
          r: r, size: size, color: color, sw: strokeW,
          drawBottom: true, drawLeft: true,
        ),
      ),
      Positioned(
        right: 0,
        bottom: 0,
        child: _CornerBracket(
          r: r, size: size, color: color, sw: strokeW,
          drawBottom: true, drawRight: true,
        ),
      ),
    ];
  }
}

class _CornerBracket extends StatelessWidget {
  const _CornerBracket({
    required this.r,
    required this.size,
    required this.color,
    required this.sw,
    this.drawTop = false,
    this.drawLeft = false,
    this.drawBottom = false,
    this.drawRight = false,
  });

  final double r, size, sw;
  final Color color;
  final bool drawTop, drawLeft, drawBottom, drawRight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _BracketPainter(
          color: color,
          sw: sw,
          r: r,
          top: drawTop,
          left: drawLeft,
          bottom: drawBottom,
          right: drawRight,
        ),
      ),
    );
  }
}

class _BracketPainter extends CustomPainter {
  _BracketPainter({
    required this.color,
    required this.sw,
    required this.r,
    required this.top,
    required this.left,
    required this.bottom,
    required this.right,
  });

  final Color color;
  final double sw, r;
  final bool top, left, bottom, right;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = sw
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    if (top && left) {
      path.moveTo(0, size.height);
      path.lineTo(0, r);
      path.arcToPoint(Offset(r, 0), radius: Radius.circular(r));
      path.lineTo(size.width, 0);
    } else if (top && right) {
      path.moveTo(0, 0);
      path.lineTo(size.width - r, 0);
      path.arcToPoint(Offset(size.width, r), radius: Radius.circular(r));
      path.lineTo(size.width, size.height);
    } else if (bottom && left) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height - r);
      path.arcToPoint(Offset(r, size.height), radius: Radius.circular(r));
      path.lineTo(size.width, size.height);
    } else if (bottom && right) {
      path.moveTo(size.width, 0);
      path.lineTo(size.width, size.height - r);
      path.arcToPoint(
        Offset(size.width - r, size.height),
        radius: Radius.circular(r),
      );
      path.lineTo(0, size.height);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BracketPainter old) => false;
}


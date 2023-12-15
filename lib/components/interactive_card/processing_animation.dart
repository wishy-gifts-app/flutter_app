import 'dart:ui';
import 'package:rounded_background_text/rounded_background_text.dart';
import 'package:flutter/material.dart';

class ProcessingAnimationWidget extends StatefulWidget {
  final String message;
  final bool refetchProducts;

  ProcessingAnimationWidget({
    Key? key,
    required this.message,
    this.refetchProducts = false,
  }) : super(key: key);

  @override
  _ProcessingAnimationWidgetState createState() =>
      _ProcessingAnimationWidgetState();
}

class _ProcessingAnimationWidgetState extends State<ProcessingAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _rotationController;
  bool _showSecondImage = false;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    if (widget.refetchProducts) {
      _fadeController.forward();
    }
  }

  @override
  void didUpdateWidget(ProcessingAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.refetchProducts != oldWidget.refetchProducts) {
      if (widget.refetchProducts) {
        _fadeController.forward();
      } else {
        _fadeController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Widget _buildImage(String assetPath, bool shouldRotate) {
    return AnimatedBuilder(
      animation: _rotationController,
      child: Image.asset(assetPath, height: 100, width: 100),
      builder: (BuildContext context, Widget? child) {
        return shouldRotate
            ? Transform.rotate(
                angle: widget.refetchProducts
                    ? -_rotationController.value * 2.0 * 3.14159
                    : _rotationController.value * 2.0 * 3.14159,
                child: child,
              )
            : child!;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              constraints: BoxConstraints(minHeight: 200, maxHeight: 250),
              width: 320,
              alignment: Alignment.center,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.transparent, Colors.white.withOpacity(0.1)],
                ),
              ),
              child: AnimatedCrossFade(
                duration: const Duration(milliseconds: 1000),
                firstChild: _buildItem('assets/images/android_icon.png'),
                secondChild:
                    _buildItem('assets/images/recommendations-image.png'),
                crossFadeState: widget.refetchProducts
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(String assetPath) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildImage(assetPath, true),
        SizedBox(height: 20),
        RoundedBackgroundText(
          widget.message,
          backgroundColor: Colors.black.withOpacity(0.5),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            wordSpacing: 1,
            height: 1.2,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.5),
                offset: Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

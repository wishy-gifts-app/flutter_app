import 'package:Wishy/components/interactive_card/interactive_card.dart';
import 'package:Wishy/components/swipeable_card.dart';
import 'package:flutter/material.dart';

class AnimatedSwipeableCardWrapper extends StatefulWidget {
  final SwipeableCard child;
  final CardTypes type;
  final bool close;
  final Function closeHandler;

  AnimatedSwipeableCardWrapper({
    Key? key,
    required this.child,
    required this.type,
    this.close = false,
    required this.closeHandler,
  }) : super(key: key);

  @override
  _AnimatedSwipeableCardWrapperState createState() =>
      _AnimatedSwipeableCardWrapperState();
}

class _AnimatedSwipeableCardWrapperState
    extends State<AnimatedSwipeableCardWrapper>
    with SingleTickerProviderStateMixin {
  bool isCardVisible = false;
  bool isInteractionEnabled = false;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  double _getWidthByType() {
    if (widget.type == CardTypes.invite)
      return MediaQuery.of(context).size.width;
    else if (widget.type == CardTypes.question)
      return -MediaQuery.of(context).size.width;

    return 0;
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _scaleAnimation =
        Tween<double>(begin: 0.5, end: 1.0).animate(_animationController);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed && widget.close) {
        widget.closeHandler();
      }
    });

    _animationController.forward();

    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          isCardVisible = true;
        });
      }
    });

    Future.delayed(Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          isInteractionEnabled = true;
        });
      }
    });
  }

  @override
  void didUpdateWidget(AnimatedSwipeableCardWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.close != oldWidget.close) {
      if (widget.close) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!isInteractionEnabled)
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            top: isCardVisible ? 0 : -MediaQuery.of(context).size.height,
            right: isCardVisible ? 0 : _getWidthByType(),
            child: widget.child,
          ),
        if (isInteractionEnabled)
          ScaleTransition(
            scale: _scaleAnimation,
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: widget.child,
            ),
          ),
      ],
    );
  }
}

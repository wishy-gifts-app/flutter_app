import 'package:Wishy/models/StepProgressData.dart';
import 'package:Wishy/services/graphql_service.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/constants.dart';

class StepProgressBar extends StatefulWidget {
  final Color activeColor;
  final Color inactiveColor;
  final double width, height;
  final int currentSessionCount;

  StepProgressBar({
    required this.currentSessionCount,
    this.activeColor = kPrimaryColor,
    this.inactiveColor = kPrimaryLightColor,
    required this.width,
    required this.height,
  });

  @override
  _StepProgressBarState createState() => _StepProgressBarState();
}

class _StepProgressBarState extends State<StepProgressBar> {
  List<StepProgressData> _steps = [];
  int _currentStep = 0;
  bool _close = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _currentStep = widget.currentSessionCount;
  }

  @override
  void didUpdateWidget(covariant StepProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentSessionCount != oldWidget.currentSessionCount) {
      setState(() {
        _currentStep++;
      });

      if (_currentStep >= _steps.length) return;

      if (_steps[_currentStep].type != StepTypes.line)
        Future.delayed(Duration(milliseconds: 500), () {
          setState(() {
            _currentStep++;
          });

          if (_steps.length == _currentStep)
            Future.delayed(
                Duration(seconds: 4),
                () => setState(() {
                      _close = true;
                    }));
        });
    }
  }

  Future<void> _fetchData() async {
    final result = await graphQLQueryHandler("getStepsProgressData", {});

    if (mounted && result != null && result.length > 0) {
      final formattedResult = (result as List<dynamic>)
          .map((item) => StepProgressData.fromJson(item))
          .toList();

      var activeItems =
          formattedResult.where((item) => item.isActive == true).toList();

      int currentState = _currentStep;
      if (activeItems.isNotEmpty) {
        var lastActiveItem = activeItems.last;
        currentState = lastActiveItem.stepNumber;
      }

      setState(() {
        _currentStep = currentState;
        _steps = formattedResult;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_steps.length == 0 || this._close) return SizedBox.shrink();

    double _stepWidth = widget.width / _steps.length;

    return Container(
      height: widget.height,
      width: widget.width,
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
              _steps.length, (index) => buildStep(index, context, _stepWidth)),
        ),
      ),
    );
  }

  Widget buildStep(int index, BuildContext context, double width) {
    bool isActive = index < _currentStep;
    bool isIcon = _steps[index].type != StepTypes.line;

    return Container(
        width: isIcon ? width + 5 : width - 5,
        child: (getIconForStep(
            _steps[index].type, width, isActive, _steps[index].tooltipText)));
  }

  Widget generateStepWrapper(Widget step, String tooltipText, bool isActive) {
    final GlobalKey<TooltipState> tooltipKey = GlobalKey<TooltipState>();

    return Tooltip(
        margin: EdgeInsets.symmetric(horizontal: 10),
        message: tooltipText,
        key: tooltipKey,
        triggerMode: TooltipTriggerMode.tap,
        showDuration: const Duration(seconds: 2),
        child: CircleAvatar(
          backgroundColor: isActive ? widget.activeColor : widget.inactiveColor,
          child: step,
        ));
  }

  Widget getIconForStep(
      StepTypes type, double? width, bool isActive, String? tooltipText) {
    switch (type) {
      case StepTypes.recommendation:
        return generateStepWrapper(
            Icon(
              Icons.lightbulb_outline,
              size: width,
              color: isActive ? widget.inactiveColor : Colors.black,
            ),
            tooltipText!,
            isActive);
      case StepTypes.discount:
        return generateStepWrapper(
            Image.asset(
              'assets/images/icon.png',
              width: width,
            ),
            tooltipText!,
            isActive);
      case StepTypes.connect:
        return generateStepWrapper(
            Icon(
              Icons.person_add,
              size: width,
              color: isActive ? widget.inactiveColor : Colors.black,
            ),
            tooltipText!,
            isActive);
      case StepTypes.line:
        return Container(
          height: 4,
          color: isActive ? widget.activeColor : widget.inactiveColor,
        );
      default:
        return Icon(
          Icons.star,
          size: width,
          color: isActive ? widget.inactiveColor : Colors.black,
        );
    }
  }
}

enum StepTypes { discount, recommendation, connect, line, newVersion }

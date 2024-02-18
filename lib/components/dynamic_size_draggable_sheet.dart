import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DynamicSizeDraggableSheet extends HookWidget {
  final Widget child;
  final double childHeightPercentage;
  final double minHeightToExpand;
  final EdgeInsets padding;
  final Color bgColor;

  DynamicSizeDraggableSheet({
    required this.child,
    this.childHeightPercentage = 1,
    this.minHeightToExpand = 0.85,
    this.bgColor = Colors.white,
    this.padding = const EdgeInsets.only(
      top: 25,
      left: 15,
      right: 15,
    ),
  });

  @override
  Widget build(BuildContext context) {
    final height = useState(0.0);

    Widget makeDismissible({required Widget child}) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.of(context).pop(),
          child: GestureDetector(
            onTap: () {},
            child: child,
          ),
        );

    final _child = SingleChildScrollView(
      child: MeasuredWidget(
        onCalculateSize: (size) => height.value = size!.height,
        child: child,
      ),
    );

    final maxSize = useMemoized(
      () => ((height.value + padding.vertical) /
              MediaQuery.of(context).size.height)
          .clamp(.1, .9),
      [height.value],
    );

    final initSize = useMemoized(
        () => maxSize < minHeightToExpand
            ? maxSize
            : maxSize * childHeightPercentage.clamp(0.1, 0.9),
        [maxSize, childHeightPercentage]);

    if (height.value == 0) {
      return _child;
    }

    return makeDismissible(
      child: DraggableScrollableSheet(
        maxChildSize: maxSize,
        minChildSize: initSize - 0.15,
        initialChildSize: initSize,
        expand: false,
        builder: (context, controller) {
          return Material(
            borderRadius: BorderRadius.circular(40),
            color: bgColor,
            child: Padding(
              padding: padding,
              child: ListView.builder(
                controller: controller,
                itemCount: 1,
                itemBuilder: (_, index) => _child,
              ),
            ),
          );
        },
      ),
    );
  }
}

class MeasuredWidget extends StatefulWidget {
  final Function(Size? size) onCalculateSize;
  final Widget child;

  const MeasuredWidget({
    Key? key,
    required this.onCalculateSize,
    required this.child,
  }) : super(key: key);

  @override
  _MeasuredWidgetState createState() => _MeasuredWidgetState();
}

class _MeasuredWidgetState extends State<MeasuredWidget> {
  final key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getHeight());
  }

  void getHeight() {
    final RenderBox? renderBox =
        key.currentContext?.findRenderObject() as RenderBox?;
    final size = renderBox?.size;
    widget.onCalculateSize(size);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      child: widget.child,
    );
  }
}

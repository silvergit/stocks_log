import 'package:flutter/material.dart';

class EmptyDbPages extends StatefulWidget {
  final String text;

  const EmptyDbPages({Key key, @required this.text}) : super(key: key);

  @override
  _EmptyDbPagesState createState() => _EmptyDbPagesState();
}

class _EmptyDbPagesState extends State<EmptyDbPages>
    with SingleTickerProviderStateMixin {
  static const Duration duration = Duration(seconds: 2);
  AnimationController controller;
  Animation<Color> animation;

  static final colors = [
//    Colors.red,
//    Colors.orange,
//    Colors.yellow,
//    Colors.green,
//    Colors.blue,
//    Colors.indigo,
//    Colors.purple,

    Colors.blue.shade300,
    Colors.blue.shade400,
    Colors.blue.shade500,
    Colors.blue.shade600,
    Colors.blue.shade700,
  ];

  void initState() {
    super.initState();

    final sequenceItems = <TweenSequenceItem<Color>>[];

    for (var i = 0; i < colors.length; i++) {
      final beginColor = colors[i];
      final endColor = colors[(i + 1) % colors.length];
      final weight = 1 / colors.length;

      sequenceItems.add(
        TweenSequenceItem<Color>(
          tween: ColorTween(begin: beginColor, end: endColor),
          weight: weight,
        ),
      );
    }

    controller = AnimationController(duration: duration, vsync: this);
    animation = TweenSequence<Color>(sequenceItems).animate(controller);

    controller.repeat();
  }

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: animation.value,
            ),
            padding: EdgeInsets.all(48.0),
            margin: EdgeInsets.all(48.0),
            child: Text(
              widget.text,
              style: TextStyle(fontSize: 22.0, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}

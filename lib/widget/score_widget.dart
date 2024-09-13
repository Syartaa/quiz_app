import 'package:flutter/material.dart';

class ScoreWidget extends StatefulWidget {
  final Color color;
  final title;
  final number;
  const ScoreWidget(
      {super.key,
      required this.color,
      @required this.title,
      @required this.number});

  @override
  State<ScoreWidget> createState() => _ScoreWidgetState();
}

class _ScoreWidgetState extends State<ScoreWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Row(
            children: [
              Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color,
                ),
              ),
              Text(
                widget.number,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: widget.color),
              )
            ],
          ),
        ),
        Text(widget.title),
      ],
    );
  }
}

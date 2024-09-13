// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class AnswersWidget extends StatefulWidget {
  final String question;
  final String answer;
  const AnswersWidget(
      {super.key, required this.question, required this.answer});

  @override
  State<AnswersWidget> createState() => _AnswersWidgetState();
}

class _AnswersWidgetState extends State<AnswersWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              spreadRadius: 3,
              color: Color.fromARGB(255, 166, 49, 196).withOpacity(.5),
              offset: Offset(0, 1),
            ),
          ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
        child: Column(
          children: [
            Text(
              widget.question,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 77, 6, 95)),
            ),
            Text(
              widget.answer,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 151, 6, 187)),
            ),
          ],
        ),
      ),
    );
  }
}

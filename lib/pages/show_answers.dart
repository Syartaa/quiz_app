// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:quiz_app/pages/home_page.dart';
import 'package:quiz_app/widget/answers_widget.dart';

class ShowAnswers extends StatelessWidget {
  final List<Map<String, String>> userAnswers; // Accept user answers

  const ShowAnswers({super.key, required this.userAnswers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 790,
            width: 450,
            child: Stack(
              children: [
                // Header Container for "Review Answers"
                Container(
                  height: 130,
                  width: 430,
                  decoration: BoxDecoration(
                    color: Color(0xffA42FC1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Back Arrow IconButton
                      IconButton(
                        icon: Icon(Icons.arrow_back,
                            color: Colors.white, size: 30),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          );
                        },
                      ),
                      SizedBox(width: 10),
                      // "Review Answers" Text
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 35),
                        child: Text(
                          "Review Answers",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 98,
                  left: 20,
                  child: Container(
                    height: 690, // Adjusted height for content area
                    width: 370,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          spreadRadius: 3,
                          color: Color(0xffA42FC1).withOpacity(.7),
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: userAnswers.map((answer) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AnswersWidget(
                                  question: answer['question']!,
                                  answer:
                                      "Selected: ${answer['selectedAnswer']} \nCorrect: ${answer['correctAnswer']}",
                                ),
                                SizedBox(height: 15),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

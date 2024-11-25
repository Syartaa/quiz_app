// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/pages/log_page.dart';
import 'package:quiz_app/pages/quiz_page.dart';
import 'package:quiz_app/pages/show_answers.dart';
import 'package:quiz_app/widget/score_widget.dart';

class Completed extends StatelessWidget {
  final int correctAnswers;
  final int wrongAnswers;
  final List<Map<String, String>> userAnswers; // Add userAnswers
  const Completed(
      {super.key,
      required this.correctAnswers,
      required this.wrongAnswers,
      required this.userAnswers});

  @override
  Widget build(BuildContext context) {
    // Save the result to Firestore once the user reaches the completed page
    _saveQuizResult();

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 521,
            width: 450,
            child: Stack(
              children: [
                Container(
                  height: 340,
                  width: 410,
                  decoration: BoxDecoration(
                      color: Color(0xffA42FC1),
                      borderRadius: BorderRadius.circular(20)),
                  alignment: Alignment.center,
                  child: Center(
                    child: CircleAvatar(
                      radius: 85,
                      backgroundColor: Colors.white.withOpacity(.3),
                      child: CircleAvatar(
                        radius: 71,
                        backgroundColor: Colors.white.withOpacity(.4),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Your score",
                                  style: TextStyle(
                                      fontSize: 20, color: Color(0xffA42FC1)),
                                ),
                                RichText(
                                  text: TextSpan(
                                      text: '${correctAnswers * 10}',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xffA42FC1)),
                                      children: [
                                        TextSpan(
                                          text: ' pts',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xffA42FC1)),
                                        )
                                      ]),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                    bottom: 60,
                    left: 22,
                    child: Container(
                      height: 190,
                      width: 350,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 5,
                              spreadRadius: 3,
                              color: Color(0xffA42FC1).withOpacity(.7),
                              offset: Offset(0, 1),
                            )
                          ]),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ScoreWidget(
                                      color: Color(0xffA42FC1),
                                      title: "Completion",
                                      number: ' 100%'),
                                  ScoreWidget(
                                      color: Color(0xffA42FC1),
                                      title: "Total Question",
                                      number: ' 10'),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ScoreWidget(
                                      color: Color.fromARGB(255, 24, 180, 76),
                                      title: "Correct",
                                      number: ' $correctAnswers'),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 48),
                                    child: ScoreWidget(
                                        color: Color.fromARGB(255, 233, 30, 57),
                                        title: "Wrong",
                                        number: ' $wrongAnswers'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          ),
          SizedBox(height: 40),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          // Show a loading indicator while navigating
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                body:
                                    Center(child: CircularProgressIndicator()),
                              ),
                            ),
                          );
                          // Simulate loading delay
                          await Future.delayed(Duration(seconds: 1));

                          // Navigate to the HomePage
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizPage(),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: Color(0xff37AFA1),
                          radius: 35,
                          child: Center(
                            child: Icon(
                              Icons.refresh,
                              size: 35,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Play Again",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ShowAnswers(userAnswers: userAnswers),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: Color(0xffCB9771),
                          radius: 35,
                          child: Center(
                            child: Icon(
                              Icons.visibility_rounded,
                              size: 35,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Review Answer",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color(0xff37AFA1),
                          radius: 35,
                          child: Center(
                            child: Icon(
                              Icons.logout_rounded,
                              size: 35,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Log out",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        )
                      ],
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

  Future<void> _saveQuizResult() async {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Reference to Firestore
        CollectionReference quizResults = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('quizResults');

        // Create a new document with the quiz result
        await quizResults.add({
          'correctAnswers': correctAnswers,
          'wrongAnswers': wrongAnswers,
          'date': Timestamp.now(),
          'userAnswers': userAnswers.map((answer) {
            return {
              'question': answer['question'],
              'selectedAnswer': answer['selectedAnswer'],
              'correctAnswer': answer['correctAnswer'],
            };
          }).toList(),
        });

        print('Quiz result saved successfully.');
      } catch (e) {
        print('Failed to save quiz result: $e');
      }
    } else {
      print('User is not logged in.');
    }
  }
}

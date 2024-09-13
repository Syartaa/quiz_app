import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quiz_app/pages/complete_page.dart';
import 'package:quiz_app/widget/options.dart'; // Your updated Options widget
import 'package:http/http.dart' as http;

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List responseData = [];
  int number = 0;
  Timer? _timer; // Initialize _timer as nullable
  int secondRemaining = 15;
  String selectedOption = '';
  bool isAnswered = false;
  int correctAnswers = 0;
  int wrongAnswers = 0;
  bool isLoading = false;
  List<Map<String, String>> userAnswers = []; // List to store user answers

  List<String> shuffledOptions = [];

  @override
  void dispose() {
    _timer?.cancel(); // Safely cancel the timer if it's not null
    super.dispose();
  }

  Future<void> api() async {
    try {
      final response =
          await http.get(Uri.parse("https://opentdb.com/api.php?amount=10"));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['results'];
        if (mounted) {
          setState(() {
            responseData = data;
            updateShuffleOption();
          });
        }
      } else {
        showError('Failed to load questions');
      }
    } catch (e) {
      showError('An error occurred: $e');
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    api();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(
              height: 421,
              width: 400,
              child: Stack(
                children: [
                  Container(
                    height: 240,
                    width: 390,
                    decoration: BoxDecoration(
                        color: Color(0xffA42FC1),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  Positioned(
                    bottom: 60,
                    left: 22,
                    child: Container(
                      height: 170,
                      width: 350,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 251, 251, 252),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 1),
                              blurRadius: 5,
                              spreadRadius: 3,
                              color: Color(0xffA42FC1).withOpacity(.4),
                            )
                          ]),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '05',
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 20),
                                ),
                                Text(
                                  (number + 1).toString(),
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 20),
                                ),
                              ],
                            ),
                            Center(
                              child: Text(
                                "Question ${number + 1}/10",
                                style: TextStyle(color: Color(0xffA42FC1)),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(responseData.isNotEmpty
                                ? responseData[number]['question']
                                : ''),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 210,
                    left: 140,
                    child: CircleAvatar(
                      radius: 42,
                      backgroundColor: Colors.white,
                      child: Center(
                        child: Text(
                          secondRemaining.toString(),
                          style:
                              TextStyle(color: Color(0xffA42FC1), fontSize: 25),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            Column(
                children: (responseData.isNotEmpty &&
                        responseData[number]['incorrect_answers'] != null)
                    ? shuffledOptions.map((option) {
                        return Options(
                          option: option.toString(),
                          selectedOption: selectedOption,
                          isCorrect:
                              option == responseData[number]['correct_answer'],
                          onSelected: (selected) {
                            if (!isAnswered) {
                              setState(() {
                                selectedOption = selected;
                                isAnswered = true;
                                // Check if the selected option is correct
                                if (selected ==
                                    responseData[number]['correct_answer']) {
                                  correctAnswers++;
                                } else {
                                  wrongAnswers++;
                                }
                              });
                            }
                          },
                        );
                      }).toList()
                    : []),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffA42FC1),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 5,
                ),
                onPressed: () {
                  nextQuestion();
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Next",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void nextQuestion() {
    if (!isAnswered) {
      // If no option is selected, mark the question as wrong
      wrongAnswers++;
    }

    // Store question, selected answer, and correctness in userAnswers list
    userAnswers.add({
      'question': responseData[number]['question'],
      'selectedAnswer': selectedOption,
      'correctAnswer': responseData[number]['correct_answer'],
    });

    if (number < 9) {
      setState(() {
        number++;
        updateShuffleOption();
        secondRemaining = 15; // Reset timer
        selectedOption = '';
        isAnswered = false;
      });
      // Restart the timer for the new question
      startTimer();
    } else {
      completed();
    }
  }

  void completed() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Completed(
            correctAnswers: correctAnswers,
            wrongAnswers: wrongAnswers,
            userAnswers: userAnswers, // Pass userAnswers to Completed page
          ),
        ));
  }

  void updateShuffleOption() {
    setState(() {
      shuffledOptions = shuffledOption([
        responseData[number]['correct_answer'],
        ...(responseData[number]['incorrect_answers'] as List)
      ]);
    });
  }

  List<String> shuffledOption(List<String> option) {
    List<String> shuffleOptions = List.from(option);
    shuffleOptions.shuffle();
    return shuffleOptions;
  }

  void startTimer() {
    // Cancel any existing timer before starting a new one
    _timer?.cancel();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (secondRemaining > 0) {
            secondRemaining--;
          } else {
            // Time expired, mark the question as wrong if not answered
            if (!isAnswered) {
              wrongAnswers++;
            }
            // Move to the next question and reset timer
            nextQuestion();
            // Timer will be restarted in nextQuestion method
          }
        });
      }
    });
  }
}

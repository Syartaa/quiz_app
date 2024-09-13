import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/pages/log_page.dart';
import 'package:quiz_app/pages/quiz_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // If the user is not authenticated, navigate to the login page
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      });
    }

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 670,
            width: 500,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 400,
                    width: 430,
                    decoration: BoxDecoration(
                      color: Color(0xffA42FC1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Positioned(
                    bottom: 130,
                    left: 22,
                    child: Container(
                        height: 270,
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
                              )
                            ]),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/quiz.png',
                            width: 100, // Set the width of the image
                            height: 100, // Set the height of the image
                            fit: BoxFit
                                .cover, // Ensures the image covers the oval shape
                          ),
                        ))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffA42FC1),
                  padding: EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 5,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizPage(),
                    ),
                  );
                },
                child: Container(
                  child: Text(
                    "Start Now",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }
}

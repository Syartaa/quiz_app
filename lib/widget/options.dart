import 'package:flutter/material.dart';

class Options extends StatelessWidget {
  final String option;
  final String selectedOption;
  final bool isCorrect;
  final Function(String) onSelected;

  Options({
    Key? key,
    required this.option,
    required this.selectedOption,
    required this.isCorrect,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSelected = option == selectedOption;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            onSelected(option);
          },
          child: Container(
            constraints: BoxConstraints(maxWidth: 250), // Set a max width
            decoration: BoxDecoration(
              color: isSelected
                  ? (isCorrect ? Colors.green : Colors.red)
                  : Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 3, color: Color(0xffA42FC1)),
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        option,
                        overflow: TextOverflow.ellipsis, // Handle overflow
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    Radio(
                      value: option,
                      groupValue: selectedOption,
                      onChanged: (val) {
                        onSelected(option);
                      },
                      activeColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
     Key? key,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: onClicked,

    child:
    Text(
      "Let's Go!",

      style: TextStyle(
        fontSize: (MediaQuery.of(context).size.width)*0.07,
        fontWeight: FontWeight.bold,
        color: Colors.grey[800],
      ),
    ),
  );
}

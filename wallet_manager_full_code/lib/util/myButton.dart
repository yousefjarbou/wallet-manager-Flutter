import 'package:flutter/material.dart';

class Mybotton extends StatelessWidget {
  final String imagePath;
  final String buttinText;
  final bool buttonNightMood;
  const Mybotton({Key? key,
    required this.buttinText,
    required this.imagePath,
    required this.buttonNightMood,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double h=MediaQuery.of(context).size.height;
    double w=MediaQuery.of(context).size.width;
    return Column(
      children: [
        //icon
        Container(
          height: h*0.14,
          padding: EdgeInsets.all(w*0.029),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(w*0.036),
            boxShadow: [
              if(buttonNightMood==false)
              BoxShadow(
                color: Colors.grey.shade400,
                blurRadius: w*0.09,
                spreadRadius: w*0.029,
              ),
            ],
          ),
          child: Center(
            //'lib/icons/cash-withdrawal.png'
            child: Image.asset(imagePath),
          ),
        ),
        SizedBox(height: h*0.014),
        //text
        Text(
          //'Withdrawal',
          buttinText,
          style: TextStyle(
            fontSize: w*0.045,
            fontWeight: FontWeight.bold,
            color: buttonNightMood?Colors.white:Colors.grey[700],
          ),
        ),
      ],);
  }
}

import 'package:flutter/material.dart';
import 'package:wallet_manager_ads_sharedpref/util/transInfo.dart';
class MyTrans extends StatelessWidget {
  final String wantToPrint;
  final Color c;
  const MyTrans({Key? key,
    required this.wantToPrint,
    required this.c
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double h=MediaQuery.of(context).size.height;
    double w=MediaQuery.of(context).size.width;
    SizedBox(height: h*0.02,);
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: w*0.02),
      child: Container(
        width: 300,
        padding: EdgeInsets.all(w*0.02),
        decoration: BoxDecoration(
            color: c,
            borderRadius: BorderRadius.circular(w*0.04)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: h*0.009),
             Text(
               wantToPrint,
                style: TextStyle(
                  //color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: w*0.05,
                ), // TextStyle
              ),
             // Text

          ],
        ),
      ),
    );
  }}
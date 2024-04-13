import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:wallet_manager_ads_sharedpref/util/button_widget.dart';
import 'package:wallet_manager_ads_sharedpref/pages/HomePages.dart';

class OnBoardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SafeArea(

    child: IntroductionScreen(
      pages: [
        PageViewModel(
          title: 'Start by creating your Wallets, and remember:',
          body: 'Money moves from those who do not manage it to those who do',
          image: buildImage('lib/icons/AddWallet2.png'),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: 'Note all your Withdrawals',
          body: 'Mention the wallet and the Category you spend your money on',
          image: buildImage('lib/icons/withAndDeposit1.png'),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: 'Note all your Deposits',
          body: 'Mention the wallet and the amount of money',
          image: buildImage('lib/icons/withAndDeposit2.png'),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: 'Watch all your Expenses',
          body: 'Start your journey',
          footer: Padding(
            padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.3),
            child: ButtonWidget(
              text: "Let's Go!",
              onClicked: () => goToHome(context),
            ),
          ),
          image: buildImage('lib/icons/Expensses.png'),
          decoration: getPageDecoration(),
        ),
      ],
      done: Text("Let's Go!", style: TextStyle(fontWeight: FontWeight.w600,)),
      onDone: () => goToHome(context),
      showSkipButton: true,
      skip: Text('Skip'),
      onSkip: () => goToHome(context),
      next: Icon(Icons.arrow_forward),
      dotsDecorator: getDotDecoration(),
     ),
  );

  void goToHome(context) => Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => HomePage()),
  );

  Widget buildImage(String path) =>
      Center(child: Image.asset(path, width: 800,height: 800,));

  DotsDecorator getDotDecoration() => DotsDecorator(
    color: Color(0xFFBDBDBD),
    size: Size(10, 10),
    activeSize: Size(22, 10),
    activeShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  );

  PageDecoration getPageDecoration() => const PageDecoration(
    titleTextStyle: TextStyle(fontSize: 26, fontWeight: FontWeight.bold,color: Colors.black),
    bodyTextStyle: TextStyle(fontSize: 20,color: Colors.black),
    imagePadding: EdgeInsets.all(20),
    imageFlex: 3,
    pageColor: Colors.white,

  );
}
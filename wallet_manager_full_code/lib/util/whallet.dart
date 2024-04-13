import 'dart:ui';

class Wallet{
  final String name;
  double money;
  Color cc;

  Wallet({
    required this.name,
    required this.money,
    required this.cc,
  });
void moneyDec(double cash){money-=cash;}
void moneyIncrease(double cash){money+=cash;}
  String getWalletInfo(){
    // Color color = new Color(0x12345678);
    String colorString = cc.toString();
    // String valueString = colorString.split('(0x')[1].split(')')[0]; // kind of hacky..
    // int value = int.parse(valueString, radix: 16);
    // Color otherColor =  Color(value);

  return "$name,$money,$colorString";
  }
}
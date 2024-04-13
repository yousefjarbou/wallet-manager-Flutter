import 'dart:ui';

class TransInfo{
  int myDay;
  int myMonth;
  int weekD;
  bool logDeposit;
  double cashAmount;
  String logWalletName;
  String logCat;
  Color walletColor;

  TransInfo({
    required this.myDay,
    required this.myMonth,
    required this.logDeposit,
    required this.cashAmount,
    required this.logWalletName,
    required this.logCat,
    required this.weekD,
    required this.walletColor,
  });
  String? dataOflog(){
    int d;int m;String weekDD;
    d=myDay;m=myMonth;
    String mm;
    String? dlog;
    switch(weekD){
      case 1: weekDD='Mon'; break;
      case 2: weekDD='Tue'; break;
      case 3: weekDD='Wed'; break;
      case 4: weekDD='Thu'; break;
      case 5: weekDD='Fri'; break;
      case 6: weekDD='Sat'; break;
      case 7: weekDD='Sun'; break;
      default: weekDD='RELLY MAAAN1';break;
    }
    switch(m){
      case 1: mm='Jan'; break;
      case 2: mm='Feb'; break;
      case 3: mm='Mar'; break;
      case 4: mm='Apr'; break;
      case 5: mm='May'; break;
      case 6: mm='June'; break;
      case 7: mm='July'; break;
      case 8: mm='Aug'; break;
      case 9: mm='Sept'; break;
      case 10: mm='Oct'; break;
      case 11: mm='Nov'; break;
      case 12: mm='Dec'; break;
      default: mm='RELLY MAAAN2';break;
    }
    String ifDeposit=logDeposit?"Income= + ":"Payment= -- ";
    String temp2=logDeposit?" ":",\nCategory: "+logCat;
    dlog=weekDD+", "
        +d.toString()
        +"-"+mm+"\n"
        +ifDeposit+cashAmount.toString()+"   Wallet: "+logWalletName+temp2;
    return dlog;
  }
  String getTransInfo(){
    String colorString = walletColor.toString();
    return "$dataOflog(),$colorString";
  }
}
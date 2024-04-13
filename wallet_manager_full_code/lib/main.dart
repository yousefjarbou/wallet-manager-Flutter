//Yousef Jarbou 
//Wallet Manager 

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wallet_manager_ads_sharedpref/pages/HomePages.dart';
import 'package:wallet_manager_ads_sharedpref/pages/onboarding_page.dart';
import 'package:wallet_manager_ads_sharedpref/util/transInfo.dart';
import 'package:wallet_manager_ads_sharedpref/util/whallet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart'
    '';
final darkModeNotifier = ValueNotifier<bool>(false);
 bool opened=false;
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SharedPreferences pref=await SharedPreferences.getInstance();
  if((pref.getBool('opened'))!=null){
    opened=pref.getBool('opened')!;
  }else{opened=false;}

  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);
  const MyApp({Key? key}) : super(key: key);

  @override

  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: darkModeNotifier,
        builder: (context, value, child) {
          return MaterialApp(
            theme: value ? ThemeData.dark() : ThemeData.light(),
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData.dark(),
        home : opened==false?OnBoardingPage():HomePage(),
      );
    }

    );
  }
// Future<bool> getpref()async{
//     SharedPreferences pref=await SharedPreferences.getInstance();
//     if((pref.getBool('NightMood'))!=null){
//       return pref.getBool('NightMood')!;
//     }else{return false;}
//   }
}

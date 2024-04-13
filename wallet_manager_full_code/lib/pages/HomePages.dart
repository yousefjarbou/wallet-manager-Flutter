import 'dart:async';
import 'dart:developer';
import 'dart:ffi';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wallet_manager_ads_sharedpref/util/myButton.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../my_color_picker.dart';
import '../util/myChartGen.dart';
import '../util/whallet.dart';
import '../util/transInfo.dart';
import 'package:wallet_manager_ads_sharedpref/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //banner ads
  final BannerAd bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: "##########",//top secret ^_^
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) => print('banner Lloooaded'),
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('banner failed to load$error');
        },
        onAdOpened: (Ad ad) => print('Ad opened'),
        onAdClosed: (Ad ad) => print('Ad closed'),
        onAdImpression: (Ad ad) => print('Ad Impression'),
      ),
      request: const AdRequest());
  //Support us ads
  late final RewardedAd rewardedAd;
  final String rewardedAdUnitId = "##########";//top secret ^_^
  List<String> Category = [
    'Food',
    'Transportation',
    'Studying',
    'Gaming',
    'Robot',
    'New Category +?',
  ];
  bool catDeleted=false;

  Map<String, int> catCount = {
    'Food': 0,
    'Transportation': 0,
    'Studying': 0,
    'Gaming': 0,
    'Robot': 0,
  };
  Map<String, double> catPay = {
    'Food1': 0,
    'Transportation1': 0,
    'Studying1': 0,
    'Gaming1': 0,
    'Robot1': 0,
  };

  //for daily avg
  int currentDay=0;
  int totalDays=0;

  int numOfWallets = 0;
  bool transed = false;
  bool NightMood = false;

  List<Wallet> wallets = <Wallet>[];
  List<TransInfo> transs = <TransInfo>[];
  List<String> transPrint = <String>[];
  List<String> transColor = <String>[];

  List<String> walletNames = <String>[];

  Future<void> _loadRewardedAd() async {
    await RewardedAd.load(
        adUnitId: rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdFailedToLoad: (LoadAdError error) {
            print('La 2elaha 2ela Allah $error');
          },
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded');
            rewardedAd = ad;
            _setFullScreenContentCallBack();
          },
        ));
  }

  void _setFullScreenContentCallBack() {
    if (rewardedAd == null) return;
    rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('$ad onAdShowedFullScreenContent'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent');
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent $error');
        ad.dispose();
      },
      onAdImpression: (RewardedAd ad) => print('$ad onAdImpression'),
    );
  }

  void _showRewardedAd() {
    rewardedAd.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
      //num amount=rewardItem.amount;
      //print('you earned $amount');
    });
  }

  //page controller
  //final key1 = GlobalKey<PageView>();
  final TextEditingController _walletNameCont = TextEditingController();
  final TextEditingController _chashCont = TextEditingController();
  final TextEditingController _withdrawalAmount = TextEditingController();
  final TextEditingController _withdrawalName = TextEditingController();
  final TextEditingController _withdrawalCat = TextEditingController();
  final TextEditingController _Deposit = TextEditingController();
  final TextEditingController _newCat = TextEditingController();

  //final Uri _urlYousef = Uri.parse('https://www.linkedin.com/in/yousef-jarbou-9b50751ba');
  String yousefURL = 'https://www.linkedin.com/in/yousef-jarbou-9b50751ba';
  String omarURL = 'https://www.linkedin.com/in/omar-tobassi-818356211';
  //final Uri _urlOmar = Uri.parse('https://www.linkedin.com/in/omar-tobassi-818356211');
  final _controller = PageController();

  Color _color = Colors.blue;

bool dataLoaded=false;
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      getpref();
    });
    super.initState();
  }

  //Map<Date>

  String? value;
  String? value1;
  String? value3;
  String dropdownValue = 'Food';
  String? currentName;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    GlobalKey<FormState> depositKey = GlobalKey<FormState>();
    GlobalKey<FormState> withdrawalKey = GlobalKey<FormState>();
    GlobalKey<FormState> newCattKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: NightMood ? Colors.grey[850] : Colors.grey[300],
      body: SafeArea(
        child:
              dataLoaded==false?Center(child: CircularProgressIndicator()):
              dataLoaded==true?
                 Column(children: [
                  Column(children: [
                    //appbar
                    Padding(
                      padding: EdgeInsets.all(w * 0.062),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "My",
                                style: TextStyle(
                                  fontSize: w * 0.078,
                                  fontWeight: FontWeight.bold,
                                  color:
                                  NightMood ? Colors.white : Colors.grey[900],
                                ),
                              ),
                              Text(
                                " Wallets",
                                style: TextStyle(fontSize: w * 0.078,color:
                                NightMood ? Colors.white : Colors.grey[900],),
                              ),
                            ],
                          ),
                          // plus button
                          // plus button
                          Container(
                            padding: EdgeInsets.all(
                              numOfWallets == 0 ? w * 0.08 : w * 0.01,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              shape: BoxShape.circle,
                              //borderRadius: BorderRadius.circular(w*0.06),
                            ), // BoxDecoration

                            //Add wallet Button
                            child: IconButton(
                              icon: Icon(
                                Icons.add,
                                size: numOfWallets == 0 ? w * 0.09 : w * 0.06,
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    )),
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Form(
                                          key: formKey,
                                          child: Container(
                                            height: h * 0.85,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 25,
                                                          right: 10,
                                                          left: 10,
                                                          bottom: 10),
                                                  child: TextFormField(
                                                    autofocus: true,
                                                    //autofocus: true,
                                                    //search for (on change function) to make the max line =5
                                                    maxLines: null,
                                                    controller: _walletNameCont,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {

                                                        return "This field is required";
                                                      }
                                                      if(walletNames.contains(value))return "This wallet already exist";
                                                      if(value.contains(" "))return "No Spaces allowed in the name";
                                                      if(walletNames.contains(value))return "The Wallet already exist! ";
                                                      return null;
                                                    },
                                                    //for max chars
                                                    maxLength: 9,
                                                    //search for (on change function) to make the max line =5
                                                    decoration: InputDecoration(
                                                      label: const Text(
                                                          "Wallet Name"),
                                                      border:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15)),
                                                    ),
                                                  ),
                                                ),

                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: TextFormField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    //search for (on change function) to make the max line =5
                                                    maxLines: 1,
                                                    maxLength: 8,
                                                    controller: _chashCont,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty||value.contains("_")||value.contains(" ")) {
                                                        return "This field is required";
                                                      }
                                                      return null;
                                                    },
                                                    //search for (on change function) to make the max line =5
                                                    decoration: InputDecoration(
                                                      label: const Text(
                                                          "Amount Of Money"),
                                                      border:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15)),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: w * 0.04),
                                                      child: const Text(
                                                          'Wallet Collor'),
                                                    ),
                                                  ],
                                                ),
                                                //color select
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: MyColorPicker(
                                                        onSelectColor: (value) {
                                                          setState(() {
                                                            _color = value;
                                                          });
                                                        },
                                                        availableColors: const [
                                                          Color(0x953CA5E0),
                                                          Color(0x642397A2),
                                                          Color(0xFF1CBD24),
                                                          Color(0xFFFFBC00),
                                                        ],
                                                        initialColor:
                                                            Colors.blue)),

                                                ElevatedButton(
                                                    onPressed: () {
                                                      if (formKey.currentState!.validate() == true) {
                                                        //add to do item
                                                        addWalletFun(_walletNameCont.text, double.parse(_chashCont.text), _color);

                                                        Navigator.pop(context);
                                                        //fillListOfNames();
                                                      }
                                                    },
                                                    child: const Text(
                                                        "Add Wallet")),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              },
                            ),
                          ), // Container
                        ],
                      ),
                    ),
                    SizedBox(height: h * 0.002),
                    //wallets
                    numOfWallets != 0
                        ? Container(
                            height: numOfWallets == 0 ? h * 0.1 : h * 0.255,

                            //        //
                            //        //
                            //show wallets
                            //        //
                            //        //
                            //        //
                            child: PageView.builder(
                              // reverse: true,
                              scrollDirection: Axis.horizontal,
                              controller: _controller,
                              itemCount: wallets.length,

                              itemBuilder: (context, i) {

                                currentName=walletNames[i];
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: w * 0.065),
                                  child: Container(
                                    width: 300,
                                    padding: EdgeInsets.all(w * 0.08),
                                    decoration: BoxDecoration(
                                        color: wallets[i].cc,
                                        borderRadius:
                                            BorderRadius.circular(w * 0.04)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(height: h * 0.009),

                                        Center(
                                          child: Text(
                                            wallets[i].name,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: w * 0.09,
                                            ), // TextStyle
                                          ),
                                        ), // Text
                                        SizedBox(height: h * 0.05),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '\$',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: w * 0.08,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  ' ',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: w * 0.03,
                                                  ),
                                                ),
                                                Text(
                                                  wallets[i].money.toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: w * 0.08,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            //card expiry date
                                            Container(
                                              //padding: EdgeInsets.all(w*0.01,),
                                              // BoxDecoration
                                              child: IconButton(
                                                icon: Icon(
                                                  CupertinoIcons.delete,
                                                  size: w * 0.08,
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                            'Are you sure you want to delete the wallet',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    w * 0.06),
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  deleteWallet(
                                                                      i);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                  "Yes",
                                                                  style: TextStyle(
                                                                      fontSize: w *
                                                                          0.05,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                )),
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Text(
                                                                  "No",
                                                                  style: TextStyle(fontSize: w * 0.05, fontWeight: FontWeight.bold),
                                                                )),
                                                          ],
                                                        );
                                                      });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),

                                      ],
                                    ),
                                  ),

                                );

                              },
                            ),
                            //        //
                            //        //
                            //        //
                            //show wallets
                            //        //
                            //        //
                          )
                        : Container(
                            height: numOfWallets == 0 ? h * 0.1 : h * 0.255,
                            child: Text(
                              'Create A Wallet first!\nBy clicking on the plus icon',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: w * 0.07,color:
                              NightMood ? Colors.white : Colors.grey[900],),
                            ),
                          ),
                    SizedBox(height: h * 0.025),

                    SmoothPageIndicator(
                      controller: _controller,
                      count: numOfWallets,
                      effect: ExpandingDotsEffect(
                        activeDotColor: Colors.grey.shade800,
                      ),
                    ),
                    SizedBox(height: h * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //        //
                        //        //
                        //Pay button
                        //        //
                        //        //
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              // disabledBackgroundColor: Colors.transparent,
                              // disabledForegroundColor: Colors.transparent,
                            ),
                            onPressed: () {
                              value=currentName;
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  )),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Form(
                                        key: withdrawalKey,
                                        child: Container(
                                          height: h * 0.9,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 30),
                                                child:
                                                    //choose the wallet
                                                    Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: StatefulBuilder(
                                                        builder:
                                                            (context, state1) {
                                                      return Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 18,
                                                                vertical: 4),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.blue,
                                                              width: 3),
                                                        ),
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child: DropdownButton<
                                                              String>(
                                                            hint: numOfWallets ==
                                                                    0
                                                                ? const Text(
                                                                    'Create A Wallet First')
                                                                : const Text(
                                                                    'Select Wallet'),
                                                            value: value,
                                                            iconSize: 36,
                                                            isExpanded: true,
                                                            items: walletNames.map(buildMenuItem).toList(),
                                                            onChanged: (value) {
                                                              setState(() => this.value = value);
                                                              state1(() {});
                                                            },
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child:
                                                    //choose the Category
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [

                                                  Padding(
                                                    padding:
                                                     EdgeInsets.all(w*0.02),

                                                    child: StatefulBuilder(
                                                        builder:
                                                            (context, state2) {
                                                          return Container(
                                                            width: w*0.8,
                                                            decoration:
                                                            BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                              border: Border.all(
                                                                  color:
                                                                  Colors.blue,
                                                                  width: 3),
                                                            ),
                                                            child:
                                                            Padding(
                                                              padding:  EdgeInsets.only(left:w*0.04),
                                                              child: DropdownButtonHideUnderline(
                                                                child: DropdownButton<
                                                                    String>(
                                                                  hint: const Text(
                                                                        'Select Category'),

                                                                  value: value1,
                                                                  iconSize: 36,
                                                                  isExpanded: true,
                                                                  items: Category.map(
                                                                      buildMenuItem)
                                                                      .toList(),
                                                                  onChanged:
                                                                      (value1) {
                                                                    setState(() =>
                                                                    this.value1 = value1,

                                                                    );
                                                                    state2(() {
                                                                      if(value1=='New Category +?') {//&&Category.length<12
                                                                        //Navigator.pop(context);
                                                                        //value1 = null;
                                                                        showModalBottomSheet(
                                                                            isScrollControlled: true,
                                                                            shape: const RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.vertical(
                                                                                  top: Radius.circular(16),
                                                                                )),
                                                                            context: context,
                                                                            builder: (BuildContext context) {
                                                                              return SingleChildScrollView(
                                                                                scrollDirection: Axis.vertical,
                                                                                child: Form(
                                                                                  key: newCattKey,
                                                                                  child: Container(
                                                                                    height: h * 0.7,
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Padding(
                                                                                          padding:
                                                                                          const EdgeInsets.all(10.0),
                                                                                          child: TextFormField(
                                                                                            keyboardType:
                                                                                            TextInputType.name,
                                                                                            maxLength: 8,
                                                                                            maxLines: 1,
                                                                                            controller: _newCat,
                                                                                            validator: (value) {
                                                                                              if (value == null || value.isEmpty) {
                                                                                                return "This field is required";
                                                                                              }
                                                                                              if(Category.contains(value))return "This Category already exist!";
                                                                                              return null;
                                                                                            },
                                                                                            //search for (on change function) to make the max line =5
                                                                                            decoration: InputDecoration(
                                                                                              label: const Text(
                                                                                                'Add A new Category:',),
                                                                                              border: OutlineInputBorder(
                                                                                                  borderRadius:
                                                                                                  BorderRadius
                                                                                                      .circular(15)),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        ElevatedButton(
                                                                                            onPressed: ()  {
                                                                                              if (newCattKey.currentState!.validate() == true) {
                                                                                                setState(() {
                                                                                                  Navigator.pop(context);
                                                                                                  //String temp5 = value3!;
                                                                                                  this.value1 = _newCat.text;
                                                                                                  Category.add(_newCat.text);
                                                                                                  int tempTemp=Category.indexOf('New Category +?');
                                                                                                  Category[tempTemp]=_newCat.text;
                                                                                                  Category[tempTemp+1]='New Category +?';
                                                                                                  catCount[_newCat.text]=0;
                                                                                                  catPay[_newCat.text+'1']=0;
                                                                                                  setCateg(_newCat.text);
                                                                                                });
                                                                                                addCategory();
                                                                                                _newCat.clear();
                                                                                                setState(() {
                                                                                                });
                                                                                              }
                                                                                            },
                                                                                            child: const Text("Add")),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            });

                                                                      }

                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }),

                                                  ),
                                                  Container(
                                                    child: IconButton(
                                                      icon: Icon(
                                                        CupertinoIcons.restart,
                                                        size: w * 0.08,
                                                      ),
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                  'All added categories information will be lost!\n Are you sure you want to reset Categories to default?',
                                                                  textAlign: TextAlign
                                                                      .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      w * 0.06),
                                                                ),
                                                                actions: [
                                                                  TextButton(
                                                                      onPressed: () {

                                                                        delCateg(Category.length);
                                                                        Category = [
                                                                          'Food',
                                                                          'Transportation',
                                                                          'Studying',
                                                                          'Gaming',
                                                                          'Robot',
                                                                          'New Category +?',
                                                                        ];

                                                                        Navigator.pop(context);
                                                                        Navigator.pop(context);
                                                                      },

                                                                      child: Text(
                                                                        "Yes",
                                                                        style: TextStyle(
                                                                            fontSize: w *
                                                                                0.05,
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .bold),
                                                                      )),
                                                                  TextButton(
                                                                      onPressed: () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child: Text(
                                                                        "No",
                                                                        style: TextStyle(
                                                                            fontSize: w *
                                                                                0.05,
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .bold),
                                                                      )),
                                                                ],
                                                              );
                                                            });
                                                      },
                                                    ),
                                                  ),
                                                ],),

                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: TextFormField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  //search for (on change function) to make the max line =5
                                                  maxLines: 1,
                                                  maxLength: 8,
                                                  controller: _withdrawalAmount,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty||value.contains(" ")||value.contains("_")||value.contains("-")) {
                                                      return "This field is required";
                                                    }
                                                    return null;
                                                  },
                                                  //search for (on change function) to make the max line =5
                                                  decoration: InputDecoration(
                                                    label: const Text(
                                                        "Amount Of Decrement --"),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15)),
                                                  ),
                                                ),
                                              ),

                                              ElevatedButton(
                                                  onPressed: ()  {
                                                    if (withdrawalKey
                                                            .currentState!
                                                            .validate() ==
                                                        true) {
                                                      //the chosen wallet . balance + or - num
                                                      String timp4 = value1!;
                                                      String temp6 = value!;
                                                      catCount[value1!] = 1 + (catCount[value1!] ?? 0);
                                                      catPay[value1!+'1'] = double.parse(_withdrawalAmount.text) + (catPay[value1!+'1'] ?? 0);
                                                      //catC.put(value1!,catCount[value1!]);
                                                      wallets[walletNames.indexOf(value!)].moneyDec(double.parse(_withdrawalAmount
                                                                  .text));
                                                      walletDec(temp6);
                                                      DateTime tempTime =
                                                          DateTime.now();
                                                      addTransFun(
                                                          tempTime.day,
                                                          tempTime.month,
                                                          tempTime.weekday,
                                                          false,
                                                          double.parse(
                                                              _withdrawalAmount
                                                                  .text),
                                                          wallets[walletNames
                                                                  .indexOf(
                                                                      value!)]
                                                              .name,
                                                          value1!,
                                                          wallets[walletNames
                                                                  .indexOf(
                                                                      value!)]
                                                              .cc);
                                                      transed = true;
                                                      Navigator.pop(context);
                                                      setTransed(timp4);
                                                      //boolss.put('0',transed);

                                                    }
                                                  },
                                                  child: const Text("Done")),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Mybotton(
                              buttinText: 'Withdrawal',
                              imagePath: 'lib/icons/cash-withdrawal.png',
                              buttonNightMood: NightMood,
                            )),
                        //        //
                        //     //
                        //deposit button
                        //    //
                        //        //

                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: () {
                              value3=currentName;
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  )),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Form(
                                        key: depositKey,
                                        child: Container(
                                          height: h * 0.75,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 30),
                                                child:
                                                    //choose the wallet
                                                    Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: StatefulBuilder(
                                                        builder:
                                                            (context, state1) {
                                                      return Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 18,
                                                                vertical: 4),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.blue,
                                                              width: 3),
                                                        ),
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child: DropdownButton<
                                                              String>(
                                                            hint: numOfWallets == 0 ? const Text('Create A Wallet First') : const Text('Select Wallet'),
                                                            value: value3,
                                                            iconSize: 36,
                                                            isExpanded: true,
                                                            items: walletNames
                                                                .map(
                                                                    buildMenuItem)
                                                                .toList(),
                                                            onChanged:
                                                                (value3) {
                                                              setState(() =>
                                                                  this.value3 =
                                                                      value3);
                                                              state1(() {});
                                                            },
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: TextFormField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  maxLength: 8,
                                                  maxLines: 1,
                                                  controller: _Deposit,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty||value.contains(" ")||value.contains("_")||value.contains("-")) {
                                                      return "This field is required";
                                                    }
                                                    return null;
                                                  },
                                                  //search for (on change function) to make the max line =5
                                                  decoration: InputDecoration(
                                                    label: const Text(
                                                        "Amount Of Deposit ++"),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15)),
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                  onPressed: ()  {
                                                    if (depositKey.currentState!
                                                            .validate() ==
                                                        true) {
                                                      //the chosen wallet . balance + or - num
                                                      String temp5 = value3!;
                                                      //walletDec(value1!,double.parse(_withdrawalAmount.text));
                                                      wallets[walletNames.indexOf(value3!)].moneyIncrease(double.parse(_Deposit.text));
                                                      walletDec(temp5);
                                                      DateTime tempTime =
                                                          DateTime.now();
                                                      addTransFun(
                                                          tempTime.day,
                                                          tempTime.month,
                                                          tempTime.weekday,
                                                          true,
                                                          double.parse(
                                                              _Deposit.text),
                                                          wallets[walletNames
                                                                  .indexOf(
                                                                      value3!)]
                                                              .name,
                                                          '--',
                                                          wallets[walletNames
                                                                  .indexOf(
                                                                      value3!)]
                                                              .cc);
                                                      Navigator.pop(context);
                                                      //value3 = null;
                                                      _Deposit.clear();
                                                      transed = true;
                                                      setTransedOnly();
                                                      //boolss.put('0',transed);
                                                    }
                                                  },
                                                  child: const Text("Done")),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Mybotton(
                              buttinText: 'Deposit',
                              imagePath: 'lib/icons/deposit.png',
                              buttonNightMood: NightMood,
                            )),
                        //deposit button
                      ],
                    ),

                    //        //
                    //        //
                    //masroofaty
                    //        //
                    //        //
                    SizedBox(height: h * 0.03),
                    Column(
                      children: [
                        ListTile(
                          leading: Container(
                            height: w * 0.2,
                            padding: EdgeInsets.all(w * 0.014),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(w * 0.018),
                              boxShadow: [
                                if (NightMood == false)
                                  BoxShadow(
                                    color: Colors.grey.shade400,
                                    blurRadius: w * 0.09,
                                    spreadRadius: w * 0.029,
                                  ),
                              ],
                            ),
                            child: Image.asset('lib/icons/budget.png'),
                          ),
                          title: Text(
                            'My Expenses',
                            style: TextStyle(
                              fontSize: w * 0.05,
                              fontWeight: FontWeight.bold,
                              color:
                                  NightMood ? Colors.white : Colors.grey[800],
                            ),
                          ),
                          onTap: () {
                            if (transed) {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  )),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Form(
                                        key: withdrawalKey,
                                        child: Container(
                                          height: h * 0.92,
                                          child: Column(
                                            children: [
                                              SfCircularChart(
                                                title: ChartTitle(
                                                    text:
                                                        'Number of Payments for each Category:'),
                                                legend: Legend(
                                                  isVisible: true,
                                                ),
                                                series: <CircularSeries>[
                                                  PieSeries<GDPData, String>(
                                                    dataSource: getChartData1(),
                                                    xValueMapper:
                                                        (GDPData data, _) =>
                                                            data.continent,
                                                    yValueMapper:
                                                        (GDPData data, _) =>
                                                            data.gdp,
                                                    dataLabelSettings:
                                                        const DataLabelSettings(
                                                      isVisible: true,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Title(
                                                color: Colors.black,
                                                child: Padding(
                                                  padding:  EdgeInsets.symmetric(horizontal: w*0.06),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [

                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(h * 0.015),
                                                        child: Text(
                                                          'My Expenses',
                                                          style: TextStyle(
                                                            fontSize: w * 0.05,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: NightMood
                                                                ? Colors.white
                                                                : Colors.grey[850],
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        //padding: EdgeInsets.all(w*0.01,),
                                                        // BoxDecoration
                                                        child: IconButton(
                                                          icon: Icon(
                                                            CupertinoIcons.delete,
                                                            size: w * 0.08,
                                                          ),
                                                          onPressed: () {
                                                            showDialog(
                                                                context: context,
                                                                builder: (context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                      'Are you sure you want to delete ( All ! ) Transactions?',
                                                                      textAlign: TextAlign
                                                                          .center,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                          w * 0.06),
                                                                    ),
                                                                    actions: [
                                                                      TextButton(
                                                                          onPressed: () {
                                                                            clearAllTrans();
                                                                            if(transed==false)
                                                                            Navigator.pop(
                                                                                context);
                                                                          },
                                                                          child: Text(
                                                                            "Yes",
                                                                            style: TextStyle(
                                                                                fontSize: w *
                                                                                    0.05,
                                                                                fontWeight:
                                                                                FontWeight
                                                                                    .bold),
                                                                          )),
                                                                      TextButton(
                                                                          onPressed: () {
                                                                            Navigator.pop(
                                                                                context);
                                                                          },
                                                                          child: Text(
                                                                            "No",
                                                                            style: TextStyle(
                                                                                fontSize: w *
                                                                                    0.05,
                                                                                fontWeight:
                                                                                FontWeight
                                                                                    .bold),
                                                                          )),
                                                                    ],
                                                                  );
                                                                });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                  onPressed: (){
                                                    Navigator.pop(context);


                                                    showModalBottomSheet(
                                                        isScrollControlled: true,
                                                        shape: const RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.vertical(
                                                              top: Radius.circular(16),
                                                            )),
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return SingleChildScrollView(
                                                            scrollDirection: Axis.vertical,
                                                            child: Form(
                                                              key: withdrawalKey,
                                                              child: Container(
                                                                height: h * 0.8,
                                                                child: Column(
                                                                  children: [
                                                                    SfCircularChart(
                                                                      title: ChartTitle(
                                                                          text:
                                                                          'Amount of money payed for each Category:'),
                                                                      legend: Legend(
                                                                        isVisible: true,
                                                                      ),
                                                                      series: <CircularSeries>[
                                                                        PieSeries<GDPData, String>(
                                                                          dataSource: getChartData2(),
                                                                          xValueMapper:
                                                                              (GDPData data, _) =>
                                                                          data.continent,
                                                                          yValueMapper:
                                                                              (GDPData data, _) =>
                                                                          data.gdp,
                                                                          dataLabelSettings:
                                                                          const DataLabelSettings(
                                                                            isVisible: true,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),

                                                                    Title(
                                                                      color: Colors.black,
                                                                      child: Padding(
                                                                        padding:  EdgeInsets.symmetric(horizontal: w*0.06),
                                                                        child: Column(
                                                                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [

                                                                            Padding(
                                                                              padding:
                                                                              EdgeInsets.all(h * 0.015),
                                                                              child: Text(
                                                                                'Total Amount of money spent:',
                                                                                style: TextStyle(
                                                                                  fontSize: w * 0.05,
                                                                                  fontWeight:
                                                                                  FontWeight.bold,
                                                                                  color: NightMood
                                                                                      ? Colors.white
                                                                                      : Colors.grey[850],
                                                                                ),
                                                                              ),
                                                                            ),

                                                                            Padding(
                                                                              padding:
                                                                              EdgeInsets.all(h * 0.005),
                                                                              child: Text(
                                                                                getTotalExp().toString()+' \$',
                                                                                style: TextStyle(
                                                                                  fontSize: w * 0.1,
                                                                                  fontWeight:
                                                                                  FontWeight.bold,
                                                                                  color: NightMood
                                                                                      ? Colors.white
                                                                                      : Colors.grey[850],
                                                                                ),
                                                                              ),
                                                                            ),


                                                                            Padding(
                                                                              padding:
                                                                              EdgeInsets.all(h * 0.015),
                                                                              child: Text(
                                                                                'Average spending:',
                                                                                style: TextStyle(
                                                                                  fontSize: w * 0.05,
                                                                                  fontWeight:
                                                                                  FontWeight.bold,
                                                                                  color: NightMood
                                                                                      ? Colors.white
                                                                                      : Colors.grey[850],
                                                                                ),
                                                                              ),
                                                                            ),

                                                                            Padding(
                                                                              padding:
                                                                              EdgeInsets.all(h * 0.005),
                                                                              child: Text(
                                                                                (getTotalExp()/totalDays).toString()+' \$',
                                                                                style: TextStyle(
                                                                                  fontSize: w * 0.1,
                                                                                  fontWeight:
                                                                                  FontWeight.bold,
                                                                                  color: NightMood
                                                                                      ? Colors.white
                                                                                      : Colors.grey[850],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),

                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        });




















                                                  },
                                                  child:const Text('More Details')),
                                              Container(
                                                height: h * 0.38,
                                                child: ListView.builder(
                                                  // reverse: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  controller: _controller,
                                                  itemCount: transPrint.length,
                                                  itemBuilder: (context, i) {
                                                    int value = int.parse(
                                                        transColor[
                                                            transPrint.length -
                                                                i -
                                                                1],
                                                        radix: 16);
                                                    Color otherColor =
                                                        Color(value);
                                                    //SizedBox(height: h*0.02);
                                                    return Padding(
                                                      padding: EdgeInsets.only(
                                                          top: h * 0.01),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        w * 0.02),
                                                            child: Container(
                                                              width: w * 0.935,
                                                              padding: EdgeInsets
                                                                  .all(w *
                                                                      0.018),
                                                              decoration: BoxDecoration(
                                                                  color:
                                                                      otherColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(w *
                                                                              0.04)),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  SizedBox(
                                                                      height: h *
                                                                          0.008),
                                                                  Text(
                                                                    transPrint[
                                                                        transPrint.length -
                                                                            i -
                                                                            1],
                                                                    style:
                                                                        TextStyle(
                                                                      //color: Colors.black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          w * 0.05,
                                                                    ), // TextStyle
                                                                  ),
                                                                  // Text
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            } else {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  )),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Form(
                                        key: withdrawalKey,
                                        child: Container(
                                          height: h * 0.4,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.all(w * 0.09),
                                                child: Text(
                                                  numOfWallets == 0
                                                      ? 'Note your first Transaction After adding a New Wallet from the Button up Right!'
                                                      : 'Note your first Transaction !',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    //color: Colors.black,
                                                    fontSize: w * 0.09,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            }
                          },
                          trailing: const Icon(Icons.arrow_forward,),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: h * 0.025,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: w * 0.08),
                          child: Row(
                            children: [
                              Container(
                                //height: h*0.14,
                                decoration: BoxDecoration(
                                  // color: Colors.grey[100],
                                  borderRadius:
                                      BorderRadius.circular(w * 0.036),
                                  boxShadow: [],
                                ),
                                child: Center(
                                  //'lib/icons/cash-withdrawal.png'
                                  child: Icon(CupertinoIcons.moon_stars,color:
                                  NightMood ? Colors.white : Colors.grey[850],),
                                ),
                              ),
                              Switch(
                                  activeColor: Colors.grey[700],
                                  value: NightMood,
                                  onChanged: (value) async {
                                    SharedPreferences pref =
                                        await SharedPreferences.getInstance();
                                    pref.setBool('NightMood', value);
                                    setState(() {

                                      NightMood = value;
                                      darkModeNotifier.value = NightMood;
                                      //darky.put('darky',value);

                                    });
                                  }),
                            ],
                          ),
                        ),

                        //        //
                        //        //
                        //About us
                        //        //
                        //        //

                        Container(
                          child: Padding(
                            padding:  EdgeInsets.only(right: w*0.045),
                            child: FloatingActionButton.extended(
                              onPressed: () {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16),
                                        )),
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Form(
                                          key: withdrawalKey,
                                          child: Container(
                                            height: h * 0.87,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: h * 0.032,
                                                ),

                                                //support Us
                                                ElevatedButton(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return const AlertDialog(
                                                            title: Text(
                                                              'Thank you ❤',
                                                            ),
                                                            content: Text(
                                                                'The Video Will be ready now'),
                                                          );
                                                        });
                                                    _showRewardedAd();
                                                  },
                                                  child: Text(
                                                    'Support Us',
                                                    style: TextStyle(
                                                      fontSize: w * 0.07,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.grey[800],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: h * 0.028),
                                                Container(
                                                  height: h * 0.7,
                                                  child: ListView(children: [
                                                    Center(
                                                      child: Text(
                                                        'About The App',
                                                        style: TextStyle(
                                                          fontSize: w * 0.07,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color: NightMood
                                                              ? Colors.grey[300]
                                                              : Colors
                                                              .grey[900],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.all(
                                                          h * 0.016),
                                                      child: Text(
                                                        'Wallet Manager:\n is a simple application that allows you to split your money into Wallets and allows you to record and watch your Expenses',
                                                        style: TextStyle(
                                                          fontSize: w * 0.06,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color: NightMood
                                                              ? Colors.grey[200]
                                                              : Colors
                                                              .grey[760],
                                                        ),
                                                        textAlign:
                                                        TextAlign.center,
                                                      ),
                                                    ),
                                                    //About YO Games
                                                    Center(
                                                      child: Text(
                                                        'About YO Games',
                                                        style: TextStyle(
                                                          fontSize: w * 0.07,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color: NightMood
                                                              ? Colors.grey[300]
                                                              : Colors
                                                              .grey[900],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.all(
                                                          h * 0.016),
                                                      child: Center(
                                                        child: Text(
                                                          'YO Games:\n is a Mobile Development company founded by:',
                                                          style: TextStyle(
                                                            fontSize: w * 0.06,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            color: NightMood
                                                                ? Colors
                                                                .grey[300]
                                                                : Colors
                                                                .grey[760],
                                                          ),
                                                          textAlign:
                                                          TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    Center(
                                                      child: Text(
                                                        'Yousef Jarbou',
                                                        style: TextStyle(
                                                          fontSize: w * 0.06,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color: NightMood
                                                              ? Colors.grey[250]
                                                              : Colors
                                                              .grey[900],
                                                        ),
                                                        textAlign:
                                                        TextAlign.center,
                                                      ),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          openUrl(yousefURL);
                                                        },
                                                        icon: Image.asset(
                                                            'lib/icons/linkedin.png')),
                                                    Center(
                                                      child: Text(
                                                        'Omar Tobassi',
                                                        style: TextStyle(
                                                          fontSize: w * 0.06,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color: NightMood
                                                              ? Colors.grey[250]
                                                              : Colors
                                                              .grey[900],
                                                        ),
                                                        textAlign:
                                                        TextAlign.center,
                                                      ),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          openUrl(omarURL);
                                                        },
                                                        icon: Image.asset(
                                                            'lib/icons/linkedin.png')),
                                                    Padding(
                                                      padding: EdgeInsets.all(
                                                          h * 0.016),
                                                      child: Center(
                                                        child: Text(
                                                          'We are computer engineering students at Princess Sumaya University for Technology. We are one of the most prominent hobbyists in the field of robotics in Jordan. We participate in programming, problem-solving, and local, Arab and international robotics competitions. Recently, the “Mafia” team representing the company entered the list of the best 1,000 teams in the world in a global competition. IEEE Xtreme. We aspire to reach the stage where we are like a wondrous stick, implementing the ideas of every ambitious young man and turning them into a reality that serves humanity, and we increase knowledge useful to the nation by teaching it and using it by launching valuable projects that enrich the Arab and global market.',
                                                          style: TextStyle(
                                                            fontSize: w * 0.06,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            color: NightMood
                                                                ? Colors
                                                                .grey[200]
                                                                : Colors
                                                                .grey[800],
                                                          ),
                                                          textAlign:
                                                          TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              },
                              backgroundColor: Colors.grey[400],
                              icon: Icon(
                                Icons.home,
                                color: Colors.grey[700],
                              ),
                              label: Text(
                                'About',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                        )
                        //        //
                        //        //
                        //About us
                        //        //
                        //        //
                      ],
                    ),
                    SizedBox(height: h * 0.005,),
                  ]),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          alignment: Alignment.bottomCenter,
                          width: bannerAd!.size.width.toDouble(),
                          height: bannerAd!.size.height.toDouble(),
                          child: AdWidget(ad: bannerAd!),
                        ),
                      ],
                    ),
                  ),
                ]):

                 Center(child: Text("Error"),),

      ),
    );
  }

  Future<void> addWalletFun(String name, double mon, Color c) async {
    setState(() {
      wallets.add(Wallet(name: name, money: mon, cc: c));
      walletNames.add(name);
      _walletNameCont.clear();
      _chashCont.clear();
      numOfWallets++;
      print('---------------\naddWalletFun');
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('numOfWallets', numOfWallets);

    List<String> myS;
    if (pref.getStringList("walletsList") != null) {
      myS = pref.getStringList("walletsList")!;
      myS.add(wallets.last.getWalletInfo());
    } else {
      myS = [wallets.last.getWalletInfo()];
    }
    pref.setStringList("walletsList", myS);
    print(myS);
  }

  Future<void> deleteWallet(int ind) async {
    setState(() {
      wallets.removeAt(ind);
      walletNames.removeAt(ind);
      numOfWallets--;

    });

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('numOfWallets', numOfWallets);
    List<String> myS;
    myS = pref.getStringList("walletsList")!;
    myS.removeAt(ind);
    pref.setStringList("walletsList", myS);
    print(myS);
  }

  Future<void> addTransFun(
    int myDay1,
    int myMonth1,
    int weekD1,
    bool logDeposit1,
    double cashAmount1,
    String logWalletName1,
    String logCat1,
    Color walletColor1,
  ) async {
    setState(() {
      transs.add(TransInfo(
        myDay: myDay1,
        myMonth: myMonth1,
        logDeposit: logDeposit1,
        cashAmount: cashAmount1,
        logWalletName: logWalletName1,
        logCat: logCat1,
        weekD: weekD1,
        walletColor: walletColor1,
      ));
      transPrint.add(transs.last.dataOflog()!);
      if(currentDay!=myDay1)totalDays++;
       if(currentDay!=myDay1)currentDay=myDay1;

      String colorString = transs.last.walletColor.toString();
      String valueString =
          colorString.split('(0x')[1].split(')')[0]; // kind of hacky..
      transColor.add(valueString);
      //value = null;
      value=currentName;
      print('^^^\n^^^\n^^^\n');
      print(currentName);
      print('^^^\n^^^\n^^^\n');
      value1 = null;
      _withdrawalAmount.clear();
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setStringList("transList", transPrint);
    pref.setStringList('transColor', transColor);
    pref.setInt('currentDay', currentDay);
    pref.setInt('totalDays', totalDays);
  }
  Future<void>addCategory()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setStringList("Category", Category);
  }

  String? getDataTrans() {
    for (int u = 0; u < transs.length; u++) {
      return transs[u].dataOflog()!;
    }
  }

  List<GDPData> getChartData1() {
    final List<GDPData> chartData = [];
    for(int i=0;i<Category.length-1;i++){
      if (catCount[Category[i]]! != 0) chartData.add(GDPData(Category[i], catCount[Category[i]]!));
  }
    return chartData;
  }
  List<GDPData> getChartData2() {

    final List<GDPData> chartData = [];
    for(int i=0;i<Category.length-1;i++){
      if (catPay[Category[i]+'1']! != 0) chartData.add(GDPData(Category[i], catPay[Category[i]+'1']!.toInt()));
    }

    return chartData;
  }

  Future<void> walletDec(String wn) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> myS;
    myS = pref.getStringList("walletsList")!;
    myS[walletNames.indexOf(wn)] =
        wallets[walletNames.indexOf(wn)].getWalletInfo();
    pref.setStringList("walletsList", myS);
    print(myS);
  }


  Future<void> openUrl(String url) async {
    final _url = Uri.parse(url);
    if (!await canLaunchUrl(_url)) throw Exception('Could not launch $_url');
    await launchUrl(_url, mode: LaunchMode.externalApplication);
  }

  Future<void> getpref() async {
    await bannerAd!.load();

    await setOpened();

    await _loadRewardedAd();
    SharedPreferences pref = await SharedPreferences.getInstance();

      wallets.clear();
      transs.clear();
      transColor.clear();
      transPrint.clear();
      walletNames.clear();
      if ((pref.getBool('transed')) != null) {
        transed = pref.getBool('transed')!;
      } else {
        transed = false;
      }

      if ((pref.getBool('NightMood')) != null) {
        NightMood = pref.getBool('NightMood')!;
        //N=NightMood;
      } else {
        NightMood = false;
      }
      darkModeNotifier.value = NightMood;

      if ((pref.getInt('numOfWallets')) != null) {
        numOfWallets = pref.getInt('numOfWallets')!;
      } else {
        numOfWallets = 0;
      }

    if ((pref.getInt('currentDay')) != null) {
      currentDay = pref.getInt('currentDay')!;
    } else {
      currentDay = 0;
    }

    if ((pref.getInt('totalDays')) != null) {
      totalDays = pref.getInt('totalDays')!;
    } else {
      totalDays = 0;
    }


      if ((pref.getStringList("walletsList")) != null) {
        for (int i = 0; i < numOfWallets; i++) {
          String n;
          double m;
          Color c;
          String temp1 = pref.getStringList("walletsList")![i];
          List<String> temp2 = temp1.split(",");
          n = temp2[0];
          m = double.parse(temp2[1]);

          String valueString =
              temp2[2].split('(0x')[1].split(')')[0]; // kind of hacky..
          int value = int.parse(valueString, radix: 16);
          c = Color(value);
          wallets.add(Wallet(name: n, money: m, cc: c));
          walletNames.add(n);

        }
      }

      if ((pref.getStringList('Category')) != null) {
        Category = pref.getStringList('Category')!;
      }

    if ((pref.getStringList('transColor')) != null) {
      transColor = pref.getStringList('transColor')!;
    }

      if ((pref.getStringList('transList')) != null) {
        transPrint = pref.getStringList('transList')!;
      }
      for(int i=0;i<Category.length-1;i++){
        if ((pref.getInt(Category[i])) != null) {
          catCount[Category[i]] = pref.getInt(Category[i])!;
        }
      }

    for(int i=0;i<Category.length-1;i++){
      if ((pref.getInt(Category[i]+'1')) != null) {
        catPay[Category[i]+'1'] = pref.getInt(Category[i]+'1')!.toDouble();
      }
    }



    setState(() {
      dataLoaded=true;
    });
    print('---------------\ngetpref');
  }
  Future<void> setTransed(String timp4) async {
    SharedPreferences pref =
    await SharedPreferences
        .getInstance();
    pref.setBool(
        'transed', true);
    pref.setInt(timp4, catCount[timp4]!);
    pref.setInt(timp4+'1', catPay[timp4+'1']!.toInt());
  }

  Future<void> setCateg(String timp4) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt(timp4, catCount[timp4]!);
    pref.setInt(timp4+'1', catPay[timp4+'1']!.toInt());
  }
  Future<void> delCateg(int more) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    for (int i = 5; i < more-1; i++) {
      pref.remove(Category[i]);
      pref.remove(Category[i]+"1");
    }
    setState(() {

    });
  }

  Future<void> setTransedOnly() async {
  SharedPreferences pref =
      await SharedPreferences
      .getInstance();
  pref.setBool(
  'transed', true);}

  Future<void> setOpened() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('opened', true);
  }

  Future<void> clearAllTrans() async {
    setState(() {
      transed=false;
      Navigator.pop(
          context);
    });
    SharedPreferences pref = await SharedPreferences.getInstance();

      transColor.clear();
      pref.remove('transColor');

      transPrint.clear();
      pref.remove('transList');

    for(int i=0;i<Category.length-1;i++){
      catCount[Category[i]] =0; pref.setInt(Category[i],0);
      catPay[Category[i]+'1'] =0; pref.setInt(Category[i]+'1',0);
    }
    pref.remove('currentDay');
    pref.remove('totalDays');
    totalDays=0;
    currentDay=-1;
    pref.setBool('transed', false);


  }
  double getTotalExp(){
    double total=0;
    for(int i=0;i<Category.length-1;i++){
      if (catPay[Category[i]+'1']! != 0) total+=catPay[Category[i]+'1']!;
    }
    return total;
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
}

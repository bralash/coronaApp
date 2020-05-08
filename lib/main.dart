import 'package:coronaapp/constant.dart';
import 'package:coronaapp/countries.dart';
// import 'package:coronaapp/info_screen.dart';
import 'package:coronaapp/widgets/counter.dart';
import 'package:coronaapp/widgets/my_header.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:intl/intl.dart';

void main() {

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

  runApp(MyApp());
}

List countryData = List();
List casesData = List();
String countryId;
var currentDate = DateTime.now();
var month = new DateFormat("dd-MMM-yyyy").format(currentDate);

int infected = 0,
    deaths = 0,
    recovered = 0;

final formatter = new NumberFormat('#,###');

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  
      title: 'Covid 19',
      theme: ThemeData(
        scaffoldBackgroundColor: kBackgroundColor,
        fontFamily: "Poppins",
        textTheme: TextTheme(bodyText2: TextStyle(color: kBodyTextColor))
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen> {

  List<Countries> _countries = Countries.getCountries();
  List<DropdownMenuItem<Countries>> _dropdownMenuItems;
  Countries _selectedCountry;

  @override
  void initState() {
    _dropdownMenuItems = buildDropDownMenuitems(_countries);
    _selectedCountry = _dropdownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<Countries>> buildDropDownMenuitems(List countries) {
    List<DropdownMenuItem<Countries>> items = List();
    for(Countries country in countries) {
      items.add(DropdownMenuItem(
        value: country,
        // child: Text(country.name),
          child: new Text(
              country.name,
              style: TextStyle(
                fontSize: 13.0
              ),
          ),
        ),
      );
    }

    return items;
  }

  onChangeDropdownItem(Countries selectedCountry) {
    setState(() {
      _selectedCountry = selectedCountry;
    });
  }

  Future<String> country() async {
    var response = await http.get(
      Uri.encodeFull('https://covid-19-data.p.rapidapi.com/help/countries'),
      headers: {
        'Accept' : 'application/json',
        'x-rapidapi-host' : 'covid-19-data.p.rapidapi.com',
        'x-rapidapi-key' : 'abb7733e54mshf17b0e16b93d6e9p1ccfb7jsn01a0a716db4a'
      }
    );

    var resBody = json.decode(response.body);

    setState(() {
      countryData = resBody;
    });

    return "Success";
  }

  Future<String> cases(String countryId) async {
    // final formatter = new NumberFormat('#,###');
    final _authority = "covid-19-data.p.rapidapi.com";
    final _path = "/country/code";
    final _params = { "code" : countryId };
    final _uri =  Uri.https(_authority, _path, _params);

    var response = await http.get(_uri,headers: {
        'Accept' : 'application/json',
        'x-rapidapi-host' : 'covid-19-data.p.rapidapi.com',
        'x-rapidapi-key' : 'abb7733e54mshf17b0e16b93d6e9p1ccfb7jsn01a0a716db4a'
    });

    var resBody = json.decode(response.body);
    setState(() {
      for(var i = 0; i <= 0; i++ ) {
        infected = resBody[i]["confirmed"];
        deaths = resBody[i]["deaths"];
        recovered = resBody[i]["recovered"];
      }
    });
    return "Success";
  }

  // Future<String> globalCases() async {
  //   var response = await http.get(
  //     Uri.encodeFull('https://covid-19-data.p.rapidapi.com/totals'),
  //     headers: {
  //       'Accept' : 'application/json',
  //       'x-rapidapi-host' : 'covid-19-data.p.rapidapi.com',
  //       'x-rapidapi-key' : 'abb7733e54mshf17b0e16b93d6e9p1ccfb7jsn01a0a716db4a'
  //     }
  //   );

  //   var resBody = json.decode(response.body);

  //   setState(() {
  //     print(resBody[0]["confirmed"]);
  //   });

  //   return "Success";
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            MyHeader(
              textTop: "All you need",
              textBottom: "is to stay home",
              image: "assets/icons/Drcorona.svg",
              ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Color(0xFFE5E5E5),
                ),
              ),
              child: Row(
                children: <Widget>[
                  SvgPicture.asset("assets/icons/maps-and-flags.svg"),
                  SizedBox(width: 20),
                  Expanded(
                    child: DropdownButton(
                      isExpanded: true,
                      // value: _selectedCountry,
                      hint: Text("Select a country"),
                      items: _dropdownMenuItems,
                      onChanged: (newVal){
                        setState(() {
                          cases(newVal.alpha3code);
                          _selectedCountry = newVal;
                          print(_selectedCountry);
                        });
                      },
                      underline: SizedBox(),
                      icon: SvgPicture.asset("assets/icons/dropdown.svg"),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Case Update \n", 
                              style: kTitleTextstyle
                            ),
                            TextSpan(
                              text: "$month",
                              style: TextStyle(color: kTextLightColor),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [BoxShadow(
                        offset: Offset(0,4),
                        blurRadius: 30, 
                        color: kShadowColor,
                      )]
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Counter(
                          color: kInfectedColor, 
                          number: formatter.format(infected),
                          title: "Infected"
                        ),
                        Counter(
                          color: kDeathColor, 
                          number: formatter.format(deaths),
                          title: "Deaths"
                        ),
                        Counter(
                          color: kRecovercolor, 
                          number: formatter.format(recovered),
                          title: "Recovered"
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


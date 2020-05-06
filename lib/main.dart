import 'package:coronaapp/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

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

int infected = 0,
    deaths = 0,
    recovered = 0;

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
        textTheme: TextTheme(body1: TextStyle(color: kBodyTextColor))
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
    print(resBody[0]["confirmed"].toString());

    
    
    return "Success";
  }

  @override
  void initState() {
    super.initState();
    this.country();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ClipPath(
              clipper: MyClipper(),
              child: Container(
                padding: EdgeInsets.only(left: 40, top: 50, right: 20),
                height: 350,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color(0xFF3383CD),
                      Color(0xFF11249F),
                    ],
                  ),
                  image: DecorationImage(
                    image: AssetImage("assets/images/virus.png"),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topRight,
                      child: SvgPicture.asset("assets/icons/menu.svg"),
                    ),
                    SizedBox(height: 20,),
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          SvgPicture.asset("assets/icons/Drcorona.svg",
                          width: 230,
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.topCenter,
                          ),
                          Positioned(
                            top: 20,
                            left: 150,
                            child: Text("All you need \nis to stay home", 
                              style: kHeadingTextStyle.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(), 
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
                      items: countryData.map((item) {
                        return new DropdownMenuItem(
                          child: new Text(
                            item['name'],
                            style: TextStyle(
                              fontSize: 13.0
                            ),
                          ),
                          value: item['alpha3code'].toString(),
                        );
                      }).toList(),
                      value: countryId,
                      isExpanded: true,
                      hint: new Text("Select country"),
                      icon: SvgPicture.asset("assets/icons/dropdown.svg"),
                      underline: SizedBox(),
                      onChanged: (String newVal) {
                        
                        setState(() {
                          cases(newVal);
                          countryId = newVal;
                          print(countryId.toString());
                        });
                      },
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
                              text: "Newest update 1st May",
                              style: TextStyle(color: kTextLightColor),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Text("See details",
                        style: TextStyle(
                          color: kPrimaryColor, 
                          fontWeight: FontWeight.w600
                        ),
                      ),
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
                          number: infected,
                          title: "Infected"
                        ),
                        Counter(
                          color: kDeathColor, 
                          number: deaths,
                          title: "Deaths"
                        ),
                        Counter(
                          color: kRecovercolor, 
                          number: recovered,
                          title: "Recovered"
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Spread of Virus",
                        style: kTitleTextstyle,
                      ),
                      Text(
                        "See details",
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.all(20),
                    height: 178,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                          offset: Offset(0,10),
                          blurRadius: 30,
                          color: kShadowColor,
                        )
                      ],
                    ),
                    child: Image.asset(
                      "assets/images/map.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class Counter extends StatelessWidget {
  final int number;
  final Color color;
  final String title;
  
  const Counter({
    Key key,
    this.number, 
    this.color, 
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(6),
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(.26),
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(
                color: color,
                width: 2,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          "$number", 
          style: TextStyle(
            fontSize: 30,
            color: color,
          ),
        ),
        Text(title, style: kSubTextStyle),
      ],
    );
  }
}


class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(size.width/2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}


  

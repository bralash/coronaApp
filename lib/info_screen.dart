import 'package:coronaapp/constant.dart';
import 'package:coronaapp/widgets/my_header.dart';
import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MyHeader(
            textTop: "Get to know",
            textBottom: "About Covid-19",
            image: "assets/icons/coronadr.svg",
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal:20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Symptoms",
                  style: kTitleTextstyle,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SymptomsCard(
                      image: "assets/images/headache.png", 
                      title: "Headache",
                      isActive: true,
                    ),
                    SymptomsCard(
                      image: "assets/images/caugh.png", 
                      title: "Cough",
                    ),
                    SymptomsCard(
                      image: "assets/images/fever.png", 
                      title: "Fever",
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "Prevention",
                  style: kTitleTextstyle,
                ),
                SizedBox(height: 20,),
                SizedBox(
                  height: 156,
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: <Widget>[
                      Container(
                        height: 136,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0,8),
                              blurRadius: 24,
                              color: kShadowColor,
                            ),
                          ],
                        ),
                      ),
                      Image.asset("assets/images/wear_mask.png"),
                      Positioned(
                        left: 130,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          height: 136,
                          width: MediaQuery.of(context).size.width - 170,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Wear face mask",
                                style: kTitleTextstyle.copyWith(fontSize:16),
                              ),
                              Text(
                                "Since the start of the coronavirus outbreak some places have fully embraces wearing facemasks",
                                style: TextStyle(
                                  fontSize: 12
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SymptomsCard extends StatelessWidget {
  final String image;
  final String title;
  final bool isActive;
  const SymptomsCard({
    Key key, this.image, this.title, this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          isActive ? 
          BoxShadow(
            offset: Offset(0,10),
            blurRadius: 20,
            color: kActiveShadowColor
          )
          : BoxShadow(
            offset: Offset(0,3),
            blurRadius: 6, 
            color: kShadowColor,
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Image.asset(image, height: 90,),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }
}
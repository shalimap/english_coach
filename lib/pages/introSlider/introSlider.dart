import 'package:englishcoach/config/color.dart';
import 'package:englishcoach/config/widgetHelper.dart';
import 'package:englishcoach/pages/introSlider/data.dart';
import 'package:englishcoach/pages/login/screen/login.dart';
import 'package:flutter/material.dart';

class IntroSliders extends StatefulWidget {
  @override
  _IntroSlidersState createState() => _IntroSlidersState();
}

class _IntroSlidersState extends State<IntroSliders> {
  List<SliderModel> mySLides = [];
  int slideIndex = 0;
  PageController? controller;

  Widget _buildPageIndicator(bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? primaryColor : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mySLides = getSlides();
    controller = new PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [const Color(0xff3C8CE7), const Color(0xff00EAFF)])),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: MediaQuery.of(context).size.height - 100,
          child: PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() {
                slideIndex = index;
              });
            },
            children: <Widget>[
              SlideTile(
                imagePath: mySLides[0].getImageAssetPath(),
              ),
              SlideTile(
                imagePath: mySLides[1].getImageAssetPath(),
              ),
              SlideTile(
                imagePath: mySLides[2].getImageAssetPath(),
              ),
              SlideTile(
                imagePath: mySLides[3].getImageAssetPath(),
              ),
              SlideTile(
                imagePath: mySLides[4].getImageAssetPath(),
              ),
              // SlideTile(
              //   imagePath: mySLides[5].getImageAssetPath(),
              // ),
            ],
          ),
        ),
        bottomSheet: slideIndex != 4
            ? Container(
                margin: EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        controller!.animateToPage(5,
                            duration: Duration(milliseconds: 400),
                            curve: Curves.linear);
                      },
                      child: Text(
                        "SKIP",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          for (int i = 0; i < 5; i++)
                            i == slideIndex
                                ? _buildPageIndicator(true)
                                : _buildPageIndicator(false),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        print("this is slideIndex: $slideIndex");
                        controller!.animateToPage(slideIndex + 1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.linear);
                      },
                      child: Text(
                        "NEXT",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : InkWell(
                onTap: () {
                  WidgetHelper.setPrefrenceBool('isfirst', false);
                  print("Get Started Now");
                  Navigator.of(context)
                      .pushReplacementNamed(LoginPage.routename);
                },
                child: Container(
                  height: 60,
                  color: primaryColor,
                  alignment: Alignment.center,
                  child: Text(
                    "GET STARTED NOW",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
      ),
    );
  }
}

class SlideTile extends StatelessWidget {
  String? imagePath, title, desc;

  SlideTile({this.imagePath, this.title, this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(child: Image.asset(imagePath!)),
        ],
      ),
    );
  }
}

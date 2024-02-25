import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_connect/intro_pages/intro_page1.dart';
import 'package:eco_connect/intro_pages/intro_page2.dart';
import 'package:eco_connect/intro_pages/intro_page3.dart';
import 'package:eco_connect/intro_pages/intro_page4.dart';
import 'package:eco_connect/intro_pages/intro_page5.dart';
import 'package:eco_connect/intro_pages/intro_page6.dart';
import 'package:eco_connect/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  // controller to keep track of page
  PageController _controller = PageController();
  // on last page?
  bool onLastPage = false;
  // current user email
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
          controller: _controller,
          onPageChanged: (index){
            setState(() {
              onLastPage = (index == 5);
            });
          },
          children: [
            IntroPage1(),
            IntroPage2(),
            IntroPage3(),
            IntroPage4(),
            IntroPage5(),
            IntroPage6(),
          ]
        ),
        // dot indicator
        Container(
          alignment: Alignment(0,0.75),
          child: Row(
              mainAxisAlignment:MainAxisAlignment.spaceEvenly,
            children: [
              // skip or back
              !onLastPage?
              // skip
              GestureDetector(
                onTap: (){
                  _controller.jumpToPage(5);
                },
                child: Text("SKIP >>", style:TextStyle(fontSize: 20)),
                ): GestureDetector(
                onTap: (){
                  _controller.jumpToPage(0);
                },
                child: Text("<< BACK", style:TextStyle(fontSize: 20)),
                ),

              // dot indicator
              SmoothPageIndicator(controller: _controller,count:6),

              // next or done
              onLastPage?
              GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return HomePage();
                  }));

                  FirebaseFirestore.instance.collection('Users').doc(currentUser.email!).update({'userHasCompletedOnboarding':true}); 
                },
                child: Text("DONE!", style:TextStyle(fontSize: 20)),
                ):GestureDetector(
                onTap: (){
                  _controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                },
                child: Text("NEXT >", style:TextStyle(fontSize: 20)),
                ),
              
            ],
          ),
        ),
      ]
      ),

      
    );
  }
}
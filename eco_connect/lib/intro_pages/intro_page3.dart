import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage3 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height:500,
                    child: Center(
                      child: Lottie.asset("lib/images/image_share.json"),
                    ),
                  ),
                  Text("Speak With Images"),
                ],
              ),
            );
  }
}
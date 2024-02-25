import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage6 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height:500,
                    child: Center(
                      child: Lottie.asset("lib/images/last.json"),
                    ),
                  ),
                  Text("Ready To Share Your Enthusiasm For Environment?"),
                ],
              ),
            );
  }
}
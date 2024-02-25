import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height:500,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Lottie.asset("lib/images/text_message.json"),
                      ),
                    ),
                  ),
                  Text("Share Your Thoughts in Words"),
                ],
              ),
            );
  }
}
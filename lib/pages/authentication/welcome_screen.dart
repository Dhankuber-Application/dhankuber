import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dhankuber/widgets/custom_button.dart';
import 'package:flutter/material.dart';
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 25),
          child: Column(
            children: [
              Image.asset(
                "assets/logo.png",
                scale: 2,
                height: 200,
                width: width,
              ),
              Image.asset(
                "assets/Dhan-Kuber-name.png",
                scale: 1.5,
                height: 40,
                width: width,
              ),
              const SizedBox(height: 30,),
              const Text("India's App for",
                style: TextStyle(
                    fontSize: 30,
                  color: Color.fromRGBO(253, 102, 31, 1),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Positioned(
                child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 25,
                  color: Color.fromRGBO(4,105,56,1),
                  fontWeight: FontWeight.bold,
                ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(
                          "Fixed Deposits",
                        speed: Duration(milliseconds: 100),
                      ),
                      TyperAnimatedText(
                        "Recurring Deposits",
                        speed: Duration(milliseconds: 100),
                      ),
                      TyperAnimatedText(
                        "Track family's FD/RD",
                        speed: Duration(milliseconds: 100),
                      ),
                    ],
                  ),
                )
              ),
              const SizedBox(height: 150,),
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 15), // base style
                  children: [
                    TextSpan(text: 'By proceeding, I agree to '),
                    TextSpan(
                      text: 'TnC',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ' & '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              //custom button
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  onPressed: () {},
                  text: "Get Started",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import "package:flutter/material.dart";
import "package:payroll_system/widgets/custom_scaffold.dart";
import "package:payroll_system/widgets/welcome_button.dart";

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center, // Centers the children vertically
      children: [
        // Reduce padding around the text to make it closer to the button
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0, // Reduced vertical padding
            horizontal: 40.0,
          ),
          child: Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                children: [
                  TextSpan(
                      text: 'Welcome to Payzo!\n',
                      style: TextStyle(
                        fontSize: 45.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      )),
                  TextSpan(
                      text: '\nYour Seamless Payroll management app',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        // height: 0,
                      ))
                ],
              ),
            ),
          ),
        ),
        // Remove `Flexible` and use just `WelcomeButton`
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 50.0), // Added some vertical spacing
          child: WelcomeButton(),
        ),
      ],
    ));
  }
}

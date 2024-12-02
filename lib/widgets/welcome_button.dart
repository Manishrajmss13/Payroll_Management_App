import "package:flutter/material.dart";
import "package:payroll_system/screens/login_screen.dart";

class WelcomeButton extends StatelessWidget {
  const WelcomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (e) => const LoginScreen()));
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFA500), // Orange
              Color.fromARGB(255, 236, 66, 106),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.2, 1],
          ),
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 20.0, vertical: 10.0), // Add padding here
          child: Text(
            "Let's Go!",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}

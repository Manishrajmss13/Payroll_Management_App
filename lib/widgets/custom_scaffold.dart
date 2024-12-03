import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key, this.child, this.apptitle, this.actionWidget});
  final Widget? child;
  final Widget? apptitle;
  final Widget? actionWidget;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: apptitle,
        centerTitle: true, // Ensures the title is centered
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (actionWidget != null) actionWidget!, // Dynamically render the widget
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Full-screen gradient background
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 23, 107, 204), // Dark blue
                    Color.fromARGB(255, 145, 193, 233), // Light blue
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          // Full-screen layout for content
          Positioned.fill(
            child: SafeArea(
              child: child!,
            ),
          ),
        ],
      ),
    );
  }
}

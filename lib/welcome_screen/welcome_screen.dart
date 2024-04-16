import 'package:capstones/welcome_screen/welcome_screen2.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 200),
                child: Center(
                  child: Image.asset(
                    'images/logo.png',
                    width: 450,
                    height: 350,
                  ),
                ),
              ),
            ],
          ),
          Expanded(child: Container()),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        Welcome2(),
                    transitionsBuilder: (context, animation, secondaryAnimation,
                        child) {
                      const begin = 0.0;
                      const end = 1.0;
                      const curve = Curves.easeInOutQuart;
                      var tween =
                          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      var opacityAnimation = animation.drive(tween);
                      return FadeTransition(
                        opacity: opacityAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ), backgroundColor: Colors.yellow,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                child: Text(
                  'Bắt đầu',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

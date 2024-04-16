import 'package:capstones/welcome_screen/register_screen.dart';
import 'package:flutter/material.dart';
class Welcome2 extends StatefulWidget {
  @override
  State<Welcome2> createState() => _Welcome2PageState();
}

class _Welcome2PageState extends State<Welcome2> {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _page(),
      ),
    );
  }

  Widget _page() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _header(),
              SizedBox(height: 30),
              const SizedBox(height: 20),
              _details(),
              const SizedBox(height: 50),
              _nextButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      child: _roundedLogo(),
    );
  }
  Widget _roundedLogo() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 400,
        height: 400,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/DA-2548.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
  Widget _details() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'CHÀO MỪNG TỚI E1 CARDIO WORKOUT',
          style: TextStyle(
            color: Colors.yellow,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'E1 Cardio Workout : Fitter-Healthier-Happier',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'E1 Cardio Workout là một trong những CLB tiên phong huấn luyện các bài tập và Cardio kết hợp với bộ môn Muay Thái. Với đội ngũ huấn luyện viên chuyên nghiệp, chuyên môn cao sẽ giúp bạn có một sức khỏe và vóc dáng như mong muốn trong thời gian ngắn nhất. Còn chần chờ gì nữa hãy đăng ký lịch tập ngay để cải thiện vóc dáng.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ],
    );
  }


  Widget _nextButton() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => Register(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = 0.0;
                  const end = 1.0;
                  const curve = Curves.easeInOutQuart;

                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  var opacityAnimation = animation.drive(tween);

                  return FadeTransition(
                    opacity: opacityAnimation,
                    child: child,
                  );
                },
              ),
            );
          },
          child: Text(
            "Tiếp theo",
            style: TextStyle(fontSize: 20),
          ),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black, backgroundColor: Colors.yellow, shape: StadiumBorder(),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 130),
          ),
        ),
      ],
    );
  }
}


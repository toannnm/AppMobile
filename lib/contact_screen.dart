import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Liên hệ',
          style: TextStyle(
            color: Colors.white, // Đặt màu chữ thành trắng
          ),
        ),
        backgroundColor: Colors.black, // Đặt màu nền của AppBar thành đen
        iconTheme: IconThemeData(color: Colors.white), // Đặt màu của icon thành trắng
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContactItem(
              icon: Icons.phone,
              text: '0988.027.006 \n'
                  '08.1662.6025',
            ),
            SizedBox(height: 70),
            GestureDetector(
              onTap: () {
                launch('https://www.facebook.com/e1cardioworkout');
              },
              child: ContactItem(
                icon: Icons.facebook,
                text: 'E1 Cardio Workout',
              ),
            ),
            SizedBox(height: 70),
            GestureDetector(
              onTap: () {
                launch('mailto:contact@e1cardio.com');
              },
              child: ContactItem(
                icon: Icons.email,
                text: 'contact@e1cardio.com',
              ),
            ),
            SizedBox(height: 70),
            Flexible(
              child: Column(
                children: [
                  ContactItem(
                    icon: Icons.location_on,
                    text: 'Cơ sở 1:\n'
                        '139 Nguyễn Hữu Cảnh, P22, Quận Bình Thạnh, Tp.Hồ Chí Minh',
                  ),
                  SizedBox(height: 70),
                  ContactItem(
                    icon: Icons.location_on,
                    text: 'Cơ sở 2:\n'
                        '25B Nguyễn Bỉnh Khiêm, P Bến Nghé, Quận 1, Tp.Hồ Chí Minh',
                  ),
                  SizedBox(height: 70),
                  ContactItem(
                    icon: Icons.location_on,
                    text: 'Cơ sở 3:\n'
                        '138 Yersin và 83 Lê Thị Hồng Gấm, P Nguyễn Thái Bình, Quận 1, Tp.Hồ Chí Minh',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const ContactItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.yellow, // Màu nền vàng
            borderRadius: BorderRadius.circular(10), // Bo góc
          ),
          child: Center(
            child: Icon(
              icon,
              size: 30,
              color: Colors.black, // Màu icon
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
            softWrap: true,
          ),
        ),
      ],
    );
  }
}

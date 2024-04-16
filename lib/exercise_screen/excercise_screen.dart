import 'package:flutter/material.dart';

import '../contact_screen.dart';
import '../user_screen/settingchoice_screen.dart';

class Test {
  final String name;
  final String description;
  final String imageUrl;

  Test({
    required this.name,
    required this.description,
    required this.imageUrl,
  });
}

class Exercise1Page extends StatefulWidget {
  final Test exercise;
  final String heroTag;

  Exercise1Page({required this.exercise, required this.heroTag});

  @override
  State<StatefulWidget> createState() => Exercise1PageState();
}

class Exercise1PageState extends State<Exercise1Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _page(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: _homeIcon(),
          ),
          _contactButton(),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: _bottomPersonIcon(),
          ),
        ],
      ),
    );
  }

  Widget _page() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hero widget for the image
            Hero(
              tag: widget.heroTag,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.network(
                      widget.exercise.imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Exercise details
                        Text(
                          widget.exercise.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '| ',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                              ),
                              TextSpan(
                                text: widget.exercise.description,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Admin and Trainer labels with avatar on the left
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://i.pinimg.com/originals/68/54/1d/68541d965a060d7a6c2e8957f999cc17.jpg'),
                  radius: 30,
                ),
                SizedBox(width: 10),
                // Admin and Trainer labels
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Admin label
                    Text(
                      'Admin',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 0),
                    // Trainer label
                    Text(
                      'Trainer',
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30),
            // Rounded gray table with content
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF333333),
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        '6',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Session',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '|', // Vertical bar character
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        '6',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'SessionItem',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '|', // Vertical bar character
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        '200',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Calories',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Adjust padding as needed
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      'Session',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(right: 10),
                    width: 320,
                    child: Card(
                      color: Color(0xFF333333),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Avatar at the top-left
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    'https://i.pinimg.com/originals/68/54/1d/68541d965a060d7a6c2e8957f999cc17.jpg',
                                  ),
                                  radius: 20,
                                ),
                                SizedBox(width: 20),
                                Text(
                                  'SessionItem ${index + 1}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Expanded(
                              child: Text(
                                'Trong cuộc sống hiện đại, việc duy trì một lối sống lành mạnh và chăm sóc sức khỏe trở nên ngày càng quan trọng. Để đạt được sự cân bằng này, chúng ta cần chú ý đến chế độ ăn uống, hoạt động thể chất và tâm lý.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _homeIcon() {
    return FloatingActionButton(
      onPressed: () {
        // Handle back icon click
        Navigator.pop(context); // This will pop the current page and go back
      },
      backgroundColor: Colors.yellow,
      child: Icon(Icons.arrow_back, color: Colors.black),
    );
  }

  Widget _bottomPersonIcon() {
    return FloatingActionButton(
      onPressed: () {
        // Handle person icon click
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingScreen()),
        );
      },
      backgroundColor: Colors.yellow,
      child: Icon(Icons.person, color: Colors.black),
    );
  }
  Widget _contactButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ContactScreen()),
        );
      },
      child: Container(
        width: 180,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            'Liên hệ',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

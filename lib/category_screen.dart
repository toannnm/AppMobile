import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Category extends StatefulWidget {
  @override
  State<Category> createState() => _CategoryPageState();
}

class Exercise {
  final String name;
  final String description;
  final int numberOfDays;
  final int numberOfSessions;

  Exercise({
    required this.name,
    required this.description,
    required this.numberOfDays,
    required this.numberOfSessions,
  });
}

class _CategoryPageState extends State<Category> {
  List<Exercise> exercises = [];
  late List<bool> isBookmarked;

  @override
  void initState() {
    super.initState();
    isBookmarked = List.filled(exercises.length, false);
    fetchData(); 
  }

 Future<void> fetchData() async {
  try {
    final FlutterSecureStorage storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'token');
    if (token != null) {
      var url = Uri.parse('http://localhost:5066/api/Package/demo?pageIndex=1&pageSize=10');
      var response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
       
        setState(() {
          exercises = parseExercises(response.body);
        });
      } else {
       
        print('Request failed with status: ${response.statusCode}');
      }
    } else {
      throw Exception('Token is null');
    }
  } catch (e) {
    print('Error: $e');

  }
}


  List<Exercise> parseExercises(String responseBody) {
    final parsed = jsonDecode(responseBody)['data'].cast<Map<String, dynamic>>();

    return parsed.map<Exercise>((json) => Exercise(
      name: json['packageName'],
      description: json['descriptions'],
      numberOfDays: json['numberOfDays'],
      numberOfSessions: json['numberOfSessions'],
    )).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _page(),
    );
  }

  Widget _page() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        children: [
          _header(),
          const SizedBox(height: 10),
          _exerciseList(),
        ],
      ),
    );
  }

  Widget _header() {
    return AppBar(
      backgroundColor: Colors.black,
      centerTitle: true,
      title: _welcomeText(),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        color: Colors.white,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      iconTheme: IconThemeData(color: Colors.white),
    );
  }

  Widget _welcomeText() {
    return Text(
      'Danh sách bài tập',
      style: TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _exerciseList() {
  return Expanded(
    child: ListView.builder(
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: ListTile(
            title: Text(
              exercises[index].name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28.0,
                color: Colors.black, 
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercises[index].description,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.grey, 
                  ),
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.blue), // Biểu tượng ngày
                    SizedBox(width: 4.0),
                    Text(
                      'Number of Days: ${exercises[index].numberOfDays}',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.0),
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.green), // Biểu tượng buổi tập
                    SizedBox(width: 4.0),
                    Text(
                      'Number of Sessions: ${exercises[index].numberOfSessions}',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

}

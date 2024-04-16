import 'package:capstones/contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:capstones/packageofcus_screen.dart';
import 'package:capstones/category_screen.dart';
import 'package:capstones/user_screen/settingchoice_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:capstones/user_screen/package.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:capstones/user_screen/package.dart';
import 'package:capstones/session_screen.dart';

class Homepage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String token;

  Homepage({
    required this.firstName,
    required this.lastName,
    required this.token,
  });

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String selectedOption = 'Bài tập mới';
  bool isHomePageSelected = true;
  bool isSettingPageSelected = false;
  String firstName = "";
  String lastName = "";

  @override
  void initState() {
    super.initState();
    firstName = widget.firstName;
    lastName = widget.lastName;
  }

  Future<void> refreshData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String newFirstName = prefs.getString('firstName') ?? "";
    String newLastName = prefs.getString('lastName') ?? "";

    setState(() {
      firstName = newFirstName;
      lastName = newLastName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: _page(),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.home,
                  color: isHomePageSelected ? Colors.yellow : Colors.white),
              iconSize: 30,
              onPressed: () async {
                setState(() {
                  isSettingPageSelected = false;
                  isHomePageSelected = true;
                });
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Homepage(
                      firstName: firstName,
                      lastName: lastName,
                      token: widget.token,
                    ),
                  ),
                );
                await refreshData();
                setState(() {
                  firstName = widget.firstName;
                  lastName = widget.lastName;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.person,
                  color: isSettingPageSelected ? Colors.yellow : Colors.white),
              iconSize: 30,
              onPressed: () {
                setState(() {
                  isSettingPageSelected = true;
                  isHomePageSelected = false;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingScreen()),
                ).then((value) {
                  if (value != null && value is Map<String, String>) {
                    setState(() {
                      firstName = value['firstName'] ?? "";
                      lastName = value['lastName'] ?? "";
                    });
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _page() {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            _header(),
            const SizedBox(height: 10),
            _exerciseCard(),
            const SizedBox(height: 10),
            _option(),
            const SizedBox(height: 10),
            _swipeableCardSection(),
            const SizedBox(height: 10),
            _viewCoursebtn(),
            const SizedBox(height: 10),
            _courseText(),
            const SizedBox(height: 10),
            _notiCoursebtn(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _welcomeText(),
        _notificationIcon(context),
      ],
    );
  }

  Widget _welcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        Text(
          '$firstName $lastName',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Future<bool> _onBackPressed() async {
    bool? result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Đăng xuất"),
          content: Text("Bạn có muốn đăng xuất khỏi tài khoản hiện tại không?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Không"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Có"),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Widget _notificationIcon(BuildContext context) {
    return Container(
      width: 36.0,
      height: 36.0,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Stack(
        children: [
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Thông báo"),
                    content: Container(
                      width: 300.0,
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "Đang update thêm",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Đóng"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6.0),
              ),
              constraints: BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              child: Text(
                "2",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _exerciseCard() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.25,
              viewportFraction: 1.0,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              pauseAutoPlayOnTouch: true,
            ),
            items: [
              'https://res.cloudinary.com/dgo4d3e4n/image/upload/v1712742406/download_1_kdsy24.jpg',
              'https://res.cloudinary.com/dgo4d3e4n/image/upload/v1712742406/download_2_k0tykd.jpg',
              'https://res.cloudinary.com/dgo4d3e4n/image/upload/v1712742408/download_pcggaa.jpg',
              'https://res.cloudinary.com/dgo4d3e4n/image/upload/v1712742407/download_3_pje5nl.jpg'
            ].map((item) {
              return Builder(
                builder: (BuildContext context) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image(
                          image: NetworkImage(item),
                          fit: BoxFit.fill,
                          height: double.infinity,
                          width: double.infinity,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.whatshot,
                                  color: Colors.red,
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Bài tập tốt nhất',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 110),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.fade,
                                    child: Category(),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Text(
                                    'Xem thêm',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _option() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _optionText('Bài tập mới'),
        SizedBox(width: 20),
        _optionText('Bài tập phổ biến'),
      ],
    );
  }

  Widget _optionText(String option) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = option;
        });
      },
      child: Text(
        option,
        style: TextStyle(
          fontSize: option == selectedOption ? 25.0 : 18.0,
          color: option == selectedOption ? Colors.white : Colors.grey,
          fontWeight:
              option == selectedOption ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _swipeableCardSection() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return _swipeableImage(index);
        },
      ),
    );
  }

  Widget _swipeableImage(int index) {
    List<String> newCardImages = [
      'https://res.cloudinary.com/dgo4d3e4n/image/upload/v1712742889/download_4_r1w0zw.jpg',
      'https://res.cloudinary.com/dgo4d3e4n/image/upload/v1712742889/images_lleo63.jpg',
      'https://res.cloudinary.com/dgo4d3e4n/image/upload/v1712742889/images_1_fjmnlx.jpg',
    ];

    List<String> cardImages = [
      'https://res.cloudinary.com/dgo4d3e4n/image/upload/v1709745336/cld-sample-3.jpg',
      'https://res.cloudinary.com/dgo4d3e4n/image/upload/v1709745334/cld-sample.jpg',
      'https://res.cloudinary.com/dgo4d3e4n/image/upload/v1709745331/samples/coffee.jpg',
    ];

    int newIndex = index % 3;
    String selectedImage = selectedOption == 'Bài tập mới'
        ? cardImages[newIndex]
        : newCardImages[newIndex];

    return Container(
      margin: EdgeInsets.all(8.0),
      width: 400.0,
      height: 200.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(selectedImage),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _viewCoursebtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: Category(),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "Xem tất cả bài tập",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.yellow,
                shape: StadiumBorder(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _courseText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bài tập của bạn',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PackageOfCustomScreen()),
            );
          },
          child: Text(
            'Xem tất cả',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  String _getIdFromToken(String token) {
    Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
    String? id = decodedToken['id'];
    return id ?? '';
  }

  Future<List<Package>> fetchDataFromAPI() async {
    try {
      final FlutterSecureStorage storage = const FlutterSecureStorage();
      String? token = await storage.read(key: 'token');
      if (token != null) {
        String cid = _getIdFromToken(token);
        Uri uri = Uri.parse(
            'http://localhost:5066/api/Customer/packages/$cid?pageIndex=1&pageSize=10');
        final response = await http.get(
          uri,
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          final List<dynamic> data = jsonData['data'];
          List<Package> packages = [];

          data.forEach((packageData) {
            Package package = Package.fromJson(packageData);
            packages.add(package);
          });

          return packages;
        } else {
          throw Exception('Failed to load data from API');
        }
      } else {
        throw Exception('Token is null');
      }
    } catch (e) {
      throw Exception('Error fetching data from API: $e');
    }
  }

  Widget _notiCoursebtn() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<List<Package>>(
        future: fetchDataFromAPI(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Package>? packages = snapshot.data;
            if (packages != null && packages.isNotEmpty) {
              return CarouselSlider.builder(
                itemCount: packages.length,
                itemBuilder: (BuildContext context, int index, int realIndex) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.yellow,
                    ),
                    child: Stack(
                      children: [
                        Card(
                          elevation: 4,
                          child: ListTile(
                            title: Text(
                              packages[index].packageName,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                Text(
                                  'Days: ${packages[index].numberOfDays}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Sessions: ${packages[index].numberOfSessions}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 300,
                          width: 400,
                          // Lấy chiều rộng màn hình
                          child: Image.network(
                            'https://res.cloudinary.com/dgo4d3e4n/image/upload/v1712763837/download_5_biidxi.jpg',
                            fit: BoxFit.cover, // Thêm fit: BoxFit.cover ở đây
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  packages[index].packageName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Days: ${packages[index].numberOfDays}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Sessions: ${packages[index].numberOfSessions}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 40,
                          child: packages[index].numberOfSessions > 0
                              ? ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SessionScreen()),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                  ),
                                  child: Text(
                                    'More',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        )
                      ],
                    ),
                  );
                },
                options: CarouselOptions(
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
              );
            } else {
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 5),
                color: Colors.yellow,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Text(
                        'Bạn không có bài tập',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ContactScreen()),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              ),
                              child: Text(
                                'Liên hệ',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}

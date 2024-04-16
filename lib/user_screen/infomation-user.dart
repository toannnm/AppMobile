import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'information.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({Key? key}) : super(key: key);

  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  late Future<PersonalInfo> _personalInfoFuture;
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _muscleRatioController = TextEditingController();
  TextEditingController _fatRatioController = TextEditingController();
  TextEditingController _visceralFatLevelsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _personalInfoFuture = fetchPersonalInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back , color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Text(
            'Thông tin cá nhân',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              
            ),
          ),
        ),
      ),
      body: FutureBuilder<PersonalInfo>(
        future: _personalInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Đã xảy ra lỗi: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20),
                    _infoFieldWithLabel(
                        "Họ và tên",
                        "Nhập họ và tên",
                        "${snapshot.data!.firstName} ${snapshot.data!.lastName}",
                        _firstNameController),
                    _infoFieldWithLabel("Email", "Nhập email",
                        "${snapshot.data!.email}", _emailController),
                    _infoFieldWithLabel("Số điện thoại", "Nhập số điện thoại",
                        "${snapshot.data!.phone}", _phoneController),
                    _infoFieldWithLabel(
                        "Ngày sinh",
                        "Nhập ngày sinh",
                        "${DateFormat("yyyy-MM-dd").format(snapshot.data!.dob)}",
                        _dobController),
                    _infoFieldWithLabel("Địa chỉ", "Nhập địa chỉ",
                        "${snapshot.data!.address}", _addressController),
                    _infoFieldWithLabel("Chiều cao", "Nhập chiều cao",
                        "${snapshot.data!.height}", _heightController),
                    _infoFieldWithLabel("Cân nặng", "Nhập cân nặng",
                        "${snapshot.data!.weight}", _weightController),
                    _infoFieldWithLabel("Tỷ lệ cơ bắp", "Nhập tỷ lệ cơ bắp",
                        "${snapshot.data!.muscleRatio}", _muscleRatioController),
                    _infoFieldWithLabel("Tỷ lệ mỡ", "Nhập tỷ lệ mỡ",
                        "${snapshot.data!.fatRatio}", _fatRatioController),
                    _infoFieldWithLabel(
                        "Cấp độ mỡ nội tạng",
                        "Nhập cấp độ mỡ nội tạng",
                        "${snapshot.data!.visceralFatLevels}",
                        _visceralFatLevelsController),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Text('Không có dữ liệu'),
            );
          }
        },
      ),
    );
  }

  Widget _infoFieldWithLabel(String label, String hintText, String initialValue,
      TextEditingController controller) {
    controller.text = initialValue;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: controller,
            readOnly: true,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(color: Colors.white),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<PersonalInfo> fetchPersonalInfo() async {
    try {
      final FlutterSecureStorage storage = const FlutterSecureStorage();
      String? token = await storage.read(key: 'token');
      if (token != null) {
        String cid = _getIdFromToken(token); 

        Uri uri = Uri.parse(
            'http://localhost:5066/info'); 

        final response = await http.get(
          uri,
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          Map<String, dynamic> userData = json.decode(response.body)['data'];

          return PersonalInfo(
            phone: userData['phone'],
            firstName: userData['firstName'],
            lastName: userData['lastName'],
            email: userData['email'],
            dob: DateTime.parse(userData['dob']),
            address: userData['address'],
            height: userData['height'],
            weight: userData['weight'],
            muscleRatio: userData['muscleRatio'],
            fatRatio: userData['fatRatio'],
            visceralFatLevels: userData['visceralFatLevels'],
          );
        } else {
          throw Exception('Failed to fetch user profile');
        }
      } else {
        throw Exception('Token is null');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch user profile');
    }
  }

  String _getIdFromToken(String token) {
    Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
    String? id = decodedToken['id'];
    return id ?? '';
  }
}

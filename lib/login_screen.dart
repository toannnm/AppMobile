import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:capstones/home_screen.dart';
import 'package:capstones/user_screen/information.dart';
import 'dart:convert';
class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginPageState();
}

class Account {
  late String phone;
  late String password;

  Account({
    required this.phone,
    required this.password,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    try {
      return Account(
        phone: json['phone'] as String,
        password: json['password'] as String,
      );
    } catch (e) {
      print('Error parsing account: $e');
      return Account(phone: '', password: '');
    }
  }
}

class _LoginPageState extends State<Login> {
  final storage = FlutterSecureStorage();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  String? _token;

  @override
  void initState() {
    super.initState();
    _checkLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _buildPage(),
    );
  }

  Widget _buildPage() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLogo(),
            SizedBox(height: 50),
            _buildHeader(),
            SizedBox(height: 10),
            const SizedBox(height: 20),
            _buildInputField("Số điện thoại", phone),
            const SizedBox(height: 20),
            _buildInputField("Mật khẩu", password, isPassword: true),
            const SizedBox(height: 100),
            _buildLoginButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 450,
      height: 300,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/logo.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(child: _buildHeaderText('Đăng nhập'));
  }

  Widget _buildHeaderText(String firstLine) {
    return Column(
      children: [
        Text(
          firstLine,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(String hintText, TextEditingController controller,
      {isPassword = false}) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: Colors.white),
    );

    IconData? iconData;

    if (hintText.toLowerCase().contains("số điện thoại")) {
      iconData = Icons.phone;
    } else if (hintText.toLowerCase().contains("mật khẩu") ||
        hintText.toLowerCase().contains("password")) {
      iconData = Icons.lock;
    }

    return TextField(
      style: TextStyle(color: Colors.black),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.black26),
        enabledBorder: border,
        focusedBorder: border,
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(
          iconData,
          color: Colors.black26,
        ),
      ),
      obscureText: isPassword,
    );
  }

  Widget _buildLoginButton() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _handleLogin,
          child: Text(
            "Đăng nhập",
            style: TextStyle(fontSize: 18),
          ),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.yellow,
            shape: StadiumBorder(),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 130),
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
  Future<void> _handleLogin() async {
    void _showLoadingDialog() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text("Logging in..."),
            ],
          ),
        ),
      );
    }

    try {
      _showLoadingDialog();

      String token = await _loginAndGetToken(phone.text, password.text);
      setState(() {
        _token = token;
      });

      Navigator.pop(context); 

      if (token.isNotEmpty) {
        bool loginSuccess = await _validateLogin(token);
        if (loginSuccess) {
          PersonalInfo userData = await fetchPersonalInfo();
          String firstName = userData.firstName;
          String lastName = userData.lastName;

          _showDialog('Success', 'Đăng nhập thành công!');
          _navigateToHomepage(firstName, lastName, token);
        } else {
          _showErrorDialog('Mày không có quyền truy cập đâu con trai.');
        }
      } else {
        _showErrorDialog('Token not received.');
      }
    } catch (e) {
      Navigator.pop(context); 
      print('Error during login: $e');
      _showErrorDialog('Tài khoản không tồn tại');
    }
  }

  Future<String> _loginAndGetToken(String phone, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5066/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'phone': phone,
          'password': password,
        }),
      );

      print('Login response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data.containsKey('data')) {
          String token = data['data'];
          await storage.write(key: 'token', value: token);

          return token;
        } else {
          throw Exception('Token not found in response data');
        }
      } else {
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  Future<bool> _validateLogin(String token) async {
    try {
      Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
      if (decodedToken.containsKey('role') && decodedToken['role'].contains('Customer')) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Error validating token: $e');
    }
  }

void _checkLoggedIn() async {
  String? token = await storage.read(key: 'token');
  if (token != null) {
    bool isValid = await _validateLogin(token);
    if (isValid) {
      String? firstName = await storage.read(key: 'firstName');
      String? lastName = await storage.read(key: 'lastName');
      if (firstName != null && lastName != null) {
        _navigateToHomepage(firstName, lastName, token);
      } else {
        _navigateToHomepage("", "", token);
      }
    }
  }
}


void _navigateToHomepage(String firstName, String lastName, String token) async {
  await storage.write(key: 'firstName', value: firstName);
  await storage.write(key: 'lastName', value: lastName);

  
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => Homepage(
        firstName: firstName,
        lastName: lastName,
        token: token,
      ),
    ),
  );
}





  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
      ),
    );
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Lôĩ rồi kìa'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
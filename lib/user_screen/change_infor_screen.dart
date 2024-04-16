import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'information.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  DateTime? selectedDate;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController muscleRatioController = TextEditingController();
  final TextEditingController fatRatioController = TextEditingController();
  final TextEditingController visceralFatLevelsController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      firstNameController.text = prefs.getString('firstName') ?? '';
      lastNameController.text = prefs.getString('lastName') ?? '';
      phoneController.text = prefs.getString('phone') ?? '';
      emailController.text = prefs.getString('email') ?? '';
      dobController.text = prefs.getString('dob') ?? '';
      addressController.text = prefs.getString('address') ?? '';
      heightController.text = prefs.getDouble('height').toString() ?? '';
      weightController.text = prefs.getDouble('weight').toString() ?? '';
      muscleRatioController.text =
          prefs.getDouble('muscleRatio').toString() ?? '';
      fatRatioController.text = prefs.getDouble('fatRatio').toString() ?? '';
      visceralFatLevelsController.text =
          prefs.getDouble('visceralFatLevels').toString() ?? '';
    });
    try {
      PersonalInfo personalInfo = await fetchPersonalInfo();
      setState(() {
        firstNameController.text = personalInfo.firstName ?? '';
        lastNameController.text = personalInfo.lastName ?? '';
        phoneController.text = personalInfo.phone?? '';
        emailController.text = personalInfo.email ?? '';
        dobController.text =
            DateFormat('dd/MM/yyyy').format(personalInfo.dob ?? DateTime.now());
        addressController.text = personalInfo.address ?? '';
        heightController.text = personalInfo.height.toString() ?? '';
        weightController.text = personalInfo.weight.toString() ?? '';
        muscleRatioController.text = personalInfo.muscleRatio.toString() ?? '';
        fatRatioController.text = personalInfo.fatRatio.toString() ?? '';
        visceralFatLevelsController.text =
            personalInfo.visceralFatLevels.toString() ?? '';
      });
    } catch (e) {
      print('Error loading personal info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 50),
                  Text(
                    'Thay đổi thông tin',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _infoField('Họ và tên đệm', firstNameController, validateName),
            const SizedBox(height: 10),
            _infoField('Tên', lastNameController, validateName),
            const SizedBox(height: 10),
            _infoField('Số điện thoại', phoneController, null),
            const SizedBox(height: 10),
            _infoField('Email', emailController, validateEmail),
            const SizedBox(height: 10),
            _dateTimeField('Ngày sinh', dobController, context),
            const SizedBox(height: 10),
            _infoField('Địa chỉ', addressController, null),
            const SizedBox(height: 10),
            _infoField('Chiều cao (cm)', heightController, validateNumber),
            const SizedBox(height: 10),
            _infoField('Cân nặng (kg)', weightController, validateNumber),
            const SizedBox(height: 10),
            _infoField(
                'Tỷ lệ cơ bắp (%)', muscleRatioController, validateNumber),
            const SizedBox(height: 10),
            _infoField('Tỷ lệ mỡ (%)', fatRatioController, validateNumber),
            const SizedBox(height: 10),
            _infoField('Cấp độ mỡ nội tạng', visceralFatLevelsController,
                validateNumber),
            const SizedBox(height: 10),
            _infoField('Xác thực mật khẩu', newPasswordController, null),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  _updateProfile(context);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: Colors.yellow,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 90,
                  ),
                  child: Text(
                    'Cập nhật thông tin',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _infoField(String label, TextEditingController controller,
      String? Function(String?)? validator) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          TextFormField(
            controller: controller,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
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
            validator: validator,
          ),
        ],
      ),
    );
  }

  Widget _dateTimeField(
    String label,
    TextEditingController controller,
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          ElevatedButton(
            onPressed: () {
              _selectDate(context, controller);
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              backgroundColor: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    controller.text.isNotEmpty ? controller.text : label,
                    style: TextStyle(
                      color: controller.text.isNotEmpty
                          ? Colors.black
                          : Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  const Icon(
                    Icons.calendar_today,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      // Update the selected date
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        selectedDate = pickedDate;
      });
    }
  }

  Future<PersonalInfo> fetchPersonalInfo() async {
    try {
      final FlutterSecureStorage storage = const FlutterSecureStorage();
      String? token = await storage.read(key: 'token');
      if (token != null) {
        String cid = _getIdFromToken(token);
        Uri uri = Uri.parse('http://localhost:5066/info');

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

  Future<void> _updateProfile(BuildContext context) async {
    try {
      final FlutterSecureStorage storage = const FlutterSecureStorage();
      String? token = await storage.read(key: 'token');
      if (token != null) {
        String cid = _getIdFromToken(token);

        Map<String, dynamic> requestBody = {
          "firstName": firstNameController.text,
          "lastName": lastNameController.text,
          "phone": phoneController.text,
          "email": emailController.text,
          "dob": _formatDate(dobController.text),
          "address": addressController.text,
          "height": _toDouble(heightController.text),
          "weight": _toDouble(weightController.text),
          "muscleRatio": _toDouble(muscleRatioController.text),
          "fatRatio": _toDouble(fatRatioController.text),
          "visceralFatLevels": _toDouble(visceralFatLevelsController.text)
        };

        // Kiểm tra xem mật khẩu mới có được cung cấp không
        if (newPasswordController.text.isNotEmpty) {
          requestBody["password"] = newPasswordController.text;
        }

        Dio dio = Dio();
        Response response = await dio.put(
          'http://localhost:5066/api/Authentication/update',
          data: requestBody,
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
        );

        if (response.statusCode == 200) {
          _showSuccessDialog(context);
          _refreshUI();
        } else {
          _showFailureDialog(context);
        }
      } else {
        throw Exception('Token is null');
      }
    } catch (e) {
      _showErrorDialog(context);
    }
  }

  void _refreshUI() {
    _loadSavedData();
  }

  void _saveUpdatedDataToSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('phone', phoneController.text);
    prefs.setString('firstName', firstNameController.text);
    prefs.setString('lastName', lastNameController.text);
    prefs.setString('email', emailController.text);
    prefs.setString('dob', dobController.text);
    prefs.setString('address', addressController.text);
    prefs.setDouble('height', _toDouble(heightController.text));
    prefs.setDouble('weight', _toDouble(weightController.text));
    prefs.setDouble('muscleRatio', _toDouble(muscleRatioController.text));
    prefs.setDouble('fatRatio', _toDouble(fatRatioController.text));
    prefs.setDouble(
        'visceralFatLevels', _toDouble(visceralFatLevelsController.text));
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.dark(),
          child: AlertDialog(
            title: Text(
              'Thông báo',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Cập nhật thông tin thành công',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFailureDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.dark(),
          child: AlertDialog(
            title: Text(
              'Thông báo',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Cập nhật thông tin thất bại',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.dark(),
          child: AlertDialog(
            title: Text(
              'Thông báo',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Đã xảy ra lỗi, vui lòng thử lại sau',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(String? inputDate) {
    if (inputDate != null && inputDate.isNotEmpty) {
      DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(inputDate);
      String formattedDate =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(parsedDate);
      return formattedDate;
    }
    return '';
  }

  double _toDouble(String? value) {
    if (value != null && value.isNotEmpty) {
      return double.parse(value);
    }
    return 0.0;
  }

  String _getIdFromToken(String token) {
    Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
    String? id = decodedToken['id'];
    return id ?? '';
  }
}

String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Vui lòng nhập tên';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Vui lòng nhập địa chỉ email';
  } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return 'Địa chỉ email không hợp lệ';
  }
  return null;
}

String? validateDate(String? value) {
  if (value == null || value.isEmpty) {
    return 'Vui lòng chọn ngày sinh';
  }
  return null;
}

String? validateNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Vui lòng nhập số';
  } else if (double.tryParse(value) == null) {
    return 'Giá trị không hợp lệ';
  }
  return null;
}

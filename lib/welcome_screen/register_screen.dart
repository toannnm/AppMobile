import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<Register> {
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController height = TextEditingController();
  TextEditingController muscleRatio = TextEditingController();
  TextEditingController fatRatio = TextEditingController();
  TextEditingController visceralFatLevel = TextEditingController();
  DateTime? selectedDate;

  final _formKey = GlobalKey<FormState>();

  bool _isRegisterStepOne = true;
  bool _isRegistrationSuccess = false;

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<bool> _registerCustomer() async {
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    final Dio dio = Dio();
    final String url = 'http://localhost:5066/new_customer';

    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    final DateTime currentTime = DateTime.now();

    final Map<String, dynamic> requestData = {
      "phone": phoneNumber.text,
      "password": password.text,
      "firstName": firstname.text,
      "lastName": lastname.text,
      "email": email.text,
      "dob": selectedDate != null ? _formatDate(selectedDate!) + "T" + DateFormat('HH:mm:ss').format(currentTime) + "Z" : null,
      "address": address.text,
      "height": double.tryParse(height.text) ?? 0,
      "weight": double.tryParse(weight.text) ?? 0,
      "muscleRatio": double.tryParse(muscleRatio.text) ?? 0,
      "fatRatio": double.tryParse(fatRatio.text) ?? 0,
      "visceralFatLevels": double.tryParse(visceralFatLevel.text) ?? 0
    };

    try {
      final Response response = await dio.post(
        url,
        data: jsonEncode(requestData),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isRegistrationSuccess = true;
        });

     
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
               backgroundColor: Colors.black,
              title: Text("Success",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              content: Text("Đăng ký thành công.",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                Navigator.of(context).pop(); 
                Navigator.pushNamed(context, '/login'); 
              },
                  child: Text("OK",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ),
              ],
            );
          },
        );
        return true;
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Failed to register. Please try again later."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
        return false;
      }
    } catch (e) {
      print('Error: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Opps"),
            content: Text("Số điện thoại này đã được đăng ký!"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      return false;
    }
  }

  Widget _headerText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _inputField(String hintText, TextEditingController controller, {bool isPassword = false, String? Function(String?)? validator}) {
    return TextFormField(
      style: TextStyle(color: Colors.black),
      controller: controller,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black26),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(
          Icons.person,
          color: Colors.black26,
        ),
      ),
      obscureText: isPassword,
      validator: validator,
    );
  }

  Widget _dobButton() {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.white,
      ),
      child: TextButton(
        onPressed: () async {
          selectedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          setState(() {});
        },
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: Colors.black26,
            ),
            SizedBox(width: 10),
            Text(
              selectedDate != null ? formatter.format(selectedDate!) : "Chọn Ngày Sinh",
              style: TextStyle(
                color: selectedDate != null ? Colors.black : Colors.black26,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nextButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          setState(() {
            _isRegisterStepOne = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Vui lòng điền đầy đủ thông tin.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Text(
        "Tiếp theo",
        style: TextStyle(fontSize: 20),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.yellow,
        shape: StadiumBorder(),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 130),
      ),
    );
  }

  Widget _completeButton() {
    return ElevatedButton(
      onPressed: _isRegistrationSuccess ? null : _registerCustomer,
      child: Text(
        "Hoàn thành",
        style: TextStyle(fontSize: 20),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.yellow,
        shape: StadiumBorder(),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 100),
      ),
    );
  }

  Widget _loginText(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/login');
      },
      child: RichText(
        text: TextSpan(
          text: 'Bạn đã có tài khoản? ',
          style: TextStyle(
            color: Colors.white,
          ),
          children: [
            TextSpan(
              text: 'Đăng nhập tại đây',
              style: TextStyle(
                color: Colors.yellow,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputFieldWithIcon(String hintText, TextEditingController controller, IconData icon, {String? Function(String?)? validator}) {
    return TextFormField(
      style: TextStyle(color: Colors.black),
      controller: controller,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black26),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.red), 
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(
          icon,
          color: Colors.black26,
        ),
      ),
      validator: validator,
    );
  }


  Widget _labelText(String text) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple, Colors.purpleAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!_isRegisterStepOne) {
          setState(() {
            _isRegisterStepOne = true;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  const SizedBox(height: 20),
                  _isRegisterStepOne
                      ? Column(
                          children: [
                            _headerText('Đăng ký tài khoản'),
                            const SizedBox(height: 20),
                            _inputField("Họ", firstname, validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập họ.';
                              }
                              return null;
                            }),
                            const SizedBox(height: 20),
                            _inputField("Tên", lastname, validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập tên.';
                              }
                              return null;
                            }),
                            const SizedBox(height: 20),
                            _inputField("Email", email, validator: validateEmail),
                            const SizedBox(height: 20),
                            _inputField("Số điện thoại", phoneNumber, validator: validatePhoneNumber),
                            const SizedBox(height: 20),
                            _inputField("Mật khẩu", password, isPassword: true, validator: validatePassword),
                            const SizedBox(height: 20),
                            _inputField("Địa chỉ", address, validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập địa chỉ.';
                              }
                              return null;
                            }),
                            const SizedBox(height: 20),
                            _dobButton(),
                          ],
                        )
                      : _buildRegisterStepTwo(),
                  const SizedBox(height: 80),
                  _isRegisterStepOne ? _nextButton() : _completeButton(),
                  const SizedBox(height: 20),
                  _loginText(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterStepTwo() {
    return Column(
      children: [
        _headerText('Hoàn thành hồ sơ đăng ký của bạn'),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: _inputFieldWithIcon("Cân nặng", weight, Icons.fitness_center, validator: validateNumeric),
            ),
            const SizedBox(width: 15),
            Expanded(
              flex: 2,
              child: _labelText('KG'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: _inputFieldWithIcon("Chiều cao", height, Icons.height, validator: validateNumeric),
            ),
            const SizedBox(width: 15),
            Expanded(
              flex: 2,
              child: _labelText('CM'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _inputFieldWithIcon("Tỷ lệ cơ bắp", muscleRatio, Icons.fitness_center, validator: validateNumeric),
        const SizedBox(height: 20),
        _inputFieldWithIcon("Tỷ lệ mỡ", fatRatio, Icons.accessibility, validator: validateNumeric),
        const SizedBox(height: 20),
        _inputFieldWithIcon("Cấp độ mỡ nội tạng", visceralFatLevel, Icons.favorite_border, validator: validateNumeric),
        const SizedBox(height: 20),
      ],
    );
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email.';
    }
    if (!RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b').hasMatch(value)) {
      return 'Email không hợp lệ.';
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập số điện thoại.';
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'Số điện thoại không hợp lệ.';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu.';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự.';
    }
    return null;
  }

  String? validateNumeric(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập giá trị số.';
    }
    if (double.tryParse(value) == null) {
      return 'Giá trị nhập vào phải là số.';
    }
    return null;
  }
}

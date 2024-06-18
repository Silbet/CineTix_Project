import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _errorMessage = '';

  Future<void> _signup() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;
    String name = _nameController.text;
    String birthdate = _birthdateController.text;
    String phone = _phoneController.text;

    if (email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        name.isEmpty ||
        birthdate.isEmpty ||
        phone.isEmpty) {
      setState(() {
        _errorMessage = '모든 필수 정보를 입력해주세요.';
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        _errorMessage = '비밀번호를 6글자 이상으로 입력하세요.';
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _errorMessage = '비밀번호가 일치하지 않습니다.';
      });
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        // 추가 사용자 정보 저장 로직 구현 가능
        Navigator.pop(context); // 회원가입 후 로그인 화면으로 돌아가기
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'email-already-in-use') {
          _errorMessage = '이미 사용 중인 이메일입니다.';
        } else {
          _errorMessage = '회원가입에 실패했습니다. 다시 시도해주세요.';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('회원가입'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Image.asset('assets/CineTix_logo.png'), // 로컬 이미지 경로
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTextField(_emailController, '아이디'),
              SizedBox(height: 16.0),
              _buildPasswordField(_passwordController, '비밀번호'),
              SizedBox(height: 16.0),
              _buildPasswordField(_confirmPasswordController, '비밀번호 확인'),
              SizedBox(height: 16.0),
              _buildTextField(_nameController, '이름'),
              SizedBox(height: 16.0),
              _buildTextField(_birthdateController, '생년월일 8자리', inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8),
                BirthdateInputFormatter(),
              ]),
              SizedBox(height: 16.0),
              _buildPhoneField(),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _signup,
                child: Text('회원가입'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 50)),
                ),
              ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, {List<TextInputFormatter>? inputFormatters}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.black),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
      ),
      style: TextStyle(color: Colors.black),
      cursorColor: Colors.black,
      inputFormatters: inputFormatters,
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String labelText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.black),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
      ),
      obscureText: true,
      style: TextStyle(color: Colors.black),
      cursorColor: Colors.black,
    );
  }

  Widget _buildPhoneField() {
    return TextField(
      controller: _phoneController,
      decoration: InputDecoration(
        labelText: '휴대전화번호',
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.black),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        prefixIcon: Icon(Icons.phone, color: Colors.black),
      ),
      keyboardType: TextInputType.phone,
      style: TextStyle(color: Colors.black),
      cursorColor: Colors.black,
    );
  }
}

class BirthdateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.length > 8) return oldValue;

    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i == 3 || i == 5) && i != text.length - 1) {
        buffer.write('.');
      }
    }

    return newValue.copyWith(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

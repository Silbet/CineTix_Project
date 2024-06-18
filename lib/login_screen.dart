import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_page.dart';
import 'admin_page.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  String _errorMessage = '';

  Future<void> _login() async {
    String id = _idController.text;
    String pw = _pwController.text;

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: id,
        password: pw,
      );
      User? user = userCredential.user;

      if (user != null) {
        if (user.email == 'admin@admin.com') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminPage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UserPage()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'user-not-found') {
          _errorMessage = '사용자를 찾을 수 없습니다.';
        } else if (e.code == 'wrong-password') {
          _errorMessage = '잘못된 비밀번호입니다.';
        } else {
          _errorMessage = '오류가 발생했습니다. 다시 시도해주세요.';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/CineTix_logo.png', // 로고 이미지 경로
              height: 100,
            ),
            SizedBox(height: 32.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.grey),
              ),
              child: TextField(
                controller: _idController,
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: 'ID',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.grey),
              ),
              child: TextField(
                controller: _pwController,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  labelText: 'Password',
                  border: InputBorder.none,
                ),
                obscureText: true,
              ),
            ),
            SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _login,
                child: Text('로그인'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupScreen()),
                );
              },
              child: Text('회원가입', style: TextStyle(color: Colors.black)),
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
    );
  }
}

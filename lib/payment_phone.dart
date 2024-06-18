import 'package:flutter/material.dart';
import 'payment.dart';

String globalTelecom = '';
String globalName = '';
String globalPhoneNumber = '';
String globalGender = '';
String globalVerificationCode = '';

class PhonePaymentStrategy implements PaymentStrategy {
  @override
  void pay(double amount) {
    print('휴대폰 결제: $amount 원');
  }
}

class PhonePaymentDialog extends StatefulWidget {
  final Function(bool success) onPaymentResult;

  PhonePaymentDialog({required this.onPaymentResult});

  @override
  _PhonePaymentDialogState createState() => _PhonePaymentDialogState();
}

class _PhonePaymentDialogState extends State<PhonePaymentDialog> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _verificationCodeController = TextEditingController();

  String _selectedTelecom = '파이썬 통신';
  String _selectedGender = '남';
  String _verificationCode = '';

  @override
  void initState() {
    super.initState();
    _nameController.text = globalName;
    _phoneNumberController.text = globalPhoneNumber;
    _verificationCodeController.text = globalVerificationCode;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('휴대폰 결제'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedTelecom,
              decoration: InputDecoration(
                labelText: '통신사 선택',
              ),
              items: ['파이썬 통신', '자바 통신', '플러터 통신']
                  .map((telecom) => DropdownMenuItem<String>(
                        value: telecom,
                        child: Text(telecom),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTelecom = value!;
                });
              },
            ),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '이름',
              ),
              onChanged: (value) {
                setState(() {
                  globalName = value;
                });
              },
            ),
            TextFormField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: '휴대폰 번호',
                hintText: '010-0000-0000',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  globalPhoneNumber = value;
                });
                if (value.length == 4 || value.length == 9) {
                  _phoneNumberController.value = TextEditingValue(
                    text: value.substring(0, value.length - 1) +
                        '-' +
                        value.substring(value.length - 1),
                    selection: TextSelection.collapsed(offset: value.length),
                  );
                }
              },
            ),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: InputDecoration(
                labelText: '성별 선택',
              ),
              items: ['남', '여', '중']
                  .map((gender) => DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _verificationCode = '1234';
                });
              },
              child: Text('인증번호 받기'),
            ),
            if (_verificationCode.isNotEmpty)
              Text(
                '인증번호 : $_verificationCode',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            TextFormField(
              controller: _verificationCodeController,
              decoration: InputDecoration(
                labelText: '인증번호',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  globalVerificationCode = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            _saveEnteredData();
            _processPayment();
          },
          child: Text('결제하기'),
        ),
      ],
    );
  }

  void _saveEnteredData() {
    globalTelecom = _selectedTelecom;
    globalName = _nameController.text;
    globalPhoneNumber = _phoneNumberController.text;
    globalGender = _selectedGender;
    globalVerificationCode = _verificationCodeController.text;
  }

  void _processPayment() {
    bool success = false;
    String message = '';

    // 선택한 통신사에 따라 성공 또는 실패를 시뮬레이션합니다.
    if (_verificationCodeController.text == _verificationCode) {
      success = true; // 인증번호 일치
    } else {
      message = '인증번호가 틀렸습니다.';
    }

    if (success) {
      widget.onPaymentResult(true);
      Navigator.pop(context, true);
    } else {
      _showAlertDialog(message);
    }
  }

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('알림'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _verificationCodeController.dispose();
    super.dispose();
  }
}

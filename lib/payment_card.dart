import 'package:flutter/material.dart';
import 'payment.dart';

String globalCardNumber = '';
String globalExpiryDate = '';
String globalCVC = '';
String globalPassword = '';

class CardPaymentStrategy implements PaymentStrategy {
  @override
  void pay(double amount) {
    print('카드 결제: $amount 원');
  }
}

class CardPaymentDialog extends StatefulWidget {
  final Function(bool success) onPaymentResult;

  CardPaymentDialog({required this.onPaymentResult});

  @override
  _CardPaymentDialogState createState() => _CardPaymentDialogState();
}

class _CardPaymentDialogState extends State<CardPaymentDialog> {
  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _expiryDateController = TextEditingController();
  TextEditingController _cvcController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _showCVC = false;
  bool _showPassword = false;
  String _selectedBank = '파이썬 은행';

  @override
  void initState() {
    super.initState();
    _cardNumberController.text = globalCardNumber;
    _expiryDateController.text = globalExpiryDate;
    _cvcController.text = globalCVC;
    _passwordController.text = globalPassword;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('카드 결제'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedBank,
              decoration: InputDecoration(
                labelText: '결제사 선택',
              ),
              items: ['파이썬 은행', '자바 은행', '플러터 은행']
                  .map((bank) => DropdownMenuItem<String>(
                        value: bank,
                        child: Text(bank),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBank = value!;
                });
              },
            ),
            TextFormField(
              controller: _cardNumberController,
              decoration: InputDecoration(
                labelText: '카드 번호',
                suffixIcon: IconButton(
                  icon: Icon(Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _showCVC = !_showCVC;
                      _showPassword = false;
                    });
                  },
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  globalCardNumber = value;
                });
                if (value.length == 5 ||
                    value.length == 10 ||
                    value.length == 15) {
                  _cardNumberController.value = TextEditingValue(
                    text: value.substring(0, value.length - 1) +
                        '-' +
                        value.substring(value.length - 1),
                    selection: TextSelection.collapsed(offset: value.length),
                  );
                }
              },
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _expiryDateController,
                    decoration: InputDecoration(
                      labelText: '유효기간 (MM/YY)',
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 5,
                    onChanged: (value) {
                      setState(() {
                        globalExpiryDate = value;
                      });
                      if (value.length == 2 && !value.contains('/')) {
                        _expiryDateController.value = TextEditingValue(
                          text: value.substring(0, 2) + '/',
                          selection:
                              TextSelection.collapsed(offset: value.length + 1),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _cvcController,
                    obscureText: !_showCVC,
                    decoration: InputDecoration(
                      labelText: 'CVC',
                      suffixIcon: IconButton(
                        icon: Icon(
                            _showCVC ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _showCVC = !_showCVC;
                            _showPassword = false;
                          });
                        },
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    onChanged: (value) {
                      setState(() {
                        globalCVC = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: !_showPassword,
              decoration: InputDecoration(
                labelText: '결제 비밀번호',
                suffixIcon: IconButton(
                  icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                      _showCVC = false;
                    });
                  },
                ),
              ),
              keyboardType: TextInputType.number,
              maxLength: 4,
              onChanged: (value) {
                setState(() {
                  globalPassword = value;
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
    globalCardNumber = _cardNumberController.text;
    globalExpiryDate = _expiryDateController.text;
    globalCVC = _cvcController.text;
    globalPassword = _passwordController.text;
  }

  void _processPayment() {
    bool success = false;
    String message = '';

    if (_selectedBank == '파이썬 은행') {
      success = true;
    } else if (_selectedBank == '자바 은행') {
      message = '일치하는 카드 정보가 없습니다.';
    } else if (_selectedBank == '플러터 은행') {
      message = '잔액이 부족합니다.';
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
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvcController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

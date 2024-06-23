import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'country_selector.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone Number Validation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PhoneNumberValidationPage(),
    );
  }
}

class PhoneNumberValidationPage extends StatefulWidget {
  @override
  _PhoneNumberValidationPageState createState() => _PhoneNumberValidationPageState();
}

class _PhoneNumberValidationPageState extends State<PhoneNumberValidationPage> {
  String countryCode = '852';
  String flagAsset = 'hk';
  TextEditingController phoneNumberController = TextEditingController();

  void updateCountry(String code, String flag) {
    setState(() {
      countryCode = code;
      flagAsset = flag;
    });
  }

  void storePhoneNumber(String phoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('phoneNumber', phoneNumber);
  }

  Future<void> validatePhoneNumber(String phoneNumber) async {
    final accountSid = ''; 
    final authToken = ''; 
    final basicAuth =
        'Basic ' + base64Encode(utf8.encode('$accountSid:$authToken'));

    // print(countryCode);
    // print(phoneNumber);
    String flagAssetUpper = flagAsset.toUpperCase();
    // print(flagAssetIpper);
    String judge = countryCode + phoneNumber;
    print(judge);

    final response = await http.get(
      // Uri.parse('https://lookups.twilio.com/v1/PhoneNumbers/$phoneNumber?CountryCode=${countryCode.substring(1)}'),
      Uri.parse('https://lookups.twilio.com/v1/PhoneNumbers/$judge?CountryCode=$flagAssetUpper'),
      headers: {
        'Authorization': basicAuth,
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final formattedNumber = responseData['phone_number'];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ValidationResultPage(
            phoneNumber: formattedNumber,
            isValid: true,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ValidationResultPage(
            phoneNumber: phoneNumber,
            isValid: false,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Validate phone number')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'assets/phone_icon.svg', // 确保在项目的 assets 目录下有这个文件
              height: 100,
            ),
            SizedBox(height: 20),
            Text('Please enter a phone number:'),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CountrySelectorPage(),
                      ),
                    );
                    if (result != null) {
                      updateCountry(result['code'], result['flag']);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: <Widget>[
                        SvgPicture.network(
                          'https://cdn.jsdelivr.net/gh/lipis/flag-icons/flags/4x3/$flagAsset.svg',
                          height: 24,
                        ),
                        SizedBox(width: 8),
                        Text(countryCode),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Phone Number',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final phoneNumber = phoneNumberController.text;
                storePhoneNumber(phoneNumber);
                await validatePhoneNumber(phoneNumber);
              },
              child: Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}

class ValidationResultPage extends StatelessWidget {
  final String phoneNumber;
  final bool isValid;

  ValidationResultPage({required this.phoneNumber, required this.isValid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Validation Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Phone Number: $phoneNumber',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              isValid ? 'Valid' : 'Invalid',
              style: TextStyle(
                fontSize: 24,
                color: isValid ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

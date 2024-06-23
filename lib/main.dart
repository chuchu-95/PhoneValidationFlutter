import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'country_selector.dart';

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
  String countryCode = '+852';
  String flagAsset = 'hk';

  void updateCountry(String code, String flag) {
    setState(() {
      countryCode = code;
      flagAsset = flag;
    });
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
              onPressed: () {},
              child: Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'country_selector.dart';
import 'validation_bloc.dart';
import 'validation_event.dart';
import 'validation_state.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone Number Validation',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.dark().copyWith(
          primary: Colors.blue,
          secondary: Colors.blue,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: UnderlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white, 
          ),
        ),
      ),
      home: BlocProvider(
        create: (context) => ValidationBloc(),
        child: PhoneNumberValidationPage(),
      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Validate phone number')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'assets/phone_icon.svg',
              height: 100,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text('Please enter a phone number:', style: TextStyle(color: Colors.white)),
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
                    height: 54,
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5), 
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
                        Text(countryCode, style: TextStyle(color: Colors.black)),
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
                      border: UnderlineInputBorder(), 
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(color: Color.fromARGB(255, 99, 98, 98)),
                      fillColor: Colors.transparent,
                      filled: true,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            BlocConsumer<ValidationBloc, ValidationState>(
              listener: (context, state) {
                if (state is ValidationSuccess) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ValidationResultPage(
                        phoneNumber: state.phoneNumber,
                        isValid: true,
                      ),
                    ),
                  );
                } else if (state is ValidationFailure) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ValidationResultPage(
                        phoneNumber: phoneNumberController.text,
                        isValid: false,
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is ValidationLoading) {
                  return CircularProgressIndicator();
                }

                return ElevatedButton(
                  onPressed: () {
                    final phoneNumber = phoneNumberController.text;
                    storePhoneNumber(phoneNumber);
                    BlocProvider.of<ValidationBloc>(context).add(
                      ValidatePhoneNumber(countryCode: countryCode, phoneNumber: phoneNumber, flagAsset: flagAsset),
                    );
                  },
                  child: Text('Confirm'),
                );
              },
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
              style: TextStyle(fontSize: 20, color: Colors.white),
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

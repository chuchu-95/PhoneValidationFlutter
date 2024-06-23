import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CountrySelectorPage extends StatefulWidget {
  @override
  _CountrySelectorPageState createState() => _CountrySelectorPageState();
}

class _CountrySelectorPageState extends State<CountrySelectorPage> {
  List<dynamic> countryList = [];
  List<dynamic> filteredList = [];
  bool isLoading = true;
  bool hasError = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCountries();
  }

  void fetchCountries() async {
    try {
      final headers = {
        'Access-Control-Allow-Origin': '*',
      };

      final namesResponse = await http.get(
        Uri.parse('http://127.0.0.1:3000/api/names.json'),
        headers: headers,
      );
      final phoneResponse = await http.get(
        Uri.parse('http://127.0.0.1:3000/api/phone.json'),
        headers: headers,
      );

      if (namesResponse.statusCode == 200 && phoneResponse.statusCode == 200) {
        final names = json.decode(namesResponse.body) as Map<String, dynamic>;
        final phones = json.decode(phoneResponse.body) as Map<String, dynamic>;

        final combinedList = names.keys.map((key) {
          return {
            'name': names[key],
            'code': phones[key],
            'flag': key.toLowerCase(),
          };
        }).toList();

        setState(() {
          countryList = combinedList;
          filteredList = combinedList;
          isLoading = false;
        });
      } else {
        print('Failed to load country data');
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching country data: $e');
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  void filterCountries(String query) {
    final filtered = countryList.where((country) {
      final name = country['name'].toLowerCase();
      final input = query.toLowerCase();

      return name.contains(input);
    }).toList();

    setState(() {
      filteredList = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
              ? Center(child: Text('Failed to load countries'))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.white),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              onChanged: (value) {
                                filterCountries(value);
                              },
                              decoration: InputDecoration(
                                hintText: 'Search',
                                hintStyle: TextStyle(color: Colors.white),
                                border: UnderlineInputBorder(),
                                fillColor: Colors.transparent,
                                filled: true,
                              ),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final country = filteredList[index];
                          print('Displaying country: ${country['name']}');
                          return ListTile(
                            leading: SvgPicture.network(
                              'https://cdn.jsdelivr.net/gh/lipis/flag-icons/flags/4x3/${country['flag']}.svg',
                              width: 32,
                              placeholderBuilder: (BuildContext context) => CircularProgressIndicator(),
                            ),
                            title: Text('${country['code']} ${country['name']}', style: TextStyle(color: Colors.white)),
                            onTap: () {
                              Navigator.pop(context, {'code': country['code'], 'flag': country['flag']});
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}

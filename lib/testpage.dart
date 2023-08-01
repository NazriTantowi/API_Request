import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final String apiKey = 'ae683532de614552a4713159232907';
  final String baseUrl = 'https://api.weatherapi.com/v1/current.json';
  String city = 'london';
  Map<String, dynamic>? weatherData;

  Future<void> fetchWeatherData() async {
    try {
      var response = await http.get(Uri.parse('$baseUrl?key=$apiKey&q=$city'));
      if (response.statusCode == 200) {
        setState(() {
          weatherData = json.decode(response.body);
        });
      } else {
        print('Failed to load weather data.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  String getWeatherIconUrl(String iconCode) {
    return 'https:$iconCode';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: weatherData != null
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Local time: ${weatherData!['location']['localtime']}",
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Location: ${weatherData!['location']['name']}",
                      style: const TextStyle(fontSize: 24),
                    ),
                    Image.network(
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      getWeatherIconUrl(
                        weatherData!['current']['condition']['icon'],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Temperature: ${weatherData!['current']['temp_c']} °C",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Feels like: ${weatherData!['current']['feelslike_c']} °C",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Condition: ${weatherData!['current']['condition']['text']}",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Humidity: ${weatherData!['current']['humidity']}",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "UV Index: ${weatherData!['current']['uv']}",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Wind: ${weatherData!['current']['wind_mph']} mph ",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ],
                ))
            : const CircularProgressIndicator(),
      ),
    );
  }
}

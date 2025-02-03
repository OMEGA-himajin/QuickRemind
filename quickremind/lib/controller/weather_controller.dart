import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherController extends ChangeNotifier {
  String _icon = '';
  String get icon => _icon;

  Future<void> fetchWeather(String city) async {
    // Replace with your actual weather API call
    final response =
        await http.get(Uri.parse('https://api.example.com/weather?city=$city'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _icon = data['weather'][0]['icon'];
      notifyListeners();
    }
  }
}

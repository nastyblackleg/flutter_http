import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

Future<Planet> fetchPlanet(endpoint) async {
  final response = await http.get(Uri.parse(endpoint));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Planet.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Planet {
  final String name;
  final String diameter;
  final String climate;
  final String gravity;
  final String terrain;
  final String population;

  Planet(
      {required this.name,
      required this.diameter,
      required this.climate,
      required this.gravity,
      required this.terrain,
      required this.population});

  factory Planet.fromJson(Map<String, dynamic> json) {
    return Planet(
      name: json['name'],
      diameter: json['diameter'],
      climate: json['climate'],
      gravity: json['gravity'],
      terrain: json['terrain'],
      population: json['population'],
    );
  }
}

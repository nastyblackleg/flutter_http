import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

Future<People> fetchPeople() async {
  final response = await http.get(Uri.parse('https://swapi.dev/api/people/'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return People.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class People {
  final int count;
  final String? next;
  final String? previous;
  final List<Results> results;

  People(
      {required this.count,
      required this.next,
      required this.previous,
      required this.results});

  factory People.fromJson(Map<String, dynamic> json) {
    final results = <Results>[];
    json['results'].forEach((v) {
      results.add(new Results.fromJson(v));
    });
    return People(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: results,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  final String name;
  final String height;
  final String mass;
  final String hairColor;
  final String skinColor;
  final String eyeColor;
  final String birthYear;
  final String gender;
  final String homeworld;
  final String created;
  final String edited;
  final String url;

  Results(
      {required this.name,
      required this.height,
      required this.mass,
      required this.hairColor,
      required this.skinColor,
      required this.eyeColor,
      required this.birthYear,
      required this.gender,
      required this.homeworld,
      required this.created,
      required this.edited,
      required this.url});

  factory Results.fromJson(Map<String, dynamic> json) {
    return Results(
        name: json['name'],
        height: json['height'],
        mass: json['mass'],
        hairColor: json['hair_color'],
        skinColor: json['skin_color'],
        eyeColor: json['eye_color'],
        birthYear: json['birth_year'],
        gender: json['gender'],
        homeworld: json['homeworld'],
        created: json['created'],
        edited: json['edited'],
        url: json['url']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['height'] = this.height;
    data['mass'] = this.mass;
    data['hair_color'] = this.hairColor;
    data['skin_color'] = this.skinColor;
    data['eye_color'] = this.eyeColor;
    data['birth_year'] = this.birthYear;
    data['gender'] = this.gender;
    data['homeworld'] = this.homeworld;
    data['created'] = this.created;
    data['edited'] = this.edited;
    data['url'] = this.url;
    return data;
  }
}

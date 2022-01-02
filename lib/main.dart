import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rest/api/people.dart';
import 'package:flutter_rest/api/planet.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<People> futurePeople;
  late Future<Planet> futurePlanet;
  bool showPlanet = false;

  @override
  void initState() {
    super.initState();
    futurePeople = fetchPeople();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: !showPlanet
            ? Center(
                child: FutureBuilder<People>(
                future: futurePeople,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    People data = snapshot.data;
                    return ListView.builder(
                        itemCount: data.results.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                              onTap: () {
                                futurePlanet =
                                    fetchPlanet(data.results[index].homeworld)
                                        .whenComplete(() => {
                                              setState(() {
                                                showPlanet = true;
                                              })
                                            });
                              },
                              title: Text(data.results[index].name),
                              subtitle: Text(data.results[index].homeworld));
                        });
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              ))
            : FutureBuilder<Planet>(
                future: futurePlanet,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    Planet planet = snapshot.data;
                    return ListView(
                      padding: const EdgeInsets.all(8),
                      children: <Widget>[
                        Container(
                          height: 50,
                          color: Colors.amber[600],
                          child: Center(child: Text("name: " + planet.name)),
                        ),
                        Container(
                          height: 50,
                          color: Colors.amber[500],
                          child: Center(
                              child: Text("diameter: " + planet.diameter)),
                        ),
                        Container(
                          height: 50,
                          color: Colors.amber[400],
                          child:
                              Center(child: Text("climate: " + planet.climate)),
                        ),
                        Container(
                          height: 50,
                          color: Colors.amber[300],
                          child:
                              Center(child: Text("gravity: " + planet.gravity)),
                        ),
                        Container(
                          height: 50,
                          color: Colors.amber[200],
                          child:
                              Center(child: Text("terrain: " + planet.terrain)),
                        ),
                        Container(
                          height: 50,
                          color: Colors.amber[100],
                          child: Center(
                              child: Text("population: " + planet.population)),
                        ),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                showPlanet = false;
                              });
                            },
                            child: const Text("Go back"))
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              ));
  }
}

import 'dart:async';

import 'package:armap/components/arcore.dart';
import 'package:armap/components/map.dart';
import 'package:armap/components/views.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'AR MAP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool showMap = true;
  List<double>? _gyroscopeValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(
      gyroscopeEvents.listen(
        (GyroscopeEvent event) {
          // '${_gyroscopeValues?[0]} - ${_gyroscopeValues?[1]} - ${_gyroscopeValues?[2]}'
          // print('${_gyroscopeValues?[0]} - ${_gyroscopeValues?[1]} - ${_gyroscopeValues?[2]}');
          setState(() {
            _gyroscopeValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gyroscope =
      _gyroscopeValues?.map((double v) => v.toStringAsFixed(1)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Center(
              child: (showMap)? Map(true) : Views(false),
          ),
          Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: (){
                  print("Tapped");
                  setState(() {
                    showMap = !showMap;
                  });
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: const BoxDecoration(
                      // color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 50,
                          blurRadius: 7,
                          offset: Offset(5, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    height: 150,
                    width: 100,
                    child: Stack(
                      children: [
                        (showMap)? Views(true) : Map(false),
                        Positioned(
                          top: 55,
                          right: 28,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5)
                              ),
                              color: Color.fromRGBO(0, 0, 0, 0.6)
                            ),
                            child: IconButton(
                              onPressed: (){
                                setState(() {
                                  showMap = !showMap;
                                });
                              },
                              icon: Icon(
                                Icons.flip_camera_android,
                                color: Colors.white,
                                size: 16,
                              ),
                        ),
                          ))
                      ],
                    )
                  ),
                ),
              )
          ),
        ]
      ),
    );
  }
}

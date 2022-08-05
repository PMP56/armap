import 'package:armap/components/localAndWebObjectsView.dart';
import 'package:flutter/material.dart';

class Views extends StatelessWidget {
  final String title;

  const Views({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LocalAndWebObjectsView()));
              },
              child: const Text("Local / Web Objects")),
        ));
  }
}
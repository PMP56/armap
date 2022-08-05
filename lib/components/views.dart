import 'package:armap/components/localAndWebObjectsView.dart';
import 'package:flutter/material.dart';

class Views extends StatelessWidget {
    final bool large;
    const Views(this.large, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
          child: LocalAndWebObjectsView(this.large)

    );
  }
}
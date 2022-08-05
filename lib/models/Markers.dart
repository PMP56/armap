import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomMarker{
  String name;
  int? block;
  double latitude;
  double longitude;
  Icon icon;

  CustomMarker(
    this.name,
    this.block,
    this.latitude,
    this.longitude,
    this.icon
  );
}
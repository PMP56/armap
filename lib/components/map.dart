import 'dart:math';

import 'package:armap/components/directionData.dart';
import 'package:armap/models/Markers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:location/location.dart';


// import 'directionData.dart';

class Map extends StatefulWidget {
  final bool large;
  const Map(this.large, {Key? key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  double? latitude_data;
  double? longitude_data;

  late final MapController mapController;
  final Location _locationService = Location();

  void initSettings (){
    _locationService.changeSettings(
      accuracy: LocationAccuracy.balanced,
      interval: 1000,
    );
  }

  LocationData? _currentLocation;
  bool _liveUpdate = false;
  bool _permission = false;

  String? _serviceError = '';
  int interActiveFlags = InteractiveFlag.all;

  void initLocationService() async {
    // await _locationService.changeSettings(
    //   accuracy: LocationAccuracy.balanced,
    //   interval: 1000,
    // );

    LocationData? location;
    bool serviceEnabled;
    bool serviceRequestResult;

    try {
      serviceEnabled = await _locationService.serviceEnabled();

      if (serviceEnabled) {
        final permission = await _locationService.requestPermission();
        _permission = permission == PermissionStatus.granted;

        if (_permission) {
          location = await _locationService.getLocation();
          _currentLocation = location;
          _locationService.onLocationChanged
              .listen((LocationData result) async {
            if (mounted) {
              setState(() {
                _currentLocation = result;

                // If Live Update is enabled, move map center
                // if (_liveUpdate) {
                //   mapController.move(
                //       latLng.LatLng(_currentLocation!.latitude!,
                //           _currentLocation!.longitude!),
                //       mapController.zoom);
                // }
              });
            }
          });
        }
      } else {
        serviceRequestResult = await _locationService.requestService();
        if (serviceRequestResult) {
          initLocationService();
          return;
        }
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      if (e.code == 'PERMISSION_DENIED') {
        _serviceError = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        _serviceError = e.message;
      }
      location = null;
    }
  }

  @override
  void initState() {
    super.initState();
    // _currentLocation();
    mapController = MapController();
    // initSettings();
    initLocationService();
  }

  double deg2rad(deg){
    return deg * (pi / 180);
  }

  List posList = <latLng.LatLng>[];
  List peltonToJunctionData = peltonToJunction;
  List<dynamic> ringRoadData = ringRoadAnti;
  List<dynamic> ringRoadDataClockwise = ringRoadClockWise;

  // double calculateDistance(latLng.LatLng p1, latLng.LatLng p2){
  //   int R = 6371;
  //   double dLat = deg2rad(p2.latitude - p1.latitude);
  //   double dLon = deg2rad(p2.longitude - p1.longitude);
  //
  //   double a = sin(dLat / 2) * sin(dLat / 2) +
  //       cos(deg2rad(p1.latitude)) * cos(deg2rad(p2.latitude)) *
  //       sin(dLon / 2) * sin(dLon / 2);
  //
  //   double c = 2 * atan2(sqrt(a), sqrt(1-a));
  //   double d = R * c;
  //   return d;
  // }

  void getLocation(block){
    latLng.LatLng p1 = latLng.LatLng(27.62023, 85.53815);
    latLng.LatLng p2 = breakPoints[block]?[0]?? latLng.LatLng(27.61968, 85.53833); //destination

    int p2Index = (breakPoints[block]?[1])? ringRoadDataClockwise.indexOf(p2) : ringRoadData.indexOf(p2);
    List<dynamic> tempPoints = (breakPoints[block]?[1])? ringRoadDataClockwise.sublist(0, p2Index) : ringRoadData.sublist(0, p2Index);
    posList = [...peltonToJunctionData, ...tempPoints];
  }

  @override
  Widget build(BuildContext context) {
    latLng.LatLng currentLatLng;

    if (_currentLocation != null) {
      currentLatLng =
          latLng.LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);
    } else {
      currentLatLng = latLng.LatLng(0, 0);
    }

    final Positions = <CustomMarker>[
      CustomMarker("Department of Computer Science and Engineering", 9, 27.6199416, 85.5390304, Icon(Icons.house, color: Colors.lightBlue,)),
      CustomMarker("Department of Biotechnology", 7, 27.61937, 85.539454, Icon(Icons.house, color: Colors.lightBlue,)),
      CustomMarker("Department of Mechanical Engineering", 8, 27.619674, 85.539358, Icon(Icons.house, color: Colors.lightBlue,)),
      CustomMarker("Department of Civil and Geomatics Engineering", 11, 27.619306, 85.538025, Icon(Icons.house, color: Colors.lightBlue,)),
      CustomMarker("Department of Pharmacy", 12, 27.618904, 85.538054, Icon(Icons.house, color: Colors.lightBlue,)),
      CustomMarker("School of Science", 6, 27.618909, 85.539352, Icon(Icons.house, color: Colors.lightBlue,)),
      CustomMarker("AEC / Gol Ghar", 34, 27.618443, 85.539669, Icon(Icons.house, color: Colors.lightBlue,)),
      CustomMarker("Boys Hostel", 18, 27.617711, 85.53674, Icon(Icons.home_filled, color: Colors.greenAccent,)),
      CustomMarker("Girls Hostel", 16, 27.618039, 85.539304, Icon(Icons.home_filled, color: Colors.greenAccent,)),
      CustomMarker("Staff Quarter", 15, 27.617635, 85.539315, Icon(Icons.home_filled, color: Colors.greenAccent,)),
      CustomMarker("KU Ground", 22, 27.618605, 85.536987, Icon(Icons.sports_baseball, color: Colors.redAccent,)),
      CustomMarker("Canteen (Mesh)", 13, 27.617987, 85.53784, Icon(Icons.fastfood, color: Colors.yellow,)),
      CustomMarker("Library", 3, 27.618909, 85.538633, Icon(Icons.menu_book, color: Colors.blueGrey,)),
      CustomMarker("Administration Building", 2, 27.619684, 85.538633, Icon(Icons.admin_panel_settings, color: Colors.blue,)),
      CustomMarker("CV Raman Auditorium", 4, 27.61944, 85.53895, Icon(Icons.house, color: Colors.lightBlue,)),
    ];


    final markers = <Marker>[
      Marker(
        width: 80,
        height: 80,
        point: currentLatLng,
        builder: (ctx) => const Icon(
            Icons.location_pin,
          color: Colors.red,
          size: 32,
        )
      ),
      ...Positions.map((pos) => Marker(
          width: 80,
          height: 80,
          point: latLng.LatLng(pos.latitude, pos.longitude),
          builder: (ctx) => GestureDetector(
            onDoubleTap: () => getLocation(pos.block),
            child: Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              // height: 200,
              message: "${pos.name}",
              verticalOffset: -50,
              child: Icon(
                Icons.location_pin,
                color: Colors.red,
                size: (widget.large)? 28 : 18,
              ),
            ),
          )
      ))
    ];

    return Scaffold(
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: latLng.LatLng(27.6195, 85.5386),
          zoom: 18,
          maxZoom: (widget.large)?18 : 15,
          interactiveFlags: interActiveFlags
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'com.example.app',
          ),
          PolylineLayerOptions(
            polylineCulling: false,
            polylines: [
              Polyline(
                points: [...posList],//[...peltonToJunctionData,...ringRoadData],
                strokeWidth: 3,
                color: Colors.blue,
                isDotted: true,

              ),
            ],
          ),
          MarkerLayerOptions(
              markers: markers
          ),
        ],
        nonRotatedChildren: [
          AttributionWidget.defaultWidget(
            source: 'OpenStreetMap contributors',
            onSourceTapped: null,
          ),
        ],
      ),
      floatingActionButton: (widget.large)? FloatingActionButton(
        child: Icon(Icons.my_location),
        onPressed: (){
            mapController.move(
              latLng.LatLng(_currentLocation!.latitude!,
                  _currentLocation!.longitude!),
            mapController.zoom);
            setState(() {
            _liveUpdate = !_liveUpdate;

            if (_liveUpdate) {
              interActiveFlags = InteractiveFlag.all;

              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                  'In live update mode only zoom and rotation are enable'),
              ));
            } else {
              interActiveFlags = InteractiveFlag.all;
            }
          });
        },
      ) : null,
    );
  }
}

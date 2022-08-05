import 'package:armap/models/Markers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:location/location.dart';

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
      CustomMarker("AEC / Gol Ghar", 6, 27.618443, 85.539669, Icon(Icons.house, color: Colors.lightBlue,)),
      CustomMarker("Boys Hostel", null, 27.617711, 85.53674, Icon(Icons.home_filled, color: Colors.greenAccent,)),
      CustomMarker("Girls Hostel", null, 27.618039, 85.539304, Icon(Icons.home_filled, color: Colors.greenAccent,)),
      CustomMarker("Staff Quarter", null, 27.617635, 85.539315, Icon(Icons.home_filled, color: Colors.greenAccent,)),
      CustomMarker("KU Ground", null, 27.618605, 85.536987, Icon(Icons.sports_baseball, color: Colors.redAccent,)),
      CustomMarker("Canteen (Mesh)", null, 27.617987, 85.53784, Icon(Icons.fastfood, color: Colors.yellow,)),
      CustomMarker("Library", null, 27.618909, 85.538633, Icon(Icons.menu_book, color: Colors.blueGrey,)),
      CustomMarker("Admin Building", 2, 27.619684, 85.538633, Icon(Icons.admin_panel_settings, color: Colors.blue,)),
      CustomMarker("CV Raman Auditorium", null, 27.61944, 85.53895, Icon(Icons.house, color: Colors.lightBlue,)),
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
          builder: (ctx) => const Icon(
            Icons.location_pin,
            color: Colors.red,
            size: 28,
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
          MarkerLayerOptions(
            markers: markers
          ),
          // PolylineLayerOptions(
          //   polylineCulling: false,
          //   polylines: [
          //     Polyline(
          //       points: [latLng.LatLng(27.61970, 85.53833), latLng.LatLng(27.61871, 85.53827)],
          //       strokeWidth: 3,
          //       color: Colors.blue,
          //       isDotted: true,
          //
          //     ),
          //   ],
          // ),
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

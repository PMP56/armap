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

  // Future<List?> _currentLocation() async {
  //   await _locationService.changeSettings(
  //     accuracy: LocationAccuracy.high,
  //     interval: 1000,
  //   );
  //
  //   bool serviceEnabled;
  //   PermissionStatus permissionGranted;
  //
  //   Location location = new Location();
  //
  //   serviceEnabled = await location.serviceEnabled();
  //   if (!serviceEnabled) {
  //     serviceEnabled = await location.requestService();
  //     if (!serviceEnabled) {
  //       return null;
  //     }
  //   }
  //
  //   permissionGranted = await location.hasPermission();
  //   if (permissionGranted == PermissionStatus.denied) {
  //     permissionGranted = await location.requestPermission();
  //     if (permissionGranted != PermissionStatus.granted) {
  //       return null;
  //     }
  //   }
  //   LocationData _currentPosition = await location.getLocation();
  //   setState(() {
  //     latitude_data = _currentPosition.latitude;
  //     longitude_data = _currentPosition.longitude;
  //   });
  //   print(_currentPosition.latitude);
  // }

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
    // TODO: implement initState
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

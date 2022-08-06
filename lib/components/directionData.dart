import 'package:latlong2/latlong.dart' as latLng;

List peltonToJunction = <dynamic>[
  latLng.LatLng(27.62023, 85.53815),
  latLng.LatLng(27.62015, 85.53819),
  latLng.LatLng(27.62007, 85.53824),
  latLng.LatLng(27.61997, 85.53829),
  latLng.LatLng(27.6199, 85.53832),
  latLng.LatLng(27.61983, 85.53832),
  latLng.LatLng(27.61968, 85.53833),
];

List ringRoadAnti = <dynamic>[
  latLng.LatLng(27.61968, 85.53833),
  latLng.LatLng(27.61963, 85.53832),
  latLng.LatLng(27.61948, 85.53831),
  latLng.LatLng(27.61931, 85.53830),
  latLng.LatLng(27.6191, 85.53830),
  latLng.LatLng(27.6189, 85.53828), //IP3
  latLng.LatLng(27.61869, 85.53828),
  latLng.LatLng(27.61865, 85.53830),
  latLng.LatLng(27.61863, 85.53831),
  latLng.LatLng(27.61860, 85.53832),
  latLng.LatLng(27.61858, 85.53833), //Point 11
  latLng.LatLng(27.61854, 85.53837),
  latLng.LatLng(27.61850, 85.53844),
  latLng.LatLng(27.61847, 85.53855),
  latLng.LatLng(27.61847, 85.53864),
  latLng.LatLng(27.61848, 85.53870),
  latLng.LatLng(27.61855, 85.53878), //Point 17
  latLng.LatLng(27.61865, 85.53884),
  latLng.LatLng(27.61877, 85.53890),
  latLng.LatLng(27.61891, 85.53898),
  latLng.LatLng(27.61905, 85.53904),
  latLng.LatLng(27.61918, 85.53909),
  latLng.LatLng(27.61932, 85.53914), //Point 23
  latLng.LatLng(27.61947, 85.53912),
  latLng.LatLng(27.6196, 85.53904),
  latLng.LatLng(27.61966, 85.53898),
  latLng.LatLng(27.61974, 85.53884),
  latLng.LatLng(27.61979, 85.53872),
  latLng.LatLng(27.6198, 85.5386),
  latLng.LatLng(27.6198, 85.53849),
  latLng.LatLng(27.61973, 85.53837),
  latLng.LatLng(27.61968, 85.53833),
];

List ringRoadClockWise = ringRoadAnti.reversed.toList();

Map<int, List> breakPoints = {
  2: [latLng.LatLng(27.61979, 85.53872), true],
  3: [latLng.LatLng(27.61877, 85.53890), true],
  4: [latLng.LatLng(27.61932, 85.53914), true],
  7: [latLng.LatLng(27.61918, 85.53909), true],
  9: [latLng.LatLng(27.61966, 85.53898), true],
  6: [latLng.LatLng(27.61891, 85.53898), true],
  8: [latLng.LatLng(27.61966, 85.53898), true],
  11: [latLng.LatLng(27.61948, 85.53831), false],
  12: [latLng.LatLng(27.6189, 85.53828), false],
};

// latLng.LatLng startPos = latLng.LatLng(27.62023, 85.53815);
// latLng.LatLng biotech = latLng.LatLng(27.61918, 85.53909);
// latLng.LatLng sos = latLng.LatLng(27.61918, 85.53909);
// latLng.LatLng DOCSE = latLng.LatLng(27.61966, 85.53898);

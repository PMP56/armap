import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class LocalAndWebObjectsView extends StatefulWidget {
  final bool large;
  const LocalAndWebObjectsView(this.large, {Key? key}) : super(key: key);

  @override
  State<LocalAndWebObjectsView> createState() => _LocalAndWebObjectsViewState();
}

class _LocalAndWebObjectsViewState extends State<LocalAndWebObjectsView> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;

  //String localObjectReference;
  ARNode? localObjectNode;

  //String webObjectReference;
  ARNode? webObjectNode;

  @override
  void dispose() {
    arSessionManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        // height: MediaQuery.of(context).size.height * .8,
        child: ARView(
          onARViewCreated: onARViewCreated,
        ),
      ),
      floatingActionButton: (!widget.large)? FloatingActionButton(
        child: Icon(Icons.widgets_outlined),
        onPressed: onWebObjectAtButtonPressed,
      ) : null,
    );
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    //
    this.arSessionManager.onInitialize(
      showAnimatedGuide: false,
      showFeaturePoints: false,
      showPlanes: true,
      // customPlaneTexturePath: "assets/triangle.png",
      showWorldOrigin: false,
      handleTaps: true,
    );
    this.arObjectManager.onInitialize();
  }

  Future<void> onLocalObjectButtonPressed() async {
    if (localObjectNode != null) {
      arObjectManager.removeNode(localObjectNode!);
      localObjectNode = null;
    } else {
      var newNode = ARNode(
          type: NodeType.localGLTF2,
          uri: "assets/sphere.obj",
          scale: Vector3(0.2, 0.2, 0.2),
          position: Vector3(0.0, 0.0, 0.0),
          rotation: Vector4(1.0, 0.0, 0.0, 0.0));

      var newNode2 = ARNode(
          type: NodeType.localGLTF2,
          uri: "assets/sphere.obj",
          scale: Vector3(0.2, 0.2, 0.2),
          position: Vector3(0.1, 0.1, 0.0),
          rotation: Vector4(1.0, 0.0, 0.0, 0.0));

      bool? didAddLocalNode = await arObjectManager.addNode(newNode);
      bool? didAddLocalNode2 = await arObjectManager.addNode(newNode2);
      localObjectNode = (didAddLocalNode!) ? newNode : null;
      localObjectNode = (didAddLocalNode2!) ? newNode : null;
    }
  }

  Future<void> onWebObjectAtButtonPressed() async {
    if (webObjectNode != null) {
      arObjectManager.removeNode(webObjectNode!);
      webObjectNode = null;
    } else {
      var newNode = ARNode(
          type: NodeType.webGLB,
          uri:
          "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Box/glTF-Binary/Box.glb",
          scale: Vector3(0.0, 0.1, 0.1));
      var newNode2 = ARNode(
          type: NodeType.webGLB,
          uri:
          "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Box/glTF-Binary/Box.glb",
          scale: Vector3(0.1, 0.1, 5));
      var newNode3 = ARNode(
          type: NodeType.webGLB,
          uri:
          "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Box/glTF-Binary/Box.glb",
          scale: Vector3(0.2, 0.1, 10));
      bool? didAddWebNode = await arObjectManager.addNode(newNode);
      bool? didAddWebNode2 = await arObjectManager.addNode(newNode2);
      bool? didAddWebNode3 = await arObjectManager.addNode(newNode3);
      webObjectNode = (didAddWebNode!) ? newNode : null;
      webObjectNode = (didAddWebNode2!) ? newNode : null;
      webObjectNode = (didAddWebNode3!) ? newNode : null;
    }
  }
}
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>{
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  late GoogleMapController mapController;
  // Define a marker for the user's current location
  late Marker _currentLocationMarker;

  // Other code remains the same

  @override
  void initState() {
    super.initState();
    // Initialize the current location marker with a default position
    _currentLocationMarker = Marker(
      markerId: MarkerId('currentLocation'),
      infoWindow: InfoWindow(title: 'Current Location'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(0, 0), // Default position, will be updated later
    );
  }
  static const CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(37.42796133580664, -122.085749655962),
      zoom: 14.4746,);
  late Position currentPosition;
  getUserCurrentLocation () async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
        forceAndroidLocationManager: true);
    currentPosition = position;
    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =CameraPosition (target: pos, zoom: 16);
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    // Update the marker position with the current location
    setState(() {
      _currentLocationMarker = _currentLocationMarker.copyWith(
        positionParam: pos,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: true,
            padding: EdgeInsets.only(bottom: 200),
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller){
              _controller.complete(controller);
              mapController=controller;
              getUserCurrentLocation();
            },
            // Add the current location marker to the map
            markers: {
              _currentLocationMarker,
            },
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Container(
                      width: MediaQuery.of(context).size.width - 70,
                      child: ElevatedButton.icon(
                        onPressed: (){},
                        icon: Icon(CupertinoIcons.shopping_cart),
                        label: Text("SHOP NOW"),
                      ),
                    )
                  ]
              ),
            ),
          )
        ],
      ),
    );
  }
}

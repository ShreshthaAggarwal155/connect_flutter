import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class UserLocation extends StatelessWidget {
  void getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print(position);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("Get"),
          onPressed: () {
            getLocation();
          },
        ),
      ),
    );
  }
}

class Location {
  double latitude = 0;
  double longitude = 0;

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    latitude = position.latitude;
    longitude = position.longitude;
  }
}

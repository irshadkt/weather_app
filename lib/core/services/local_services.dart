import 'package:geolocator/geolocator.dart';

Future<Position?> getCurrentLocation() async {
  // 1. Check if location services are enabled
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are off — prompt user to enable
    return null;
  }

  // 2. Check/request permission
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // User permanently denied — direct them to app settings
    return null;
  }

  // 3. Get current position
  return await Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
    ),
  );
}
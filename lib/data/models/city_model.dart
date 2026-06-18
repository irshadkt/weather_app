class CityModel {
  final String name;
  final String country;
  final double latitude;
  final double longitude;

  CityModel({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  @override
  String toString() => '$name, $country';
}

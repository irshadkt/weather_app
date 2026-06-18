class WeatherModel {
  final String city;
  final String country;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final String condition;
  final String description;
  final int humidity;
  final double windSpeed;
  final int windDegree;
  final int cloudPercentage;
  final int visibility;

  WeatherModel({
    required this.city,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.condition,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.windDegree,
    required this.cloudPercentage,
    required this.visibility,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['name'] ?? 'Unknown',
      country: json['sys']?['country'] ?? 'Unknown',
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      tempMin: (json['main']['temp_min'] as num).toDouble(),
      tempMax: (json['main']['temp_max'] as num).toDouble(),
      condition: json['weather'][0]['main'] ?? 'Unknown',
      description: json['weather'][0]['description'] ?? 'No description',
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      windDegree: json['wind']['deg'] as int? ?? 0,
      cloudPercentage: json['clouds']['all'] as int? ?? 0,
      visibility: json['visibility'] as int? ?? 10000,
    );
  }
}

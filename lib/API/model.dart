class WeatherData {
  final num? temp;
  final num? pressure;
  final num? humidity;
  final num? clouds;
  final String? cityName;

  WeatherData({
    this.temp,
    this.pressure,
    this.humidity,
    this.clouds,
    this.cityName,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temp: json['main']['temp'] - 273,
      pressure: json['main']['pressure'],
      humidity: json['main']['humidity'],
      clouds: json['clouds']['all'],
      cityName: json['name'],
    );
  }
}

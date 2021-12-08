import 'package:weather/weather.dart';
import 'location.dart';

class WeatherModel {
  late double humidity = 0.0;
  late int temperature = 0;
  late double windSpeed = 0.0;

  late String weatherDescription = '';


  Future<void> getLocationWeather() async {
    WeatherFactory wf = new WeatherFactory("d5bb0f64fb412359ba54b7cc41e9402e");
    Location location = Location();
    await location.getCurrentLocation();

    Weather w = await wf.currentWeatherByLocation(
        location.latitude, location.longitude);
    humidity= w.humidity!;
    windSpeed = w.windSpeed!;
    temperature = w.temperature!.celsius!.toInt();

    weatherDescription = w.weatherDescription!;

  }
}
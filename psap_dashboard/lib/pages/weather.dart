import 'package:weather/weather.dart';


class WeatherModel  {
  late double humidity = 0.0;
  late int temperature = 0;
  late double windSpeed = 0.0;
  late String weatherDescription = '';

  Future<void> getLocationWeather(latitude, longitude) async {
    WeatherFactory wf = WeatherFactory("d5bb0f64fb412359ba54b7cc41e9402e");
    Weather w = await wf.currentWeatherByLocation(latitude, longitude);

    humidity= w.humidity!;
    windSpeed = w.windSpeed!;
    temperature = w.temperature!.celsius!.toInt();
    weatherDescription = w.weatherDescription!;
  }
}
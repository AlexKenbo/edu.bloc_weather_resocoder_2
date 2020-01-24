import 'package:bloc_resocoder_2/model/weather.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WeatherState extends Equatable {
  WeatherState([List props = const <dynamic>[]]) : super(props);
}

class InitialWeatherState extends WeatherState {}

class LoadingWeatherState extends WeatherState {}

// Only the LoadedWeatherState event needs to contain data
class LoadedWeatherState extends WeatherState {
  final Weather weather;

  LoadedWeatherState(this.weather) : super([weather]);
}

import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:bloc_resocoder_2/model/weather.dart';
import './bloc.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  @override
  WeatherState get initialState => InitialWeatherState();

  @override
  Stream<WeatherState> mapEventToState(
    WeatherEvent event,
  ) async* {
    if (event is GetWeather) {
      yield LoadingWeatherState();
      final weather = await _fetchWeatherFromFakeApi(event.cityName);
      yield LoadedWeatherState(weather);
    }
  }

  Future<Weather> _fetchWeatherFromFakeApi(String cityName) {
    return Future.delayed(
      Duration(seconds: 1),
      (){
        return Weather(
          cityName: cityName,
          temperature: 20 + Random().nextInt(15) + Random().nextDouble()
        );
      }
    );
  }
}

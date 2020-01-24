/*
https://www.youtube.com/watch?v=nQMfaQeCL6M&list=PLB6lc7nQ1n4jCBkrirvVGr5b8rC95VAQ5&index=3
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/bloc.dart';
import 'model/weather.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  WeatherPage({Key key}) : super(key: key);

  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherBloc weatherBloc = WeatherBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fake Weather App"),
      ),
      body: BlocProvider(
        builder: (context) => weatherBloc,
        child:
            /*StreamBuilder( // переделал на стандартный! По рекомендации FOX
          stream: weatherBloc.state ,
          //initialData: initialData ,
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if (snapshot.data is InitialWeatherState) {
                print(snapshot.data.runtimeType);
                return buildInitialInput();
              } else if (snapshot.data is LoadingWeatherState) {
                print(snapshot.data.runtimeType);
                return buildLoading();
              } else if (snapshot.data is LoadedWeatherState) {
                print(snapshot.data.hashCode);
                print('Loaded: ${snapshot.data.weather.cityName}');
                return buildColumnWithData(snapshot.data.weather);
              } else { return Container(child: Text('Опять ничирта не вернулось'));}
          },
        ),*/

            Container(
          //
          padding: EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: BlocListener<WeatherBloc, WeatherState>(
              listener: (context, WeatherState state) {
            if (state is LoadedWeatherState) {
              print('State change: ${state.weather.cityName}');
            }
          }, child: BlocBuilder<WeatherBloc, WeatherState>(
            //condition: , проверка стейта
            builder: (context, state) {
              if (state is InitialWeatherState) {
                return buildInitialInput();
              } else if (state is LoadingWeatherState) {
                return buildLoading();
              } else if (state is LoadedWeatherState) {
                print('rebuild');
                return buildColumnWithData(state.weather);
              } else {
                return Container(child: Text('Опять ничирта не вернулось'));
              }
            },
          )),
        ),
      ),
    );
  }

  Widget buildInitialInput() {
    return Center(
      child: CityInputField(),
    );
  }

  Widget buildLoading() {
    return Center(child: CircularProgressIndicator());
  }

  Column buildColumnWithData(Weather weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          weather.cityName,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          '${weather.temperature.toStringAsFixed(1)} ˚C',
          style: TextStyle(fontSize: 80),
        ),
        CityInputField(),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    weatherBloc.dispose();
  }
}

class CityInputField extends StatefulWidget {
  const CityInputField({
    Key key,
  }) : super(key: key);

  @override
  _CityInputFieldState createState() => _CityInputFieldState();
}

class _CityInputFieldState extends State<CityInputField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        onSubmitted: submitCityName,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Enter a city",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  void submitCityName(String cityName) {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    weatherBloc.dispatch(GetWeather(cityName));
  }
}

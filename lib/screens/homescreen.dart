import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../API/api_services.dart';
import '../API/model.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  bool isloaded = false;
  WeatherData? weatherData;
  String? cityname;
  TextEditingController searchcitycontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    presentCityWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text(
          'CLIMA',
          style: TextStyle(
            fontSize: 35,
            letterSpacing: 4,
            color: Color.fromARGB(255, 247, 30, 15),
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Color.fromARGB(255, 100, 33, 29),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Visibility(
          replacement: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 7,
              color: Colors.red,
            ),
          ),
          visible: isloaded,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onFieldSubmitted: (String s) {
                    setState(() {
                      cityname = s;
                      getCityWeather(s);
                      isloaded = false;
                      searchcitycontroller.clear();
                    });
                  },
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  cursorColor: Colors.white,
                  controller: searchcitycontroller,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.red.shade300,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    labelText: 'City',
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                      color: const Color.fromARGB(67, 80, 73, 73),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            cityname ?? 'location not available',
                            style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 25,
                                letterSpacing: 2.5),
                          ),
                        ),
                      )),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      color: const Color.fromARGB(67, 80, 73, 73),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (weatherData != null)
                            Text(
                                'Temperature : ${weatherData!.temp?.toString() ?? '0'} °C'),
                          if (weatherData != null)
                            Text(
                                'Presuure : ${weatherData!.pressure?.toString() ?? '0'} hPa'),
                          if (weatherData != null)
                            Text(
                                'humidity : ${weatherData!.humidity?.toString() ?? '0'} %'),
                          if (weatherData != null)
                            Text(
                                'clouds :  ${weatherData!.clouds?.toString() ?? '0'} %'),
                          if (weatherData == null)
                            const Text('Weather data not found'),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void presentCityWeather() async {
    var p = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      forceAndroidLocationManager: true,
    );

    // ignore: unnecessary_null_comparison
    if (p != null) {
      print('lat=${p.latitude} long: ${p.longitude}');
      getCurrentCityWeather(p);
    } else {
      print('error');
    }
  }

  void getCurrentCityWeather(Position position) async {
    var data = await APIServices.getCurrentCityWeather(position);
    if (data != null) {
      updateUI(data);
      setState(() {
        isloaded = true;
      });
    } else {
      print('API request failed');
      setState(() {
        weatherData = null; // Set weatherData to null on API failure
        isloaded = true;
      });
    }
  }

  void getCityWeather(String cityName) async {
    var data = await APIServices.getCityWeather(cityName);
    if (data != null) {
      updateUI(data);
      setState(() {
        isloaded = true;
      });
    } else {
      print('API request failed');
      setState(() {
        weatherData = null; // Set weatherData to null on API failure
        isloaded = true;
      });
    }
  }

  void updateUI(WeatherData decodedData) {
    setState(() {
      weatherData = decodedData;
      if (decodedData.cityName == null) {
        cityname = 'not available';
      } else {
        cityname = decodedData.cityName;
      }
    });
  }

  @override
  void dispose() {
    searchcitycontroller.dispose();
    super.dispose();
  }
}

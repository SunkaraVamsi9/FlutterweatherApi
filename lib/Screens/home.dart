import 'package:flutter/material.dart';
import 'package:weatherapplication/Controllers/weathercontroller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:weatherapplication/Models/weathermodel.dart';

class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  TextEditingController city = TextEditingController();
  bool showdata = false;
  bool error = false;
  DateTime currentdate = DateTime.now();
  late Box box;
  var data;

  @override
  void initState() {
    super.initState();
    getcity();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: city,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Enter City Name",
                  ),
                  onSubmitted: (val) async {
                    if (val != '') {
                      data = await weathercontroller().getdetails(val);
                      if (data != null) {
                        setState(() {
                          showdata = true;
                          error = false;
                        });
                        var shared_pref = await SharedPreferences.getInstance();
                        await shared_pref.setString('City', val);
                       // print(await shared_pref.getString('City'));
                        //print('----->${await box.get("weather")}');
                      } else {
                        setState(() {
                          error = true;
                          showdata = false;
                        });
                      }
                    } else {
                      setState(() {
                        showdata = false;
                        error = false;
                      });
                    }
                  },
                ),
              ),
              Divider()
            ],
          ),
        ),
      ),
      body: showdata
          ? SingleChildScrollView(
              child: Column(
                children: [
                  for (int index = 0; index < 5; index++)
                    cardwidget(data[index], currentdate.add(Duration(days: index)))
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                error
                    ? Center(
                        child: Text(
                          "Invalid city Name",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: const Color.fromARGB(255, 245, 22, 6),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    : Text(''),
              ]),
            ),
    );
  }

  Widget cardwidget(var dt, var date) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              "Date : ${date.toString().split(" ")[0]}",
              style: TextStyle(fontSize: 18, color: Colors.blue),
            ),
          ),
          Card(
            //color:Colors.green,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('Min_temp'),
                    Text('Max_temp'),
                    Text('Pressure '),
                    Text('Humidity'),
                    Text('Weather_desc')
                  ],
                ),
                Column(
                  children: [
                    Text(':'),
                    Text(':'),
                    Text(':'),
                    Text(':'),
                    Text(':')
                  ],
                ),
                Column(
                  children: [
                    Text(dt.temp.min.toString()),
                    Text(dt.temp.max.toString()),
                    Text(dt.pressure.toString()),
                    Text(dt.humidity.toString()),
                    Text(dt.weather[0].description)
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getcity() async {
    var sh = await SharedPreferences.getInstance();
    if (sh.containsKey("City")) {
      var cityName = sh.getString("City");
      setState(() {
        city.text = cityName.toString();
      });
      box = await Hive.openBox('myBox');
      var weatherData = box.get("weather");
      setState((){
        data =weatherData.map((e)=>weathermodel.fromJson(e)).toList();
        if (data != null) {
          showdata = true;
        }
      });
    }
  }
}

import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapplication/Models/weathermodel.dart';
class weathercontroller{
getdetails(String city) async {
Box box=await Hive.openBox("myBox");
var url='https://api.openweathermap.org/data/2.5/forecast/daily?q=$city,india&cnt=5&appid=271d1234d3f497eed5b1d80a07b3fcd1';
final uri=Uri.parse(url);
final result=await http.post(uri);
if(result.statusCode==200){
var body=json.decode(result.body);
await box.put("weather", body['list']);
print(body['list'][0]);
return body["list"].map((e)=>weathermodel.fromJson(e)).toList();
  }
else{
print(result.body);
}}
}
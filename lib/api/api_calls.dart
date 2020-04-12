import 'dart:convert' as convert;
import 'package:covidtracker/model/stats.dart';
import 'package:http/http.dart' as http;

class ApiCalls {

  Future<Stats> fetchDetails() async{

    Map<String, String> headers = {
      "Content-type": "application/json",
      "x-rapidapi-host": "covid-193.p.rapidapi.com",
      "x-rapidapi-key": "2b1debd4c9msh7a88a499ff675a0p15ba35jsn96ae1eeeeaf3",
    };

    final response = await http.get(
      'https://covid-193.p.rapidapi.com/statistics',
      headers: headers,
    );

    return Stats.fromJson(convert.jsonDecode(response.body));

  }

}


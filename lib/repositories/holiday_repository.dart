import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/holiday.dart';

class HolidayRepository {
  Future<List<Holiday>> fetchHolidays() async {
    final response = await http
        .get(Uri.parse('https://brasilapi.com.br/api/feriados/v1/2024'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((holiday) => Holiday.fromJson(holiday)).toList();
    } else {
      throw Exception('Failed to load holidays');
    }
  }
}

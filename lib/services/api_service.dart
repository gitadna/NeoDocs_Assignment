import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/range_model.dart';

class ApiService {
  static const String url =
      'https://nd-assignment.azurewebsites.net/api/get-ranges';

  static const String token =
      'eb3dae0a10614a7e719277e07e268b12aeb3af6d7a4655472608451b321f5a95';

  Future<List<RangeModel>> fetchRanges() async {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      print("Data : ${data}");
      return data.map((e) => RangeModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load ranges');
    }
  }
}

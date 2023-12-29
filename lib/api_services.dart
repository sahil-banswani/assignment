import 'dart:convert';

import 'package:sample_project/model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<User>> fetchData() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    if (response.statusCode == 200) {
      final jsonresponce = json.decode(response.body) as List;
      return jsonresponce.map((userJson) => User.fromJson(userJson)).toList();
    } else {
      throw Exception('Failed to load album');
    }
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static Future<bool> deleteById(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    return response.statusCode == 200;
  }

  static Future<List?> getToDo() async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=111111111';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if(response.statusCode==200){
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      return result;
    }else{
      return null;
    }
  }
}

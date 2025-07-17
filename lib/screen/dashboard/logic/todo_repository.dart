import 'dart:convert';

import "package:http/http.dart" as http;
import 'package:hwpldemo/screen/dashboard/model/todo_entity.dart';

// Repository to fetch todos from the remote API
class TodoRepository {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com/todos';

  Future<List<TodoEntity>> fetchTodos(int page, int limit) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?_page=$page&_limit=$limit'),
      headers: {"Accept": "application/json", "User-Agent": "Mozilla/5.0"},
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => TodoEntity.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}

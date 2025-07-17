import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hwpldemo/screen/dashboard/model/todo_entity.dart';

import 'todo_repository.dart';

class TodoProvider with ChangeNotifier {
  final _postService = TodoRepository();
  final _todoBox = Hive.box<TodoEntity>('local_todos');
  final _deletedIdsBox = Hive.box<int>('deleted_ids');
  final _statusOverridesBox = Hive.box<bool>('completed_status_overrides');

  List<TodoEntity> _posts = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;
  final int _limit = 20;
  bool _localTodosAdded = false;

  String? _errorMessage;

  List<TodoEntity> get posts => _posts;

  bool get isLoading => _isLoading;

  bool get hasMore => _hasMore;

  String? get errorMessage => _errorMessage;

  Future<void> fetchPosts() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // ✅ Check Internet Connection
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      _errorMessage = 'No internet connection';
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final newPosts = await _postService.fetchTodos(_page, _limit);

      final filtered = newPosts
          .where((todo) => !_deletedIdsBox.containsKey(todo.id))
          .map((todo) {
            final overridden = _statusOverridesBox.get(todo.id);
            return TodoEntity(
              id: todo.id,
              title: todo.title,
              completed: overridden ?? todo.completed,
              isLocal: false,
              userId: 0,
            );
          })
          .toList();

      _posts.addAll(filtered);
      _page++;

      if (!_localTodosAdded) {
        final localTodos = _todoBox.values.toList();
        _posts.insertAll(0, localTodos);
        _localTodosAdded = true;
      }

      if (newPosts.length < _limit) {
        _hasMore = false;
      }
    } catch (e) {
      _errorMessage = "Failed to fetch todos. Please try again $e.";
      print("Error fetching posts: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addTodo(TodoEntity todo) {
    _todoBox.put(todo.id.toString(), todo);
    _posts.insert(0, todo);
    notifyListeners();
  }

  void deleteTodo(TodoEntity todo) {
    if (todo.isLocal) {
      _todoBox.delete(todo.id.toString());
    } else {
      _deletedIdsBox.put(todo.id, todo.id);
    }
    _posts.removeWhere((t) => t.id == todo.id);
    notifyListeners();
  }

  void toggleCompleted(TodoEntity todo) {
    final index = _posts.indexWhere((t) => t.id == todo.id);
    if (index == -1) return;

    final updated = TodoEntity(
      id: todo.id,
      title: todo.title,
      completed: !todo.completed,
      isLocal: todo.isLocal,
      userId: 0,
    );

    _posts[index] = updated;

    if (todo.isLocal) {
      _todoBox.put(todo.id.toString(), updated);
    } else {
      _statusOverridesBox.put(todo.id, updated.completed);
    }

    notifyListeners();
  }
}

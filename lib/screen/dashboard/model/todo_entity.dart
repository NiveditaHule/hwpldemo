import 'dart:convert';
import 'package:hive/hive.dart';

part 'todo_entity.g.dart';

@HiveType(typeId: 0)
class TodoEntity extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  int userId;

  @HiveField(2)
  String title;

  @HiveField(3)
  bool completed;

  @HiveField(4)
  bool isLocal; // To track if added locally

  TodoEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.completed,
    this.isLocal = false,
  });

  factory TodoEntity.fromJson(Map<String, dynamic> json) => TodoEntity(
    id: json['id'] is int ? json['id'] : (json['id'] as num).toInt(),
    userId: json['userId'] is int ? json['userId'] : (json['userId'] as num).toInt(),
    title: json['title'] ?? '',
    completed: json['completed'] ?? false,
    isLocal: false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'title': title,
    'completed': completed,
    'isLocal': isLocal,
  };

  @override
  String toString() => jsonEncode(toJson());
}

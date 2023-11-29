import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
part 'task.g.dart';

@JsonSerializable()
class Task {
  final int id;
  final String name;
  final String country;
  final String status;
  bool isComplete;

  Task({
    required this.id,
    required this.name,
    required this.country,
    required this.status,
    this.isComplete = false,
  });

  copyWith({int? id, String? name, String? country,String? status, bool? isComplete}) {
    return Task(
        id: id ?? this.id,
        name: name ?? this.name,
        country: country ?? this.country,
        status: status ?? this.status,
        isComplete: isComplete ?? this.isComplete);
  }

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}

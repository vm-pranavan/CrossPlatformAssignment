import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class TaskModel extends ParseObject implements ParseCloneable {
  TaskModel() : super(keyTableName);
  TaskModel.clone() : this();

  @override
  TaskModel clone(Map<String, dynamic> map) => TaskModel.clone()..fromJson(map);

  static const String keyTableName = 'Task';
  static const String keyTitle = 'title';
  static const String keyDescription = 'description';
  static const String keyIsCompleted = 'isCompleted';
  static const String keyUser = 'user';

  String get title => get<String>(keyTitle) ?? '';
  set title(String value) => set<String>(keyTitle, value);

  String get description => get<String>(keyDescription) ?? '';
  set description(String value) => set<String>(keyDescription, value);

  bool get isCompleted => get<bool>(keyIsCompleted) ?? false;
  set isCompleted(bool value) => set<bool>(keyIsCompleted, value);

  ParseUser? get user => get<ParseUser>(keyUser);
  set user(ParseUser? value) => set<ParseUser?>(keyUser, value);
}

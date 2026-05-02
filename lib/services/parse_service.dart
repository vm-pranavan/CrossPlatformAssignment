import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../core/constants.dart';
import '../models/task_model.dart';

class ParseService {
  static Future<void> initParse() async {
    await Parse().initialize(
      AppConstants.keyApplicationId,
      AppConstants.keyParseServerUrl,
      clientKey: AppConstants.keyClientKey,
      autoSendSessionId: true,
      debug: true,
      registeredSubClassMap: <String, ParseObjectConstructor>{
        TaskModel.keyTableName: () => TaskModel(),
      },
    );
  }

  // Auth Operations
  Future<ParseResponse> signUp(String email, String password) async {
    final user = ParseUser(email, password, email);
    return await user.signUp();
  }

  Future<ParseResponse> login(String email, String password) async {
    final user = ParseUser(email, password, email);
    return await user.login();
  }

  Future<void> logout() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    if (user != null) {
      await user.logout();
    }
  }

  Future<ParseUser?> getCurrentUser() async {
    return await ParseUser.currentUser() as ParseUser?;
  }

  // CRUD Operations
  Future<List<TaskModel>> getTasks() async {
    final currentUser = await getCurrentUser();
    if (currentUser == null) return [];

    final QueryBuilder<TaskModel> queryBuilder =
        QueryBuilder<TaskModel>(TaskModel())
          ..whereEqualTo(TaskModel.keyUser, currentUser.toPointer())
          ..orderByDescending('createdAt');

    final ParseResponse response = await queryBuilder.query();

    if (response.success && response.results != null) {
      return response.results!.cast<TaskModel>();
    } else {
      return [];
    }
  }

  Future<ParseResponse> saveTask(String title, String description) async {
    final currentUser = await getCurrentUser();
    final task = TaskModel()
      ..title = title
      ..description = description
      ..isCompleted = false
      ..user = currentUser;

    return await task.save();
  }

  Future<ParseResponse> updateTask(TaskModel task) async {
    return await task.save();
  }

  Future<ParseResponse> deleteTask(TaskModel task) async {
    return await task.delete();
  }
}

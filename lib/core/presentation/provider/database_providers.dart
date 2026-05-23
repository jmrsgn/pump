import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump/core/constants/app/app_constants.dart';
import 'package:pump/core/app_database.dart';

import '../../data/dao/user_dao.dart';

final appDatabaseProvider = FutureProvider<AppDatabase>((ref) async {
  return await $FloorAppDatabase.databaseBuilder(AppConstants.dbName).build();
});

final userDaoProvider = FutureProvider<UserDao>((ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  return db.userDao;
});

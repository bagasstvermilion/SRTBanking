// dependency_injection.dart
// Tambahkan ini ke dalam fungsi init() di file dependency_injection.dart kamu

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import '../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../features/dashboard/domain/usecases/get_dashboard_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ── Firebase ──────────────────────────────────────
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  // ── Dashboard ─────────────────────────────────────

  // Usecase
  sl.registerLazySingleton(() => GetDashboardUsecase(sl()));

  // Repository
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(remoteDatasource: sl()),
  );

  // Datasource
  sl.registerLazySingleton<DashboardRemoteDatasource>(
    () => DashboardRemoteDatasourceImpl(firestore: sl()),
  );
}

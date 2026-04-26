import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/dashboard_remote_datasource.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/usecases/get_dashboard_usecase.dart';

// ─── State ───────────────────────────────────────────────────────────────────

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardEntity data;
  DashboardLoaded(this.data);
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}

// ─── Notifier ────────────────────────────────────────────────────────────────

class DashboardNotifier extends StateNotifier<DashboardState> {
  final GetDashboardUsecase _usecase;

  DashboardNotifier(this._usecase) : super(DashboardInitial());

  Future<void> loadDashboard(String userId) async {
    state = DashboardLoading();

    final result = await _usecase(userId);

    result.fold(
      (failure) => state = DashboardError(failure.message),
      (data) => state = DashboardLoaded(data),
    );
  }
}

// ─── Providers ───────────────────────────────────────────────────────────────

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(
    remoteDatasource: DashboardRemoteDatasourceImpl(
      firestore: FirebaseFirestore.instance,
    ),
  );
});

final getDashboardUsecaseProvider = Provider<GetDashboardUsecase>((ref) {
  final repo = ref.read(dashboardRepositoryProvider);
  return GetDashboardUsecase(repo);
});

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
      final usecase = ref.read(getDashboardUsecaseProvider);
      return DashboardNotifier(usecase);
    });

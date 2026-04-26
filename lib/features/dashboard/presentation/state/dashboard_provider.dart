import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/usecases/get_dashboard_usecase.dart';
import '../../../auth/presentation/state/auth_provider.dart'; // sesuaikan path

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

// ─── Provider ────────────────────────────────────────────────────────────────

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
      final usecase = ref.read(getDashboardUsecaseProvider);
      return DashboardNotifier(usecase);
    });

// Provider untuk usecase — daftarkan di dependency_injection atau di sini
final getDashboardUsecaseProvider = Provider<GetDashboardUsecase>((ref) {
  final repo = ref.read(dashboardRepositoryProvider);
  return GetDashboardUsecase(repo);
});

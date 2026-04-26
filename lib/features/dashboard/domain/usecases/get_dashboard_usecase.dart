import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardUsecase {
  final DashboardRepository repository;

  GetDashboardUsecase(this.repository);

  Future<Either<Failure, DashboardEntity>> call(String userId) {
    return repository.getDashboardData(userId);
  }
}

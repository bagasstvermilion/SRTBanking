import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

// --- state ---

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserEntity user;
  AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

// --- notifier ---

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUsecase _loginUsecase;
  final RegisterUsecase _registerUsecase;
  final LogoutUsecase _logoutUsecase;
  final AuthRepository _repository;

  AuthNotifier({
    required LoginUsecase loginUsecase,
    required RegisterUsecase registerUsecase,
    required LogoutUsecase logoutUsecase,
    required AuthRepository repository,
  }) : _loginUsecase = loginUsecase,
       _registerUsecase = registerUsecase,
       _logoutUsecase = logoutUsecase,
       _repository = repository,
       super(AuthInitial()) {
    _checkCurrentUser();
  }

  void _checkCurrentUser() {
    final user = _repository.getCurrentUser();
    if (user != null) {
      state = AuthAuthenticated(user);
    } else {
      state = AuthUnauthenticated();
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = AuthLoading();
    final result = await _loginUsecase(email: email, password: password);
    result.fold(
      (failure) => state = AuthError(failure.message),
      (user) => state = AuthAuthenticated(user),
    );
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    state = AuthLoading();
    final result = await _registerUsecase(
      email: email,
      password: password,
      fullName: fullName,
    );
    result.fold((failure) => state = AuthError(failure.message), (user) async {
      await Future.delayed(const Duration(seconds: 2));
      state = AuthAuthenticated(user);
    });
  }

  Future<void> logout() async {
    await _logoutUsecase();
    state = AuthUnauthenticated();
  }
}

// --- providers ---

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDatasource: AuthRemoteDatasourceImpl(
      firebaseAuth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    ),
  );
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return AuthNotifier(
    loginUsecase: LoginUsecase(repo),
    registerUsecase: RegisterUsecase(repo),
    logoutUsecase: LogoutUsecase(repo),
    repository: repo,
  );
});

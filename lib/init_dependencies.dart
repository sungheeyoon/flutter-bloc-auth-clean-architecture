import 'package:flutter_auth_template/core/common/cubit/app_user_cubit.dart';
import 'package:flutter_auth_template/core/network/connection_checker.dart';
import 'package:flutter_auth_template/core/secrets/app_secrets.dart';
import 'package:flutter_auth_template/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_auth_template/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_auth_template/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_auth_template/features/auth/domain/usecases/current_user.dart';
import 'package:flutter_auth_template/features/auth/domain/usecases/sign_in.dart';
import 'package:flutter_auth_template/features/auth/domain/usecases/sign_out.dart';
import 'package:flutter_auth_template/features/auth/domain/usecases/sign_up.dart';
import 'package:flutter_auth_template/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  getIt.registerLazySingleton(() => supabase.client);

  //core
  getIt.registerFactory(() => InternetConnection());
  getIt.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      getIt(),
    ),
  );
  getIt.registerLazySingleton(() => AppUserCubit());

  _initAuth();
}

void _initAuth() {
  getIt
    // Datasource
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        getIt(),
      ),
    )
    // Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        getIt(),
        getIt(),
      ),
    )
    // Usecase
    ..registerFactory(
      () => SignIn(
        getIt(),
      ),
    )
    ..registerFactory(
      () => SignUp(
        getIt(),
      ),
    )
    ..registerFactory(
      () => SignOut(
        getIt(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        getIt(),
      ),
    )
    ..registerLazySingleton(
      () => AuthBloc(
        signIn: getIt(),
        signUp: getIt(),
        signOut: getIt(),
        currentUser: getIt(),
        appUserCubit: getIt(),
      ),
    );
}

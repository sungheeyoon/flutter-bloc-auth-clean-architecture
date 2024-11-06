import 'package:flutter_auth_template/core/common/cubit/app_user_cubit.dart';
import 'package:flutter_auth_template/core/usecase/usecase.dart';
import 'package:flutter_auth_template/features/auth/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_template/features/auth/domain/usecases/current_user.dart';
import 'package:flutter_auth_template/features/auth/domain/usecases/sign_in.dart';
import 'package:flutter_auth_template/features/auth/domain/usecases/sign_out.dart';
import 'package:flutter_auth_template/features/auth/domain/usecases/sign_up.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn _signIn;
  final SignUp _signUp;
  final SignOut _signOut;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required SignIn signIn,
    required SignUp signUp,
    required SignOut signOut,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  })  : _signIn = signIn,
        _signUp = signUp,
        _signOut = signOut,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthSignIn>(_onAuthSignIn);
    on<AuthSignOut>(_onAuthSignOut);
    on<AuthIsUserLoggedIn>(_onAuthIsUserLoggedIn);
  }

  void _onAuthIsUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _authSuccess(r, emit),
    );
  }

  void _onAuthSignOut(
    AuthSignOut event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _signOut(NoParams());

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (_) {
        _appUserCubit.updateUser(null);
        emit(AuthInitial());
      },
    );
  }

  void _onAuthSignUp(
    AuthSignUp event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _signUp(
      SignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _authSuccess(r, emit),
    );
  }

  void _onAuthSignIn(
    AuthSignIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _signIn(
      SignInParams(
        email: event.email,
        password: event.password,
      ),
    );

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _authSuccess(r, emit),
    );
  }

  void _authSuccess(
    User user,
    Emitter<AuthState> emit,
  ) {
    _appUserCubit.updateUser(user);
    return emit(AuthSuccess(user));
  }
}

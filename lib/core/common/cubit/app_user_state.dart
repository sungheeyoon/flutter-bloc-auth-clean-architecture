part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState {}

final class AppUserInitial extends AppUserState {}

final class AppUserIsLoggedIn extends AppUserState {
  final User user;
  AppUserIsLoggedIn(this.user);
}

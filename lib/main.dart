import 'package:flutter/material.dart';
import 'package:flutter_auth_template/core/common/cubit/app_user_cubit.dart';
import 'package:flutter_auth_template/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_auth_template/features/auth/presentation/pages/sign_in_page.dart';
import 'package:flutter_auth_template/home_page.dart';
import 'package:flutter_auth_template/init_dependencies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => getIt<AuthBloc>()),
        BlocProvider<AppUserCubit>(create: (_) => getIt<AppUserCubit>())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (AppUserState state) {
          return state is AppUserIsLoggedIn;
        },
        builder: (context, isloggedIn) {
          if (isloggedIn) {
            return const HomePage();
          }
          return const SignInPage();
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_auth_template/core/common/cubit/app_user_cubit.dart';
import 'package:flutter_auth_template/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_auth_template/features/auth/presentation/pages/sign_in_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const HomePage(),
      );
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppUserCubit, AppUserState>(
      listener: (context, state) {
        if (state is AppUserInitial) {
          // 로그아웃 후 AppUserInitial 상태로 변경되면 로그인 페이지로 이동
          Navigator.pushAndRemoveUntil(
            context,
            SignInPage.route(),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            const Text('is logged in'),
            ElevatedButton(
              onPressed: () {
                // 로그아웃 이벤트 트리거
                context.read<AuthBloc>().add(AuthSignOut());
              },
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}

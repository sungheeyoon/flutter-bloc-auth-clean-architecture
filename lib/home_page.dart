import 'package:flutter/material.dart';
import 'package:flutter_auth_template/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const HomePage(),
      );
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('is logged in'),
          ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthSignOut());
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

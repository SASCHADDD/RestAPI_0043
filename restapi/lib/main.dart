import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restapi/data/repositories/auth_repository.dart';
import 'package:restapi/data/repositories/hewan_repository.dart';
import 'package:restapi/logic/bloc/Auth/auth_bloc.dart';
import 'package:restapi/logic/bloc/Auth/auth_event.dart';
import 'package:restapi/logic/bloc/Auth/auth_state.dart';
import 'package:restapi/logic/bloc/Hewan/hewan_bloc.dart';
import 'package:restapi/ui/pages/dashboard_page.dart';
import 'package:restapi/ui/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository()),
        RepositoryProvider(create: (_) => HewanRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (ctx) => AuthBloc(repository: ctx.read<AuthRepository>())
              ..add(AppStarted()),
          ),
          BlocProvider(
            create: (ctx) => HewanBloc(repository: ctx.read<HewanRepository>()),
          ),
        ],
        child: MaterialApp(
          title: 'Ternak App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
            useMaterial3: true,
            fontFamily: 'sans-serif',
          ),
          home: const SplashDecider(),
        ),
      ),
    );
  }
}

class SplashDecider extends StatelessWidget {
  const SplashDecider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial || state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
            ),
          );
        } else if (state is Authenticated) {
          return const DashboardPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}

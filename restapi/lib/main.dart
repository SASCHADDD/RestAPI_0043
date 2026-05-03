import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restapi/data/repositories/auth_repository.dart';
import 'package:restapi/data/repositories/hewan_repository.dart';
import 'package:restapi/logic/bloc/Auth/auth_bloc.dart';
import 'package:restapi/logic/bloc/Auth/auth_event.dart';
import 'package:restapi/logic/bloc/Hewan/hewan_bloc.dart';
import 'package:restapi/ui/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi Repository
    final authRepository = AuthRepository();
    final hewanRepository = HewanRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(repository: authRepository)..add(AppStarted()),
        ),
        BlocProvider(
          create: (context) => HewanBloc(repository: hewanRepository),
        ),
      ],
      child: MaterialApp(
        title: 'REST API App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoginPage(),
      ),
    );
  }
}

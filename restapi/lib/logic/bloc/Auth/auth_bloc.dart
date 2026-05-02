import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restapi/data/repositories/auth_repository.dart';
import 'package:restapi/logic/bloc/Auth/auth_event.dart';
import 'package:restapi/logic/bloc/Auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  final AuthRepository repository;

  AuthBloc({required this.repository}):super(AuthInitial())
}
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}
class LoginRequested extends AuthEvent {
  final String email, password;
  LoginRequested(this.email, this.password);
}
class RegisterRequested extends AuthEvent {
  final String name, email, password;
  RegisterRequested(this.name, this.email, this.password);
}
class LogoutRequested extends AuthEvent {}
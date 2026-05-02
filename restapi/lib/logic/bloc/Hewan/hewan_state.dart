import 'package:equatable/equatable.dart';
import 'package:restapi/data/model/hewan_model.dart';

abstract class HewanState extends Equatable{
  @override
  List<Object?> get props => [];
}
class HewanInitial extends HewanState {}
class HewanLoading extends HewanState {}
class HewanLoaded extends HewanState {
  final List<HewanModel> hewanList;
  HewanLoaded(this.hewanList);
  @override
  List<Object?> get props => [hewanList];
}


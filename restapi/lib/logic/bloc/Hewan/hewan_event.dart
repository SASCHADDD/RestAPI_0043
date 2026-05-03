import 'package:equatable/equatable.dart';

abstract class HewanEvent extends Equatable{
  List<Object> get props => [];
}

class FetchHewan extends HewanEvent {}

class CreateHewan extends HewanEvent {
  final Map<String, dynamic> data;
  CreateHewan(this.data);
  @override
  List<Object> get props => [data];
}

class UpdateHewan extends HewanEvent {
  final int id;
  final Map<String, dynamic> data;
  UpdateHewan(this.id, this.data);
  @override
  List<Object> get props => [id, data];
}

class DeleteHewan extends HewanEvent {
  final int id;
  DeleteHewan(this.id);
  @override
  List<Object> get props => [id];
}
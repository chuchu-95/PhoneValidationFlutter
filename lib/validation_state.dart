import 'package:equatable/equatable.dart';

abstract class ValidationState extends Equatable {
  const ValidationState();

  @override
  List<Object> get props => [];
}

class ValidationInitial extends ValidationState {}

class ValidationLoading extends ValidationState {}

class ValidationSuccess extends ValidationState {
  final String phoneNumber;

  ValidationSuccess(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class ValidationFailure extends ValidationState {}

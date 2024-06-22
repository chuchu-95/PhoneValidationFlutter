import 'package:equatable/equatable.dart';

abstract class PhoneNumberEvent extends Equatable {
  const PhoneNumberEvent();

  @override
  List<Object> get props => [];
}

class PhoneNumberChanged extends PhoneNumberEvent {
  final String phoneNumber;

  const PhoneNumberChanged(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class ValidatePhoneNumber extends PhoneNumberEvent {}

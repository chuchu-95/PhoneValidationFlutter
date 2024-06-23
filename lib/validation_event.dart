import 'package:equatable/equatable.dart';

abstract class ValidationEvent extends Equatable {
  const ValidationEvent();

  @override
  List<Object> get props => [];
}

class ValidatePhoneNumber extends ValidationEvent {
  final String countryCode;
  final String phoneNumber;
  final String flagAsset;

  ValidatePhoneNumber({required this.countryCode, required this.phoneNumber, required this.flagAsset});

  @override
  List<Object> get props => [countryCode, phoneNumber, flagAsset];
}

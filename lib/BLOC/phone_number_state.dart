import 'package:equatable/equatable.dart';

class PhoneNumberState extends Equatable {
  final String phoneNumber;
  final bool isValid;

  const PhoneNumberState({required this.phoneNumber, this.isValid = false});

  @override
  List<Object> get props => [phoneNumber, isValid];
}

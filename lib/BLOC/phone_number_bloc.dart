import 'package:flutter_bloc/flutter_bloc.dart';
import 'phone_number_event.dart';
import 'phone_number_state.dart';

class PhoneNumberBloc extends Bloc<PhoneNumberEvent, PhoneNumberState> {
  PhoneNumberBloc() : super(const PhoneNumberState(phoneNumber: ''));

  @override
  Stream<PhoneNumberState> mapEventToState(PhoneNumberEvent event) async* {
    if (event is PhoneNumberChanged) {
      yield PhoneNumberState(phoneNumber: event.phoneNumber);
    } else if (event is ValidatePhoneNumber) {
      // phone validation logic
      final isValid = _validatePhoneNumber(state.phoneNumber);
      yield PhoneNumberState(phoneNumber: state.phoneNumber, isValid: isValid);
    }
  }

  bool _validatePhoneNumber(String phoneNumber) {
    // 使用正则表达式或API进行验证
    return RegExp(r'^\+?\d{10,15}$').hasMatch(phoneNumber);
  }
}

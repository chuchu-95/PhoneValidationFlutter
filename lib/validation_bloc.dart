import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'validation_event.dart';
import 'validation_state.dart';

class ValidationBloc extends Bloc<ValidationEvent, ValidationState> {
  ValidationBloc() : super(ValidationInitial()) {
    on<ValidatePhoneNumber>(_onValidatePhoneNumber);
  }

  void _onValidatePhoneNumber(
    ValidatePhoneNumber event,
    Emitter<ValidationState> emit,
  ) async {
    emit(ValidationLoading());
    try {
      final accountSid = ''; 
      final authToken = ''; 
      final basicAuth = 'Basic ' + base64Encode(utf8.encode('$accountSid:$authToken'));

      final formattedNumber = event.countryCode + event.phoneNumber;
      print(formattedNumber);
      final flagAssetUpper = event.flagAsset.toUpperCase();
      print(flagAssetUpper);

      final response = await http.get(
        Uri.parse('https://lookups.twilio.com/v1/PhoneNumbers/$formattedNumber?CountryCode=$flagAssetUpper'),
        headers: {
          'Authorization': basicAuth,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final formattedNumber = responseData['phone_number'];
        emit(ValidationSuccess(formattedNumber));
      } else {
        emit(ValidationFailure());
      }
    } catch (e) {
      emit(ValidationFailure());
    }
  }
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_result.freezed.dart';

@freezed
class AuthResult<T> with _$AuthResult {
  factory AuthResult.success(T sucess) = Success;
  factory AuthResult.error(String message) = Error;
}

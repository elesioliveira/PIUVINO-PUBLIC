import 'package:freezed_annotation/freezed_annotation.dart';

part 'adress_result.freezed.dart';

@freezed
class AdressResult<T> with _$AdressResult {
  factory AdressResult.success(T sucess) = Success;
  factory AdressResult.error(String message) = Error;
}

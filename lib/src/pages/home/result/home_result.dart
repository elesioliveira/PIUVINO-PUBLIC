import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_result.freezed.dart';

@freezed
class HomeResult<T> with _$HomeResult {
  factory HomeResult.success(T sucess) = Success;
  factory HomeResult.error(String message) = Error;
}

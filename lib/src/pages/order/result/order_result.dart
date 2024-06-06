import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_result.freezed.dart';

@freezed
class OrderResult<T> with _$OrderResult {
  factory OrderResult.success(T sucess) = Success;
  factory OrderResult.error(String message) = Error;
}

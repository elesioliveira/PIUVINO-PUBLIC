import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_report_result.freezed.dart';

@freezed
class UserReportResult<T> with _$UserReportResult {
  factory UserReportResult.success(T sucess) = Success;
  factory UserReportResult.error(String message) = Error;
}

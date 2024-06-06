import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorito_result.freezed.dart';

@freezed
class FavoritoResult<T> with _$FavoritoResult {
  factory FavoritoResult.success(T sucess) = Success;
  factory FavoritoResult.error(String message) = Error;
}

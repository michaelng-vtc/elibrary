import 'package:freezed_annotation/freezed_annotation.dart';

/// Converts string or int from JSON to int
/// Handles MySQL returning numeric fields as strings
int stringToInt(dynamic json) {
  if (json is int) return json;
  if (json is String) return int.parse(json);
  throw ArgumentError('Cannot convert $json to int');
}

/// Converts int to string for JSON
String intToString(int value) => value.toString();

/// Converts string or int from JSON to nullable int
/// Handles MySQL returning numeric fields as strings
int? nullableStringToInt(dynamic json) {
  if (json == null) return null;
  if (json is int) return json;
  if (json is String) return int.tryParse(json);
  return null;
}

/// Converts nullable int to nullable string for JSON
String? intToNullableString(int? value) => value?.toString();

/// Converter class for use with JsonKey annotation (deprecated, use functions above)
@Deprecated('Use stringToInt and intToString functions instead')
class StringToIntConverter implements JsonConverter<int, dynamic> {
  const StringToIntConverter();

  @override
  int fromJson(dynamic json) => stringToInt(json);

  @override
  dynamic toJson(int object) => intToString(object);
}

/// Converter class for nullable values (deprecated, use functions above)
@Deprecated('Use nullableStringToInt and intToNullableString functions instead')
class NullableStringToIntConverter implements JsonConverter<int?, dynamic> {
  const NullableStringToIntConverter();

  @override
  int? fromJson(dynamic json) => nullableStringToInt(json);

  @override
  dynamic toJson(int? object) => intToNullableString(object);
}

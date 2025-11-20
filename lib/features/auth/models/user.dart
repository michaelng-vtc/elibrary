import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/converters/json_converters.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// User model with freezed and json_serializable
@freezed
class User with _$User {
  const factory User({
    @JsonKey(name: 'user_id', fromJson: stringToInt, toJson: intToString)
    required int userId,
    required String username,
    @JsonKey(name: 'is_admin', fromJson: stringToInt, toJson: intToString)
    @Default(0)
    int isAdmin,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

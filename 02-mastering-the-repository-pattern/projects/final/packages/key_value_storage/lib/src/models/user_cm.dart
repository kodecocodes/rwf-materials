import 'package:hive/hive.dart';

part 'user_cm.g.dart';

@HiveType(typeId: 2)
class UserCM {
  UserCM({
    required this.username,
    required this.email,
  });

  @HiveField(0)
  final String username;
  @HiveField(1)
  final String email;
}

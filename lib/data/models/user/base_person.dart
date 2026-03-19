import '../../../utils/functions/base_functions.dart';
import '../../../utils/helpers/parser.dart';

class BasePerson {
  final String id;
  final String fullName;
  final String? username;
  final String? email;
  final String? phone;
  final String? avatar;
  final DateTime? createdAt;
  BasePerson({
    required this.id,
    required this.fullName,
    this.username,
    this.email,
    this.phone,
    this.avatar,
    this.createdAt,
  });

  factory BasePerson.fromMap(Map<String, dynamic> map) {
    return catchErrorOnParseModel<BasePerson>(() {
      return BasePerson(
        id: map['id']?.toString() ?? '',
        fullName:
            map['fullName']?.toString() ?? map['full_name']?.toString() ?? '',
        username: map['username']?.toString() ?? map['user_name']?.toString(),
        email: map['email']?.toString(),
        phone: map['phone']?.toString() ?? map['phone_number']?.toString(),
        avatar: map['avatar']?.toString(),
        createdAt: parseServerTimeZoneDateTime(map['createdAt']),
      );
    }, map);
  }
}

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:zili_coffee/data/models/address/customer_address.dart';
import 'package:zili_coffee/data/models/user/company.dart';
import 'package:zili_coffee/data/models/user/employee_role.dart';
import 'package:zili_coffee/utils/enums.dart';

import '../../../utils/enums/user_enum.dart';
import '../../entity/user/customer_entity.dart';

class User {
  final String id;
  final String name;
  final Gender? gender;
  final String? phone;
  final String? email;
  final String? avatar;
  final PositionType? positionType;
  List<CustomerAddress> customerAddresses;

  // Các field mới từ response
  final String? username;
  final UserStatus? status;
  final String? pinCode;
  final DateTime? registerDate;
  final String? rejectReasonId;
  final String? rejectStatus;
  final bool? isTwoFactorAuthenticationEnabled;
  final String? twoFactorAuthenticationSecret;
  final bool isTwoFactorAuthenticated;
  final String? verifiedById;
  final String? verificationTime;
  final String? rejectDetails;
  final String? rejectNote;
  final String? position;
  final int countReject;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final EmployeeRole? role;
  final double amount;
  final double amountVn;
  final double totalDeposit;
  final double totalDepositVn;
  final String? country;
  final String? note;
  final String? rejectContractReasonId;
  final String? rejectContractNote;
  final String? issuing;
  final String? issuingCertificate;
  final String? permanentAddress;
  final String? stepKyb;
  final String? certificateDetailJson;
  final DateTime? dateOfIssue;
  final Company? company;

  User({
    required this.id,
    required this.name,
    this.gender,
    this.phone,
    this.email,
    this.avatar,
    this.positionType,
    this.customerAddresses = const [],
    this.username,
    this.status,
    this.pinCode,
    this.registerDate,
    this.rejectReasonId,
    this.rejectStatus,
    this.isTwoFactorAuthenticationEnabled,
    this.twoFactorAuthenticationSecret,
    this.isTwoFactorAuthenticated = false,
    this.verifiedById,
    this.verificationTime,
    this.rejectDetails,
    this.rejectNote,
    this.position,
    this.countReject = 0,
    this.createdAt,
    this.updatedAt,
    this.role,
    this.amount = 0.0,
    this.amountVn = 0.0,
    this.totalDeposit = 0.0,
    this.totalDepositVn = 0.0,
    this.country,
    this.note,
    this.rejectContractReasonId,
    this.rejectContractNote,
    this.issuing,
    this.issuingCertificate,
    this.permanentAddress,
    this.stepKyb,
    this.certificateDetailJson,
    this.dateOfIssue,
    this.company,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    // String? roleStr;
    // if (map['role'] is String) {
    //   roleStr = map['role'] as String;
    // } else if (map['role'] is Map<String, dynamic>) {
    //   roleStr = (map['role'] as Map<String, dynamic>)['name'] as String;
    // }

    final positionTypeStr = map['position'] != null
        ? map['position'] as String
        : null;
    final positionType = positionTypeStr != null
        ? PositionType.values.firstWhere((e) => e.toConstant == positionTypeStr)
        : null;
    return User(
      id: map['id']?.toString() ?? '',
      name: map['fullName']?.toString() ?? '',
      gender: map['gender'] != null
          ? map['gender'] == 1
                ? Gender.female
                : map['gender'] == 0
                ? Gender.male
                : Gender.other
          : null,
      phone: map['phone']?.toString(),
      email: map['email']?.toString(),
      avatar: map['avatar']?.toString(),
      customerAddresses: map['customer_addresses'] != null
          ? List<CustomerAddress>.from(
              (map['customer_addresses'] as List<dynamic>).map<CustomerAddress>(
                (x) => CustomerAddress.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      positionType: positionType,
      username: map['username']?.toString(),
      status: map['status'] != null
          ? UserStatus.fromString(map['status'] as String)
          : null,
      pinCode: map['pinCode']?.toString(),
      registerDate: map['registerDate'] != null
          ? DateTime.tryParse(map['registerDate'].toString())
          : null,
      rejectReasonId: map['rejectReasonId']?.toString(),
      rejectStatus: map['rejectStatus']?.toString(),
      isTwoFactorAuthenticationEnabled:
          map['isTwoFactorAuthenticationEnabled'] as bool?,
      twoFactorAuthenticationSecret: map['twoFactorAuthenticationSecret']
          ?.toString(),
      isTwoFactorAuthenticated:
          map['isTwoFactorAuthenticated'] as bool? ?? false,
      verifiedById: map['verifiedById']?.toString(),
      verificationTime: map['verificationTime']?.toString(),
      rejectDetails: map['rejectDetails']?.toString(),
      rejectNote: map['rejectNote']?.toString(),
      position: map['position']?.toString(),
      countReject: (map['countReject'] as num?)?.toInt() ?? 0,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString())
          : null,
      role: map['role'] != null
          ? EmployeeRole.fromMap(map['role'] as Map<String, dynamic>)
          : null,
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      amountVn: (map['amountVn'] as num?)?.toDouble() ?? 0.0,
      totalDeposit: (map['totalDeposit'] as num?)?.toDouble() ?? 0.0,
      totalDepositVn: (map['totalDepositVn'] as num?)?.toDouble() ?? 0.0,
      country: map['country']?.toString() ?? map['countryName']?.toString(),
      note: map['note']?.toString(),
      rejectContractReasonId: map['rejectContractReasonId']?.toString(),
      rejectContractNote: map['rejectContractNote']?.toString(),
      issuing: map['issuing']?.toString(),
      issuingCertificate: map['issuingCertificate']?.toString(),
      permanentAddress: map['permanentAddress']?.toString(),
      stepKyb: map['stepKyb']?.toString(),
      certificateDetailJson: map['certificateDetailJson']?.toString(),
      dateOfIssue: map['dateOfIssue'] != null
          ? DateTime.tryParse(map['dateOfIssue'].toString())
          : null,
      company: map['company'] != null
          ? Company.fromMap(map['company'] as Map<String, dynamic>)
          : null,
    );
  }

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  User copyWith({
    String? id,
    String? name,
    Gender? gender,
    String? phone,
    String? email,
    String? avatar,
    PositionType? positionType,
    List<CustomerAddress>? customerAddresses,
    String? username,
    UserStatus? status,
    String? pinCode,
    DateTime? registerDate,
    String? rejectReasonId,
    String? rejectStatus,
    bool? isTwoFactorAuthenticationEnabled,
    String? twoFactorAuthenticationSecret,
    bool? isTwoFactorAuthenticated,
    String? verifiedById,
    String? verificationTime,
    String? rejectDetails,
    String? rejectNote,
    String? position,
    int? countReject,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? amount,
    double? amountVn,
    double? totalDeposit,
    double? totalDepositVn,
    String? country,
    String? note,
    String? rejectContractReasonId,
    String? rejectContractNote,
    String? issuing,
    String? issuingCertificate,
    String? permanentAddress,
    String? stepKyb,
    String? certificateDetailJson,
    DateTime? dateOfIssue,
    Company? company,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      positionType: positionType ?? this.positionType,
      customerAddresses: customerAddresses ?? this.customerAddresses,
      username: username ?? this.username,
      status: status ?? this.status,
      pinCode: pinCode ?? this.pinCode,
      registerDate: registerDate ?? this.registerDate,
      rejectReasonId: rejectReasonId ?? this.rejectReasonId,
      rejectStatus: rejectStatus ?? this.rejectStatus,
      isTwoFactorAuthenticationEnabled:
          isTwoFactorAuthenticationEnabled ??
          this.isTwoFactorAuthenticationEnabled,
      twoFactorAuthenticationSecret:
          twoFactorAuthenticationSecret ?? this.twoFactorAuthenticationSecret,
      isTwoFactorAuthenticated:
          isTwoFactorAuthenticated ?? this.isTwoFactorAuthenticated,
      verifiedById: verifiedById ?? this.verifiedById,
      verificationTime: verificationTime ?? this.verificationTime,
      rejectDetails: rejectDetails ?? this.rejectDetails,
      rejectNote: rejectNote ?? this.rejectNote,
      position: position ?? this.position,
      countReject: countReject ?? this.countReject,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      amount: amount ?? this.amount,
      amountVn: amountVn ?? this.amountVn,
      totalDeposit: totalDeposit ?? this.totalDeposit,
      totalDepositVn: totalDepositVn ?? this.totalDepositVn,
      country: country ?? this.country,
      note: note ?? this.note,
      rejectContractReasonId:
          rejectContractReasonId ?? this.rejectContractReasonId,
      rejectContractNote: rejectContractNote ?? this.rejectContractNote,
      issuing: issuing ?? this.issuing,
      issuingCertificate: issuingCertificate ?? this.issuingCertificate,
      permanentAddress: permanentAddress ?? this.permanentAddress,
      stepKyb: stepKyb ?? this.stepKyb,
      certificateDetailJson:
          certificateDetailJson ?? this.certificateDetailJson,
      dateOfIssue: dateOfIssue ?? this.dateOfIssue,
      company: company ?? this.company,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "name": name,
      "gender": gender?.toInt(),
      "phone": phone,
      "email": email,
      "avatar": avatar,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'User(id: $id, name: $name, username: $username, email: $email, phone: $phone, status: $status, position: $position, company: ${company?.id})';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.gender == gender &&
        other.phone == phone &&
        other.email == email &&
        other.avatar == avatar &&
        other.positionType == positionType &&
        listEquals(other.customerAddresses, customerAddresses) &&
        other.username == username &&
        other.status == status &&
        other.position == position;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        gender.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        avatar.hashCode ^
        positionType.hashCode ^
        customerAddresses.hashCode ^
        username.hashCode ^
        status.hashCode ^
        position.hashCode;
  }
}

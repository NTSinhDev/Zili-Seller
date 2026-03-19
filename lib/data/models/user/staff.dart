import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:zili_coffee/data/entity/user/customer_entity.dart';
import 'package:zili_coffee/data/models/address/customer_address.dart';
import 'package:zili_coffee/data/models/user/company.dart';
import 'package:zili_coffee/data/models/user/user.dart';
import 'package:zili_coffee/utils/enums.dart';

import '../../../utils/enums/user_enum.dart';

/// Model Staff kế thừa từ User
///
/// Model này chứa thông tin chi tiết về staff/nhân viên,
/// kế thừa tất cả các trường từ User.
///
/// Staff không có thêm field riêng, tất cả đều kế thừa từ User.
class Staff extends User {
  // Tất cả các trường đã được kế thừa từ User:
  // - id, name, gender, phone, email, avatar, customerAddresses, positionType
  // - username, status, pinCode, registerDate, rejectReasonId, rejectStatus
  // - isTwoFactorAuthenticationEnabled, twoFactorAuthenticationSecret, isTwoFactorAuthenticated
  // - verifiedById, verificationTime, rejectDetails, rejectNote, position
  // - countReject, createdAt, updatedAt, role, amount, amountVn
  // - totalDeposit, totalDepositVn, country, note
  // - rejectContractReasonId, rejectContractNote, issuing, issuingCertificate
  // - permanentAddress, stepKyb, certificateDetailJson, dateOfIssue, company

  Staff({
    required super.id,
    required super.name,
    super.gender,
    super.phone,
    super.email,
    super.avatar,
    super.customerAddresses = const [],
    super.positionType,
    super.username,
    super.status,
    super.pinCode,
    super.registerDate,
    super.rejectReasonId,
    super.rejectStatus,
    super.isTwoFactorAuthenticationEnabled,
    super.twoFactorAuthenticationSecret,
    super.isTwoFactorAuthenticated = false,
    super.verifiedById,
    super.verificationTime,
    super.rejectDetails,
    super.rejectNote,
    super.position,
    super.countReject = 0,
    super.createdAt,
    super.updatedAt,
    super.role,
    super.amount = 0.0,
    super.amountVn = 0.0,
    super.totalDeposit = 0.0,
    super.totalDepositVn = 0.0,
    super.country,
    super.note,
    super.rejectContractReasonId,
    super.rejectContractNote,
    super.issuing,
    super.issuingCertificate,
    super.permanentAddress,
    super.stepKyb,
    super.certificateDetailJson,
    super.dateOfIssue,
    super.company,
  });

  /// Factory constructor để tạo Staff từ Map
  ///
  /// Xử lý parsing các trường từ JSON response,
  /// bao gồm cả các trường từ User (fullName -> name)
  factory Staff.fromMap(Map<String, dynamic> map) {
    // Parse các trường từ User
    final user = User.fromMap(map);

    return Staff(
      // Từ User - truyền tất cả các field từ User
      id: user.id,
      name: user.name,
      gender: user.gender,
      phone: user.phone,
      email: user.email,
      avatar: user.avatar,
      customerAddresses: user.customerAddresses,
      positionType: user.positionType,
      // Các field mới từ User
      username: user.username ?? map['username'] as String?,
      status: user.status,
      pinCode: user.pinCode,
      registerDate: user.registerDate,
      rejectReasonId: user.rejectReasonId,
      rejectStatus: user.rejectStatus,
      isTwoFactorAuthenticationEnabled: user.isTwoFactorAuthenticationEnabled,
      twoFactorAuthenticationSecret: user.twoFactorAuthenticationSecret,
      isTwoFactorAuthenticated: user.isTwoFactorAuthenticated,
      verifiedById: user.verifiedById,
      verificationTime: user.verificationTime,
      rejectDetails: user.rejectDetails,
      rejectNote: user.rejectNote,
      position: user.position,
      countReject: user.countReject,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      role: user.role,
      amount: user.amount,
      amountVn: user.amountVn,
      totalDeposit: user.totalDeposit,
      totalDepositVn: user.totalDepositVn,
      country: user.country,
      note: user.note,
      rejectContractReasonId: user.rejectContractReasonId,
      rejectContractNote: user.rejectContractNote,
      issuing: user.issuing,
      issuingCertificate: user.issuingCertificate,
      permanentAddress: user.permanentAddress,
      stepKyb: user.stepKyb,
      certificateDetailJson: user.certificateDetailJson,
      dateOfIssue: user.dateOfIssue,
      company: user.company,
    );
  }

  /// Factory constructor để tạo Staff từ JSON string
  factory Staff.fromJson(String source) =>
      Staff.fromMap(json.decode(source) as Map<String, dynamic>);

  /// Tạo Staff từ User (conversion)
  ///
  /// Hữu ích khi cần convert User thành Staff
  factory Staff.fromUser(User user, {Map<String, dynamic>? additionalData}) {
    final staff = Staff(
      id: user.id,
      name: user.name,
      gender: user.gender,
      phone: user.phone,
      email: user.email,
      avatar: user.avatar,
      customerAddresses: user.customerAddresses,
      positionType: user.positionType,
    );

    if (additionalData != null) {
      return Staff.fromMap({...user.toMap(), ...additionalData});
    }

    return staff;
  }

  @override
  @override
  Staff copyWith({
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
    return Staff(
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

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'positionType': positionType?.toConstant,
      'username': username,
      'status': status?.value,
      'pinCode': pinCode,
      'registerDate': registerDate?.toIso8601String(),
      'rejectReasonId': rejectReasonId,
      'rejectStatus': rejectStatus,
      'isTwoFactorAuthenticationEnabled': isTwoFactorAuthenticationEnabled,
      'twoFactorAuthenticationSecret': twoFactorAuthenticationSecret,
      'isTwoFactorAuthenticated': isTwoFactorAuthenticated,
      'verifiedById': verifiedById,
      'verificationTime': verificationTime,
      'rejectDetails': rejectDetails,
      'rejectNote': rejectNote,
      'position': position,
      'countReject': countReject,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'amount': amount,
      'amountVn': amountVn,
      'totalDeposit': totalDeposit,
      'totalDepositVn': totalDepositVn,
      'country': country,
      'note': note,
      'rejectContractReasonId': rejectContractReasonId,
      'rejectContractNote': rejectContractNote,
      'issuing': issuing,
      'issuingCertificate': issuingCertificate,
      'permanentAddress': permanentAddress,
      'stepKyb': stepKyb,
      'certificateDetailJson': certificateDetailJson,
      'dateOfIssue': dateOfIssue?.toIso8601String(),
    });
    return map;
  }

  @override
  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Staff(id: $id, name: $name, username: $username, status: $status, position: $position, email: $email, phone: $phone, avatar: $avatar)';
  }

  @override
  bool operator ==(covariant Staff other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.gender == gender &&
        other.phone == phone &&
        other.email == email &&
        other.avatar == avatar &&
        listEquals(other.customerAddresses, customerAddresses) &&
        other.positionType == positionType &&
        other.username == username &&
        other.status == status &&
        other.pinCode == pinCode &&
        other.registerDate == registerDate &&
        other.rejectReasonId == rejectReasonId &&
        other.rejectStatus == rejectStatus &&
        other.isTwoFactorAuthenticationEnabled ==
            isTwoFactorAuthenticationEnabled &&
        other.twoFactorAuthenticationSecret == twoFactorAuthenticationSecret &&
        other.isTwoFactorAuthenticated == isTwoFactorAuthenticated &&
        other.verifiedById == verifiedById &&
        other.verificationTime == verificationTime &&
        other.rejectDetails == rejectDetails &&
        other.rejectNote == rejectNote &&
        other.position == position &&
        other.countReject == countReject &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.amount == amount &&
        other.amountVn == amountVn &&
        other.totalDeposit == totalDeposit &&
        other.totalDepositVn == totalDepositVn &&
        other.country == country &&
        other.note == note &&
        other.rejectContractReasonId == rejectContractReasonId &&
        other.rejectContractNote == rejectContractNote &&
        other.issuing == issuing &&
        other.issuingCertificate == issuingCertificate &&
        other.permanentAddress == permanentAddress &&
        other.stepKyb == stepKyb &&
        other.certificateDetailJson == certificateDetailJson &&
        other.dateOfIssue == dateOfIssue;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      id,
      name,
      gender,
      phone,
      email,
      avatar,
      customerAddresses,
      positionType,
      username,
      status,
      pinCode,
      registerDate,
      rejectReasonId,
      rejectStatus,
      isTwoFactorAuthenticationEnabled,
      twoFactorAuthenticationSecret,
      isTwoFactorAuthenticated,
      verifiedById,
      verificationTime,
      rejectDetails,
      rejectNote,
      position,
      countReject,
      createdAt,
      updatedAt,
      amount,
      amountVn,
      totalDeposit,
      totalDepositVn,
      country,
      note,
      rejectContractReasonId,
      rejectContractNote,
      issuing,
      issuingCertificate,
      permanentAddress,
      stepKyb,
      certificateDetailJson,
      dateOfIssue,
    ]);
  }
}

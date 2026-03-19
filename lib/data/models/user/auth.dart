import 'dart:convert';

import 'package:zili_coffee/data/models/user/user.dart';
import 'package:zili_coffee/data/models/user/ability.dart';
import 'package:zili_coffee/utils/helpers/permission_helper.dart';

import '../../../utils/enums.dart';
import '../../../utils/enums/user_enum.dart';

class Auth {
  final String accessToken;
  final User? customer;
  final List<Ability> abilities;
  final List<String> sellerPermissions;
  Auth({
    required this.accessToken,
    this.customer,
    this.abilities = const [],
    this.sellerPermissions = const [],
  });

  bool get isAccountant {
    return customer?.positionType == PositionType.businessOwner ||
        customer?.role?.key == Role.accountant.toConstant ||
        customer?.role?.key == Role.chiefAccountant.toConstant;
  }

  bool get isTechnicalStaff {
    return customer?.role?.key == Role.technicalManager.toConstant ||
        customer?.role?.key == Role.packingManager.toConstant ||
        customer?.role?.key == Role.technicalStaff.toConstant ||
        customer?.role?.key == Role.packingStaff.toConstant;
  }

  bool get isExportedWarehouseStaff {
    return customer?.role?.key == Role.technicalManager.toConstant ||
        customer?.role?.key == Role.technicalStaff.toConstant;
  }

  bool get isPackingStaff {
    return customer?.role?.key == Role.packingManager.toConstant ||
        customer?.role?.key == Role.packingStaff.toConstant;
  }

  String get getToken => 'Bearer $accessToken';

  bool get isBusinessOwner =>
      customer?.positionType == PositionType.businessOwner;

  bool get isSales =>
      !isBusinessOwner && customer?.role?.key == Role.saleStaff.toConstant;

  bool get isShowQuoteOnOrder =>
      isAccountant &&
      PermissionHelper.create(AbilitySubject.quotationManagement);

  Auth copyWith({
    String? accessToken,
    String? id,
    User? customer,
    List<Ability>? abilities,
    List<String>? sellerPermissions,
  }) {
    return Auth(
      accessToken: accessToken ?? this.accessToken,
      customer: customer ?? this.customer,
      abilities: abilities ?? this.abilities,
      sellerPermissions: sellerPermissions ?? this.sellerPermissions,
    );
  }

  factory Auth.fromMap(Map<String, dynamic> map) {
    final abilityList = (map['ability'] as List<dynamic>? ?? [])
        .map((e) => Ability.fromMap(e as Map<String, dynamic>))
        .toList();
    final sellerPermissions =
        (map['user']?['role']?['sellerPermissions'] as List<dynamic>? ??
                map['sellerPermissions'] as List<dynamic>? ??
                [])
            .map(
              (e) => (e is Map ? e['name'] : e)?.toString().toLowerCase() ?? '',
            )
            .where((e) => e.isNotEmpty)
            .toList();

    // Map sellerPermissions -> abilities bổ sung (action_subject)
    final mappedFromSellerPermissions = sellerPermissions
        .map((perm) {
          final parts = perm.split('_');
          if (parts.length < 2) return null;
          final action = parts.first;
          final subject = parts.sublist(1).join('_');
          if (action.isEmpty || subject.isEmpty) return null;
          return Ability(action: action, subject: subject);
        })
        .whereType<Ability>()
        .toList();

    // Hợp nhất, tránh trùng lặp
    final mergedAbilities = [
      ...abilityList,
      ...mappedFromSellerPermissions.where(
        (mapped) => !abilityList.any(
          (base) =>
              base.action == mapped.action && base.subject == mapped.subject,
        ),
      ),
    ];

    return Auth(
      accessToken: map['token'] as String,
      customer: map['user'] != null
          ? User.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      abilities: mergedAbilities,
      sellerPermissions: sellerPermissions,
    );
  }

  factory Auth.fromJson(String source) =>
      Auth.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'token': accessToken,
      'customer': customer?.toMap(),
      'ability': abilities.map((e) => e.toMap()).toList(),
      'sellerPermissions': sellerPermissions,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'Auth(accessToken: $accessToken, customer: $customer)';

  @override
  bool operator ==(covariant Auth other) {
    if (identical(this, other)) return true;

    return other.accessToken == accessToken && other.customer == customer;
  }

  @override
  int get hashCode => accessToken.hashCode ^ customer.hashCode;
}

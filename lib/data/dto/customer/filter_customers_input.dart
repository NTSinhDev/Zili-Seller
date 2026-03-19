// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:zili_coffee/data/models/user/staff.dart';
import 'package:zili_coffee/utils/enums.dart';
import 'package:zili_coffee/utils/extension/extension.dart';

import '../../../utils/enums/customer_enum.dart';

class FilterCustomersInput {
  String? keyword;
  List<CustomerStatus>? statuses;
  DateTime? createdAtFrom;
  DateTime? createdAtTo;
  List<Staff?>? createdBys;
  List<dynamic>? groups;
  int limit;
  int offset;

  FilterCustomersInput({
    this.keyword,
    this.limit = 20,
    this.offset = 0,
    this.statuses,
    this.createdAtFrom,
    this.createdAtTo,
    this.createdBys,
    this.groups,
  });

  FilterCustomersInput loadMore({required int offset}) {
    return copyWith(offset: offset);
  }

  Map<String, dynamic> toMap() {
    return {
      if(keyword.isNotNull && (keyword ?? "").isNotEmpty) 'keyword': keyword,
      if(statuses.isNotNull && (statuses ?? []).isNotEmpty) "status[]": statuses?.map((status) => status.toConstant).toList(),
      if(createdAtFrom.isNotNull) 'createdAtFrom': createdAtFrom
          ?.startOfDate()
          .toIso8601StringWithTimezone(),
      if(createdAtTo.isNotNull) 'createdAtTo': createdAtTo?.endOfDate().toIso8601StringWithTimezone(),
      if(createdBys.isNotNull && (createdBys ?? []).isNotEmpty) 'createdByIds[]': createdBys
          ?.where((staff) => staff != null)
          .map((staff) => staff?.id)
          .toList(),
      if(groups.isNotNull && (groups ?? []).isNotEmpty) 'groupIds[]': groups
          ?.where((group) => group != null)
          .map((group) => group?.id)
          .toList(),
      if(limit.isNotNull) 'limit': limit,
      if(offset.isNotNull) 'offset': offset,
    };
  }

  FilterCustomersInput copyWith({
    String? keyword,
    List<CustomerStatus>? statuses,
    DateTime? createdAtFrom,
    DateTime? createdAtTo,
    List<Staff?>? createdBys,
    List<dynamic>? groups,
    int? limit,
    int? offset,
  }) {
    return FilterCustomersInput(
      keyword: keyword ?? this.keyword,
      statuses: statuses ?? this.statuses,
      createdAtFrom: createdAtFrom ?? this.createdAtFrom,
      createdAtTo: createdAtTo ?? this.createdAtTo,
      createdBys: createdBys ?? this.createdBys,
      groups: groups ?? this.groups,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }
}

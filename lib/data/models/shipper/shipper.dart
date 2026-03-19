class Shipper {
  final String? id;
  final String? name;
  final String? type;
  final String? code;
  final String? phone;
  final String? email;
  final String? address;
  final dynamic group;
  final dynamic employeeId;
  final dynamic paidBy;
  final dynamic note;
  final dynamic status;
  final dynamic countOrders;
  final dynamic totalShippingFee;
  final dynamic currentDebt;
  final dynamic totalAmountReconciled;
  final dynamic totalAmountReconciling;
  final dynamic totalAmountNotReconciled;
  final dynamic totalReconciled;
  final dynamic totalReconciling;
  final dynamic totalNotReconciled;
  final dynamic totalOrder;
  final dynamic totalOrderProcessing;
  final DateTime? createdAt;

  Shipper({
    this.id,
    this.name,
    this.type,
    this.code,
    this.phone,
    this.email,
    this.address,
    this.group,
    this.employeeId,
    this.paidBy,
    this.note,
    this.createdAt,
    this.status,
    this.countOrders,
    this.totalShippingFee,
    this.currentDebt,
    this.totalAmountReconciled,
    this.totalAmountReconciling,
    this.totalAmountNotReconciled,
    this.totalReconciled,
    this.totalReconciling,
    this.totalNotReconciled,
    this.totalOrder,
    this.totalOrderProcessing,
  });

  Shipper copyWith({
    String? id,
    String? name,
    String? type,
    String? code,
    String? phone,
    dynamic email,
    String? address,
    dynamic group,
    dynamic employeeId,
    String? paidBy,
    dynamic note,
    DateTime? createdAt,
    String? status,
    int? countOrders,
    int? totalShippingFee,
    double? currentDebt,
    int? totalAmountReconciled,
    int? totalAmountReconciling,
    int? totalAmountNotReconciled,
    int? totalReconciled,
    int? totalReconciling,
    int? totalNotReconciled,
    int? totalOrder,
    int? totalOrderProcessing,
  }) => Shipper(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    code: code ?? this.code,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    address: address ?? this.address,
    group: group ?? this.group,
    employeeId: employeeId ?? this.employeeId,
    paidBy: paidBy ?? this.paidBy,
    note: note ?? this.note,
    createdAt: createdAt ?? this.createdAt,
    status: status ?? this.status,
    countOrders: countOrders ?? this.countOrders,
    totalShippingFee: totalShippingFee ?? this.totalShippingFee,
    currentDebt: currentDebt ?? this.currentDebt,
    totalAmountReconciled: totalAmountReconciled ?? this.totalAmountReconciled,
    totalAmountReconciling:
        totalAmountReconciling ?? this.totalAmountReconciling,
    totalAmountNotReconciled:
        totalAmountNotReconciled ?? this.totalAmountNotReconciled,
    totalReconciled: totalReconciled ?? this.totalReconciled,
    totalReconciling: totalReconciling ?? this.totalReconciling,
    totalNotReconciled: totalNotReconciled ?? this.totalNotReconciled,
    totalOrder: totalOrder ?? this.totalOrder,
    totalOrderProcessing: totalOrderProcessing ?? this.totalOrderProcessing,
  );

  factory Shipper.fromMap(Map<String, dynamic> map) {
    return Shipper(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      code: map['code'] != null ? map['code'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      group: map['group'] as dynamic,
      employeeId: map['employeeId'] as dynamic,
      paidBy: map['paidBy'] as dynamic,
      note: map['note'] as dynamic,
      status: map['status'] as dynamic,
      countOrders: map['countOrders'] as dynamic,
      totalShippingFee: map['totalShippingFee'] as dynamic,
      currentDebt: map['currentDebt'] as dynamic,
      totalAmountReconciled: map['totalAmountReconciled'] as dynamic,
      totalAmountReconciling: map['totalAmountReconciling'] as dynamic,
      totalAmountNotReconciled: map['totalAmountNotReconciled'] as dynamic,
      totalReconciled: map['totalReconciled'] as dynamic,
      totalReconciling: map['totalReconciling'] as dynamic,
      totalNotReconciled: map['totalNotReconciled'] as dynamic,
      totalOrder: map['totalOrder'] as dynamic,
      totalOrderProcessing: map['totalOrderProcessing'] as dynamic,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : null,
    );
  }
}

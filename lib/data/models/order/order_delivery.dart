import 'package:zili_coffee/utils/helpers/parser.dart';
import '../address/address.dart';
import '../shipper/shipper.dart';

/// OrderDelivery Model - DTO cho orderDelivery trong response
///
/// Model này chứa thông tin giao hàng của đơn hàng
class OrderDelivery extends Address {
  final String? phoneNumber;
  final String? recipientName;
  final String? addressUserId;
  final DateTime? packingDate;
  final DateTime? dispatchDate;
  final DateTime? deliveryDate;
  final String? deliveryCode;
  final int deliveryFee;
  final String? shipperId;
  final Shipper? shipper;
  final String? deliveryOutsideCode;
  final String? paidBy;
  final String? requiredNote;
  final int cod;
  final int length;
  final int width;
  final int height;
  final int weight;
  final String? totalPrice;
  final String? totalItem;
  final String? serviceNameVi;
  final String? serviceNameEn;
  final String? deliveryGroupName;
  final String? deliveryStatus;

  OrderDelivery({
    super.id = '',
    super.status,
    super.address,
    super.province,
    super.provinceCode,
    super.district,
    super.districtCode,
    super.ward,
    super.wardCode,
    super.email,
    super.note,
    this.phoneNumber,
    this.recipientName,
    this.addressUserId,
    this.packingDate,
    this.dispatchDate,
    this.deliveryDate,
    this.deliveryCode,
    this.deliveryFee = 0,
    this.shipperId,
    this.deliveryOutsideCode,
    this.paidBy,
    this.requiredNote,
    this.cod = 0,
    this.length = 0,
    this.width = 0,
    this.height = 0,
    this.weight = 0,
    this.totalPrice,
    this.totalItem,
    this.serviceNameVi,
    this.serviceNameEn,
    this.deliveryGroupName,
    super.createdAt,
    super.name,
    super.phone,
    super.addressType,
    super.userId,
    this.deliveryStatus,
    this.shipper,
  });

  String? get addressDisplay {
    final result = [];
    if (address != null && address!.isNotEmpty) {
      result.add(address);
    }
    if (ward != null && ward!.isNotEmpty) {
      result.add(ward);
    }
    if (district != null && district!.isNotEmpty) {
      result.add(district);
    }
    if (province != null && province!.isNotEmpty) {
      result.add(province);
    }
    return result.join(', ');
  }

  factory OrderDelivery.fromMap(
    Map<String, dynamic> map,
    String? deliveryStatus,
  ) {
    return catchErrorOnParseModel(() {
      final address = Address.fromMap(map);
      return OrderDelivery(
        status: address.status,
        address: address.address,
        province: address.province,
        provinceCode: address.provinceCode,
        district: address.district,
        districtCode: address.districtCode,
        ward: address.ward,
        wardCode: address.wardCode,
        email: address.email,
        phone: address.phone,
        phoneNumber: map['phoneNumber']?.toString(),
        recipientName: map['recipientName']?.toString(),
        name: address.name,
        addressUserId: map['addressUserId']?.toString(),
        packingDate: map['packingDate'] != null
            ? DateTime.tryParse(map['packingDate'].toString())
            : null,
        dispatchDate: map['dispatchDate'] != null
            ? DateTime.tryParse(map['dispatchDate'].toString())
            : null,
        deliveryDate: map['deliveryDate'] != null
            ? DateTime.tryParse(map['deliveryDate'].toString())
            : null,
        deliveryCode: map['deliveryCode']?.toString(),
        deliveryFee: (map['deliveryFee'])?.toInt() ?? 0,
        shipperId: map['shipperId']?.toString(),
        shipper: map['shipper'] != null
            ? Shipper.fromMap(map['shipper'] as Map<String, dynamic>)
            : null,
        deliveryOutsideCode: map['deliveryOutsideCode']?.toString(),
        paidBy: map['paidBy']?.toString(),
        requiredNote: map['requiredNote']?.toString(),
        cod: (map['cod'])?.toInt() ?? 0,
        length: (map['length'])?.toInt() ?? 0,
        width: (map['width'])?.toInt() ?? 0,
        height: (map['height'])?.toInt() ?? 0,
        weight: (map['weight'])?.toInt() ?? 0,
        note: address.note,
        totalPrice: map['totalPrice']?.toString(),
        totalItem: map['totalItem']?.toString(),
        serviceNameVi: map['serviceNameVi']?.toString(),
        serviceNameEn: map['serviceNameEn']?.toString(),
        deliveryGroupName:
            ((map['deliveryGroupInfo']?['nameVi']) ??
                    (map['deliveryGroupInfo']?['nameEn']))
                ?.toString(),
        deliveryStatus: deliveryStatus,
        addressType: address.addressType,
        id: address.id,
        createdAt: address.createdAt,
        userId: address.userId,
      );
    }, map);
  }
}

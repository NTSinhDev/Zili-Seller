
import '../../data/models/address/address.dart';

/// Render customer address as a formatted string
/// Combines address, ward, district, and province separated by commas
///
/// Example:
/// ```dart
/// final address = Address(
///   address: '123 Đường ABC',
///   ward: 'Phường 1',
///   district: 'Quận 1',
///   province: 'TP. HCM',
/// );
/// final formatted = renderCustomerAddress(address);
/// // Result: "123 Đường ABC, Phường 1, Quận 1, TP. HCM"
/// ```
String renderCustomerAddress(Address? data) {
  if (data == null) return '';

  final addressArray = [data.address, data.ward, data.district, data.province];
  // Filter out null and empty strings, then join with ", "
  return addressArray
      .where((item) => item != null && item.toString().trim().isNotEmpty)
      .map((item) => item.toString().trim())
      .join(', ');
}

String renderRegionFromAddress(String? provinceName, String? districtName) {
  final validProvinceName = provinceName?.trim() ?? '';
  final validDistrictName = districtName?.trim() ?? '';
  if (validProvinceName.isEmpty && validDistrictName.isEmpty) return '';
  if (validProvinceName.isEmpty) return validDistrictName;
  if (validDistrictName.isEmpty) return validProvinceName;
  return '$validProvinceName - $validDistrictName';
}

String? renderAddressValueForSelector(Address? address) {
  if (address == null) return null;
  String? customerFullName = address.name ?? "";
  if (address.phone != null) {
    customerFullName += " - ${address.phone}";
  }
  customerFullName += ", ${address.fullAddress}";
  return customerFullName.isEmpty ? null : customerFullName;
}

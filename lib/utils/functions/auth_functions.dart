import '../../res/res.dart';
import '../../data/models/user/company.dart';
import '../enums/user_enum.dart';

enum EnterpriseAddressType { province, district, ward }

/// Render enterprise address based on type (province, district, ward)
///
/// Parameters:
/// - type: EnterpriseAddressType - "province", "district", or "ward"
/// - isLanguageVi: bool - true for Vietnamese, false for English
/// - company: Company? - Company object containing address information
///
/// Returns:
/// - String - Address string or "--" if not found
String renderEnterpriseAddress(EnterpriseAddressType type, Company? company) {
  if (company == null) {
    return AppConstant.strings.DEFAULT_EMPTY_VALUE;
  }

  String? address;

  switch (type) {
    case EnterpriseAddressType.province:
      if (company.province != null && company.province!.isNotEmpty) {
        address = company.province;
      } else {
        final objectProvince = company.objectProvince;
        if (objectProvince != null) {
          address =
              objectProvince['full_name']?.toString() ??
              objectProvince['full_name_en']?.toString();
        }
      }
      break;
    case EnterpriseAddressType.district:
      if (company.district != null && company.district!.isNotEmpty) {
        address = company.district;
      } else {
        final objectDistrict = company.objectDistrict;
        if (objectDistrict != null) {
          address =
              objectDistrict['full_name']?.toString() ??
              objectDistrict['full_name_en']?.toString();
        }
      }
      break;
    case EnterpriseAddressType.ward:
      if (company.ward != null && company.ward!.isNotEmpty) {
        address = company.ward;
      } else {
        final objectWard = company.objectWard;
        if (objectWard != null) {
          address =
              objectWard['full_name']?.toString() ??
              objectWard['full_name_en']?.toString();
        }
      }
      break;
  }

  return address ?? AppConstant.strings.DEFAULT_EMPTY_VALUE;
}

String? renderUserPosition(PositionType? position) {
  if (position == null) {
    return null;
  }
  switch (position) {
    case PositionType.employee:
      return "Nhân viên";
    case PositionType.businessOwner:
      return "Chủ doanh nghiệp";
  }
}

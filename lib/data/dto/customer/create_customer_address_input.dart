import '../../../utils/enums.dart';
import '../../../utils/enums/address_enum.dart';
import '../../models/address/address.dart';
import '../../models/address/region.dart';

class CustomerAddressData {
  String? customerId;
  String? name;
  String? phone;
  String? email;
  String? faxCode;
  String? specificAddress;
  CustomerAddressData({
    this.customerId,
    this.name,
    this.phone,
    this.email,
    this.faxCode,
    this.specificAddress,
  });
}

class CustomerAddressInputDTO {
  CustomerAddressData? customer;
  Address? address;
  Region? region;
  Region? subRegion;
  bool useNewAddress;
  CustomerAddressInputDTO({
    this.customer,
    this.address,
    this.region,
    this.subRegion,
    this.useNewAddress = true,
  });

  RegionType get regionType => useNewAddress ? .postMerger : .preMerger;

  Region? get regionByType {
    if (region?.type == regionType.toConstant) {
      return region;
    }
    return null;
  }

  Region? get subRegionByType {
    if (subRegion?.type == regionType.toConstant) {
      return subRegion;
    }
    return null;
  }

  String? get provinceCode {
    if (regionType == .postMerger) {
      return region?.code;
    } else {
      return region?.province?.code;
    }
  }

  String? get districtCode {
    if (regionType == .postMerger) {
      return null;
    } else {
      return region?.code;
    }
  }

  String? get wardCode => subRegion?.code;

  // Check required fields
  bool validate(CRUDType actionType) {
    if (actionType == CRUDType.update) {
      if ((customer?.customerId ?? "").isEmpty) {
        return false;
      }
      if ((address?.id ?? "").isEmpty) {
        return false;
      }
    }
    if ((provinceCode ?? "").isEmpty) {
      return false;
    }
    if ((wardCode ?? "").isEmpty) {
      return false;
    }
    return true;
  }

  // Address toCustomerAddress() {

  // }
}

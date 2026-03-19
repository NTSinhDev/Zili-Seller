import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:zili_coffee/bloc/base_cubit.dart';
import 'package:zili_coffee/data/middlewares/address_middleware.dart';
import 'package:zili_coffee/data/models/address/customer_address.dart';
import 'package:zili_coffee/data/models/address/location.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/data/repositories/address_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/utils/enums/address_enum.dart';

import '../../data/models/address/region.dart';
part 'address_state.dart';

class AddressCubit extends BaseCubit<AddressState> {
  AddressCubit() : super(AddressInitial());

  final _addressRepo = di<AddressRepository>();
  final _addressMid = di<AddressMiddleware>();

  Future searchAddress({required String keySearch}) async {
    List<Location> result = [];
    for (var province in _addressRepo.provincesOrigin) {
      if (province.name.toLowerCase().contains(keySearch.toLowerCase())) {
        result.add(province);
      }
    }
    _addressRepo.setDataProvincesStream(result);
  }

  Future getAllAddress() async {
    emit(GettingAddressState());
    final result = await _addressMid.getAddresses();
    if (result is ResponseSuccessState<List<CustomerAddress>>) {
      _addressRepo.addresses.sink.add(result.responseData);
      // set address for checkout screen
      for (CustomerAddress address in result.responseData) {
        if (address.isDefaultAddress) {
          _addressRepo.addressPayment.sink.add(address);
        }
      }
      emit(GotAddressState());
    } else if (result is ResponseFailedState) {
      _addressRepo.addresses.sink.add([]);
      emit(GotFailedAddressState(error: result));
    }
  }

  Future createAddress({required CustomerAddress address}) async {
    emit(const CreatingAddressState(label: 'Đang tạo địa chỉ...'));
    final result = await _addressMid.createAddress(address);
    if (result is ResponseSuccessState<CustomerAddress>) {
      emit(CreatedAddressState(address: result.responseData));
    } else if (result is ResponseFailedState) {
      emit(CreatedFailedAddressState(error: result));
    }
  }

  Future updateAddress({required CustomerAddress address}) async {
    emit(const CreatingAddressState(label: 'Đang cập nhật địa chỉ...'));
    final result = await _addressMid.updateAddress(address);
    if (result is ResponseSuccessState<CustomerAddress>) {
      emit(CreatedAddressState(address: result.responseData));
    } else if (result is ResponseFailedState) {
      emit(CreatedFailedAddressState(error: result));
    }
  }

  Future deleteAddress({required CustomerAddress address}) async {
    emit(const CreatingAddressState(label: 'Xóa địa chỉ...'));
    final result = await _addressMid.deleteAddress(address);
    if (result is ResponseSuccessState<bool>) {
      emit(const CreatedAddressState());
      if (result.responseData) {
        await getAllAddress();
      } else {
        emit(DeletedFailedAddressState());
      }
    } else if (result is ResponseFailedState) {
      emit(CreatedFailedAddressState(error: result));
    }
  }

  Future getProvinces() async {
    final result = await _addressMid.getProvinces();
    if (result is ResponseSuccessState<List<Location>>) {
      _addressRepo.setDataProvincesStream(result.responseData);
      _addressRepo.provincesOrigin = result.responseData;
    } else if (result is ResponseFailedState) {
      throw Exception("lỗi!");
    }
  }

  Future getDistricts(Location province) async {
    final result = await _addressMid.getDistricts(province.id);
    if (result is ResponseSuccessState<List<Location>>) {
      _addressRepo.setDataDistrictsStream(result.responseData);
    } else if (result is ResponseFailedState) {
      throw Exception("lỗi!");
    }
  }

  Future getWards(Location district) async {
    final result = await _addressMid.getWards(district.id);
    if (result is ResponseSuccessState<List<Location>>) {
      _addressRepo.setDataWardsStream(result.responseData);
    } else if (result is ResponseFailedState) {
      throw Exception("lỗi!");
    }
  }

  /// Filter districts by type (PRE_MERGER or POST_MERGER)
  /// Nếu type là postMerger thì sử dụng API getProvincesByType
  /// Nếu type là preMerger thì sử dụng API filterDistrictsByType
  ///
  /// Parameters:
  /// - type: RegionType enum (preMerger or postMerger)
  Future filterDistrictsByType(RegionType type) async {
    emit(GettingAddressState());

    ResponseState result;
    if (type == RegionType.postMerger) {
      // POST_MERGER: Sử dụng API getProvincesByType
      result = await _addressMid.getProvincesByType(type: type);
    } else {
      // PRE_MERGER: Sử dụng API filterDistrictsByType
      result = await _addressMid.filterDistrictsByType(type: type);
    }

    if (result is ResponseSuccessState<List<Region>>) {
      // Lưu vào đúng stream dựa trên type
      if (type == RegionType.postMerger) {
        _addressRepo.postMergerProvinceDistrictList.sink.add(
          result.responseData,
        );
      } else {
        _addressRepo.preMergerProvinceDistrictList.sink.add(
          result.responseData,
        );
      }
      emit(GotAddressState());
    } else if (result is ResponseFailedState) {
      emit(GotFailedAddressState(error: result));
    }
  }

  /// Get wards by district code and type (PRE_MERGER or POST_MERGER)
  ///
  /// Parameters:
  /// - districtCode: Mã quận/huyện (required)
  /// - type: RegionType enum (preMerger or postMerger)
  Future getWardsByType({
    required String districtCode,
    required RegionType type,
  }) async {
    emit(GettingAddressState());
    final result = await _addressMid.getRegionWardsByType(
      districtCode: districtCode,
      type: type,
    );
    if (result is ResponseSuccessState<List<Region>>) {
      _addressRepo.wardsList.sink.add(result.responseData);
      emit(GotAddressState());
    } else if (result is ResponseFailedState) {
      emit(GotFailedAddressState(error: result));
    }
  }
}

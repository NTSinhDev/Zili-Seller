import 'dart:io';

import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:zili_coffee/data/repositories/setting_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/utils/app_logger.dart';

import '../data/entity/printer.dart';
import '../data/entity/system/reason.dart';
import '../data/middlewares/middlewares.dart';
import '../data/models/order/payment_detail/bank_info.dart';
import '../data/models/product/product_variant.dart';
import '../data/models/template_mail_data.dart';
import '../data/models/warehouse/warehouse.dart';
import '../data/network/network_response_state.dart';
import '../data/repositories/order_repository.dart';
import '../data/repositories/payment_repository.dart';
import '../data/repositories/product_repository.dart';
import '../data/repositories/warehouse_repository.dart';
import '../utils/helpers/crash_logger.dart';

/// Lớp này dùng để tải các thông tin tài nguyên chung cho các module
/// từ server hoặc local storage (thường là các phương thức GET). Sau khi
/// tải, dữ liệu được đưa vào repository tương ứng để lưu và tránh
/// phải tải lại nhiều lần khi không cần thiết.
class CommonService {
  final WarehouseRepository _warehouseRepository = di<WarehouseRepository>();
  final ProductRepository _prodRepository = di<ProductRepository>();
  final OrderRepository _orderRepository = di<OrderRepository>();
  final PaymentRepository _paymentRepository = di<PaymentRepository>();
  final SettingRepository _settingRepository = di<SettingRepository>();

  final WarehouseMiddleware _warehouseMiddleware = di<WarehouseMiddleware>();
  final ProductMiddleware _productMiddleware = di<ProductMiddleware>();
  final CompanyMiddleware _companyMiddleware = di<CompanyMiddleware>();
  final PaymentMiddleware _paymentMiddleware = di<PaymentMiddleware>();
  final ReasonMiddleware _reasonMiddleware = di<ReasonMiddleware>();
  final SettingMiddleware _settingMiddleware = di<SettingMiddleware>();

  Future<List<Warehouse>> loadWarehousesData({
    int limit = 100,
    int offset = 0,
  }) async {
    final result = await _warehouseMiddleware.getSellerWarehouses(
      limit: limit,
      offset: offset,
    );

    if (result is ResponseSuccessState<List<Warehouse>>) {
      final warehouses = result.responseData;
      if (warehouses.isNotEmpty) {
        _orderRepository.setWarehouses(warehouses);
        _warehouseRepository.warehouseSubject.sink.add(warehouses);
      }
      return warehouses;
    }

    return [];
  }

  Future<void> getGreenBeanDefault(String id) async {
    final result = await _productMiddleware.getGreenBeanDefault(id: id);
    if (result is ResponseSuccessState<ProductVariant>) {
      _prodRepository.greenBeanDefault.sink.add(result.responseData);
    }
  }

  Future<(String, String)?> getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final appVersion = packageInfo.version;
      final buildNumber = packageInfo.buildNumber;
      return (appVersion, buildNumber);
    } catch (e) {
      CrashLogger.tryToRecordError(
        'Không thể lấy thông tin app từ "package_info_plus"',
        error: e,
        stackTrace: .current,
      );
      return null;
    }
  }

  Future<List<Warehouse>> loadWarehousesDataV2({
    int limit = 100,
    int offset = 0,
  }) async {
    if (_warehouseRepository.warehousesHasValue) {
      return _warehouseRepository.warehouses;
    }
    final result = await _warehouseMiddleware.getSellerWarehouses(
      limit: limit,
      offset: offset,
    );

    if (result is ResponseSuccessState<List<Warehouse>>) {
      final warehouses = result.responseData;
      if (warehouses.isNotEmpty) {
        _warehouseRepository.warehouseSubject.sink.add(warehouses);
      }
      return warehouses;
    }

    return [];
  }

  Future<List<TemplateMailData>> getActiveQuoteTemplateMails() async {
    final result = await _companyMiddleware.getActiveTemplateMails(
      'QUOTATION_ORDER',
    );
    if (result is ResponseSuccessListState<List<TemplateMailData>>) {
      _orderRepository.templateMails.sink.add(result.responseData);
      return result.responseData;
    }
    return [];
  }

  Future<List<BankInfo>> getActiveBankingMethods() async {
    final result = await _paymentMiddleware.getBankingMethods();
    if (result is ResponseSuccessState<List<BankInfo>>) {
      _paymentRepository.bankingMethods.sink.add(result.responseData);
      return result.responseData;
    }
    return [];
  }

  Future<List<ReasonEntity>> getRejectedQuoteReasons() async {
    final result = await _reasonMiddleware.getReasons(type: "REJECT_QUOTE");
    if (result is ResponseSuccessState<List<ReasonEntity>>) {
      final list = result.responseData;
      list.sort((a, b) => a.position.compareTo(b.position));
      _settingRepository.reasons.sink.add(list);
      return list;
    }
    return [];
  }

  Future<bool> sendQuotationByMail(String code) async {
    final result = await _companyMiddleware.sendQuotationByMail(code);
    if (result is ResponseSuccessState<bool>) {
      return result.responseData;
    }
    return false;
  }

  Future<bool?> requestPrintFile({
    required File file,
    required Printer printer,
  }) async {
    try {
      final dio = Dio();
      final fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
        ...printer.configRequest,
      });

      final response = await dio.post(
        printer.apiUrl,
        data: formData,
        options: Options(
          contentType: "multipart/form-data",
          sendTimeout: const Duration(seconds: 300000),
          receiveTimeout: const Duration(seconds: 300000),
        ),
      );
      AppLogger.d("send", extra: {1: response.data["status"]});
      if (response.data["status"] == 1) {
        return true;
      }
      return false;
    } catch (e) {
      CrashLogger.tryToRecordError(
        'Không thể in tài liệu bằng server local',
        error: e,
        stackTrace: .current,
      );
      return null;
    }
  }
}

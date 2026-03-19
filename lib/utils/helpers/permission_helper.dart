import 'package:zili_coffee/data/repositories/auth_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';

class AbilityAction {
  static const view = 'view';
  static const manage = 'manage';
  static const create = 'create';
  static const edit = 'edit';
  static const remove = 'remove';
  static const importData = 'import';
  static const exportData = 'export';
}

class AbilitySubject {
  static const all = 'all';
  static const dashboard = 'dashboard';
  static const auth = 'auth';

  // Sản phẩm
  static const products = 'products';
  static const categoryManagement = 'category_management';
  static const productManagement = 'product_management';
  static const productRating = 'product_rating';

  // Kho
  static const warehouses = 'warehouses';
  static const orders = 'orders';
  static const warehouseManagement = 'warehouse_management';
  static const supplierGroup = 'supplier_group';
  static const supplier = 'supplier';
  static const purchaseOrderManagement = 'purchase_order_management';
  static const inspectionFormManagement = 'inspection_form_management';
  static const orderManagement = 'order_management';
  static const quotationManagement = 'quotation_management';
  static const greenBeanManagement = 'green_bean_management';
  static const roastingSlipManagement = 'roasting_slip_management';
  static const brandManagement = 'brand_management';
  static const roastedBeanManagement = 'roasted_bean_management';
  static const packagingManagement = 'packaging_management';  

  // Đơn hàng
  static const orderExchangeReturnManagement =
      'order_exchange_return_management';

  // Vận chuyển
  static const delivery = 'delivery';
  static const orderShipment = 'order_shipment';
  static const connectShippingPartners = 'connect_shipping_partners';
  static const reconciliationVouchers = 'reconciliation_vouchers';
  static const deliveryConfiguration = 'delivery_configuration';

  // Khách hàng
  static const customers = 'customers';
  static const customerGroupManagement = 'customer_group_management';
  static const customerManagement = 'customer_management';

  // Cộng tác viên
  static const affiliates = 'affiliates';
  static const affiliateOverview = 'affiliate_overview';
  static const affiliateApprovePartner = 'affiliate_approve_partner';

  // Sổ quỹ
  static const cashBooks = 'cash_books';
  static const receiptVoucherType = 'receipt_voucher_type';
  static const receiptVoucher = 'receipt_voucher';
  static const paymentVoucherType = 'payment_voucher_type';
  static const paymentVoucher = 'payment_voucher';
  static const cashBooksReport = 'cash_books_report';

  // Sales
  static const salesManagement = 'sales_management';
  static const planManagement = 'plan_management';
  static const targetManagement = 'target_management';

  // Cấu hình
  static const configuration = 'configuration';
  static const branchManagement = 'branch_management';
  static const shopSetting = 'shop_setting';
  static const paymentMethodSetting = 'payment_method_setting';
  static const termsSetting = 'terms_setting';
  static const reasonSetting = 'reason_setting';
}

class PermissionHelper {
  static bool can(String action, String subject) {
    return di<AuthRepository>().can(action, subject);
  }

  static bool view(String subject) => can(AbilityAction.view, subject);
  static bool manage(String subject) => can(AbilityAction.manage, subject);
  static bool create(String subject) => can(AbilityAction.create, subject);
  static bool edit(String subject) => can(AbilityAction.edit, subject);
  static bool remove(String subject) => can(AbilityAction.remove, subject);
  static bool import(String subject) => can(AbilityAction.importData, subject);
  static bool export(String subject) => can(AbilityAction.exportData, subject);

  static bool hasSellerPermission(String name) {
    return di<AuthRepository>().hasSellerPermission(name);
  }
}

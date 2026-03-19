import 'package:rxdart/rxdart.dart';
import 'package:video_player/video_player.dart';
import 'package:zili_coffee/data/models/product/product_variant.dart';
import 'package:zili_coffee/data/models/product/product.dart';
import 'package:zili_coffee/data/models/product/company_product.dart';
import 'package:zili_coffee/data/models/product/product_warehouse_inventory.dart';
import 'package:zili_coffee/data/repositories/base_repository.dart';

import '../models/product/purchase_order_product.dart';

class ProductRepository extends BaseRepository {
  final BehaviorSubject<bool> actionType = BehaviorSubject<bool>();

  // Old code ----------------------------------------------------------------
  // *************************************************************************
  // Detail product screen
  final BehaviorSubject<Product?> productDetailStreamData = BehaviorSubject();
  final behaviorProductDetailVideo = BehaviorSubject<VideoPlayerController?>();
  final BehaviorSubject<ProductVariant> variantStreamData = BehaviorSubject();
  final BehaviorSubject<List<String?>> optionsStreamData = BehaviorSubject();
  final BehaviorSubject<PurchaseOrderProductsResult>
  purchaseOrderProductSubject = BehaviorSubject();
  void setVariantStreamData() {
    final variantToCheck = productDetailStreamData.value!.detail!.productOptions
        .toProductVariant();
    for (var variant in productDetailStreamData.value!.detail!.variants) {
      if (variant == variantToCheck) {
        variantStreamData.sink.add(variant);
      }
    }
  }

  final BehaviorSubject<ProductVariant?> greenBeanDefault = BehaviorSubject();
  final BehaviorSubject<List<ProductVariant>> materialVariants =
      BehaviorSubject();
  final BehaviorSubject<List<ProductVariant>> packageVariants =
      BehaviorSubject();
  void appendPurchaseOrderProducts(PurchaseOrderProductsResult data) {
    final items = data.items;
    final total = data.total;
    final current = purchaseOrderProductSubject.valueOrNull?.items ?? [];
    purchaseOrderProductSubject.sink.add(
      PurchaseOrderProductsResult(items: [...current, ...items], total: total),
    );
  }

  void setProductStreamData(Product prod) {
    productDetailStreamData.sink.add(prod);
    behaviorProductDetailVideo.sink.add(null);
  }

  Future<void> destroyStreamMemory() async {
    await productDetailStreamData.drain();
    await productDetailStreamData.close();
  }

  // Products screen
  final productsScreenStreamData = BehaviorSubject<Map<String, dynamic>>();

  final behaviorFilterProducts = BehaviorSubject<List<Product>>();
  final BehaviorSubject<int> behaviorFilterTotalRecord = BehaviorSubject<int>();

  List<Product> featuredProducts = [];

  // Products
  final BehaviorSubject<List<ProductVariant>> productsSubject =
      BehaviorSubject();
  int totalProducts = 0;

  // Products by company
  final BehaviorSubject<CompanyProduct?> companyProductDetailStreamData =
      BehaviorSubject();
  final BehaviorSubject<List<CompanyProduct>> productsByCompanySubject =
      BehaviorSubject();
  Stream<List<CompanyProduct>> get companyProductsStream =>
      productsByCompanySubject.stream;
  int totalCompanyProducts = 0;

  void setProductsByCompany(List<CompanyProduct> data, int total) {
    productsByCompanySubject.sink.add(data);
    totalCompanyProducts = total;
  }

  void appendProductsByCompany(List<CompanyProduct> data, int total) {
    final current = productsByCompanySubject.valueOrNull ?? [];
    productsByCompanySubject.sink.add([...current, ...data]);
    totalCompanyProducts = total;
  }

  // Product warehouse inventory
  final BehaviorSubject<ProductWarehouseInventoryResult?>
  productWarehouseInventorySubject = BehaviorSubject();
  Stream<ProductWarehouseInventoryResult?>
  get productWarehouseInventoryStream =>
      productWarehouseInventorySubject.stream;

  void setProductWarehouseInventory(ProductWarehouseInventoryResult data) {
    productWarehouseInventorySubject.sink.add(data);
  }

  void clearProductWarehouseInventory() {
    productWarehouseInventorySubject.sink.add(null);
  }

  @override
  Future<void> clean() async {}
}

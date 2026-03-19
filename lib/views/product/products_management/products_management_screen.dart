import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/data/repositories/product_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/int.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/views/product/modules/search_bar.dart' as module;
part 'components/product_item.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  State<ProductManagementScreen> createState() =>
      _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightGrey.withOpacity(0.6),
      child: Column(
        children: [
          height(height: 24),
          const module.SearchBar(),
          _ProductItem(
            onTap: () {},
            onLongPress: () {},
          ),
          _ProductItem(
            onTap: () {},
            onLongPress: () {},
          ),
          _ProductItem(
            onTap: () {},
            onLongPress: () {},
          ),
          _ProductItem(
            onTap: () {},
            onLongPress: () {},
          ),
          _ProductItem(
            onTap: () {},
            onLongPress: () {},
          ),
          _ProductItem(
            onTap: () {},
            onLongPress: () {},
          ),
          _ProductItem(
            onTap: () {},
            onLongPress: () {},
          ),
          height(height: 20.h),
        ],
      ),
    );
  }
}

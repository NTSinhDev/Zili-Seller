import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:zili_coffee/bloc/review/review_cubit.dart';
import 'package:zili_coffee/data/models/media_file.dart';
import 'package:zili_coffee/data/models/product/product.dart';
import 'package:zili_coffee/data/models/product/product_detail.dart';
import 'package:zili_coffee/data/models/product/product_variant.dart';
import 'package:zili_coffee/data/models/review/rating.dart';
import 'package:zili_coffee/data/models/review/review.dart';
import 'package:zili_coffee/data/repositories/product_repository.dart';
import 'package:zili_coffee/data/repositories/review_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/enums.dart';
// import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/utils/extension/int.dart';
import 'package:zili_coffee/utils/extension/string.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/views/module_common/options.dart';
// import 'package:zili_coffee/views/review/review_details/review_details_screen.dart';
// import 'package:zili_coffee/views/review/store_reviews/store_reviews_screen.dart';
part 'components/product_medias.dart';
part 'components/product_information.dart';
part 'components/product_rating.dart';
part 'components/add_to_cart.dart';
part 'components/top_reviewer.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});
  static String keyName = '/product-detail';

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductRepository productRepository = di<ProductRepository>();
  final ReviewCubit reviewCubit = di<ReviewCubit>();
  final ReviewRepository reviewRepository = di<ReviewRepository>();
  @override
  void initState() {
    super.initState();
    if (reviewRepository.currentProduct != null) {
      reviewCubit.getProductRatingReviews();
    }
  }

  @override
  void dispose() {
    reviewRepository.behaviorRating.sink.add(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.lightAppBar(
        context,
        label: 'CHI TIẾT SẢN PHẨM',
        actions: [
          OpenCartView(
            color: AppColors.black,
            padding: EdgeInsets.fromLTRB(0, 16.h, 10.w, 16.h),
          )
        ],
        // outstandingAction: true,
      ),
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          SizedBox(
            width: Spaces.screenWidth(context),
            height: Spaces.screenHeight(context),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const _ProductMedias(),
                  const _ProductInformation(),
                  const _ProductRating(),
                  height(height: 166),
                ],
              ),
            ),
          ),
          const _AddToCart(),
        ],
      ),
    );
  }
}

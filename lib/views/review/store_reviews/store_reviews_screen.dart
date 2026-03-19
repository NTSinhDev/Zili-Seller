import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zili_coffee/data/models/media_file.dart';
import 'package:zili_coffee/data/models/review/rating.dart';
import 'package:zili_coffee/data/models/review/review.dart';
import 'package:zili_coffee/data/repositories/review_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/enums.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/utils/extension/date_time.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/views/module_common/avatar.dart';
import 'package:zili_coffee/views/review/review_details/review_details_screen.dart';
part 'components/store_rating.dart';
part 'components/tool_bar_review.dart';
part 'components/review_item.dart';
part 'components/listview_loading.dart';
part 'components/placeholder_review_item.dart';
part 'components/media_container.dart';

final List<String> _toolBar = [
  "Tất cả",
  "5 sao",
  "4 sao",
  "3 sao",
  "2 sao",
  "1 sao"
];

class StoreReviewsScreen extends StatelessWidget {
  const StoreReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ReviewRepository reviewRepository = di<ReviewRepository>();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: ThemeApp.systemLight, // set text-color statusbar
      child: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification) {
              _onEndScroll(scrollNotification.metrics);
            }
            return true;
          },
          child: RefreshIndicator(
            onRefresh: () async {
              // setState(() => onRefreshing = true);
              // reviewRepository.behaviorReviews.sink.add([]);
              // _getReviews(isLoadMore: false).then((_) {
              //   if (mounted) {
              //     setState(() => onRefreshing = false);
              //   }
              // });
            },
            color: AppColors.primary,
            child: Scrollbar(
              radius: Radius.circular(4.r),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    pinned: true,
                    backgroundColor: AppColors.white,
                    expandedHeight: 240.h,
                    toolbarHeight: 0,
                    elevation: 1,
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(60.h),
                      child: const _ToolBarReview(),
                    ),
                    flexibleSpace: const FlexibleSpaceBar(
                      background: _StoreRating(),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 8.h),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (index == Rating.rating.reviews.length) {
                          return _ListViewLoading(
                            reviewRepository: reviewRepository,
                            reviews: Rating.rating.reviews,
                          );
                        }
                        return _ReviewItem(Rating.rating.reviews[index]);
                      },
                      separatorBuilder: (context, index) => _separatorWidget(),
                      itemCount: Rating.rating.reviews.length + 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onEndScroll(ScrollMetrics metrics) async {
    if (metrics.pixels == metrics.maxScrollExtent) {
      // if (reviewRepository.behaviorRating.hasValue) {
      //   final rating = reviewRepository.behaviorRating.value;
      //   final reviews = reviewRepository.behaviorReviews.value;
      //   if ((rating?.totalRecords ?? 0) == reviews.length) return;
      // }
      // if (onLoadMore) return;
      // setState(() => onLoadMore = true);
      _getReviews(isLoadMore: true).then((_) {
        // if (mounted) {
        //   setState(() => onLoadMore = false);
        // }
      });
    }
  }

  Future<void> _getReviews({required bool isLoadMore}) async {
    // MediaType? type;
    // final dataType = reviewRepository.filterByTypeStreamData.valueOrNull;
    // if (dataType == _defaultReviewFilter[1]) {
    //   type = MediaType.image;
    // } else if (dataType == _defaultReviewFilter[2]) {
    //   type = MediaType.video;
    // }

    // int star = 0;
    // final index = _defaultStars.indexOf(
    //   reviewRepository.filterByStarStreamData.valueOrNull ?? '',
    // );
    // if (index != -1) {
    //   star = index + 1;
    // }

    // await di<ReviewCubit>().filterReviews(
    //   paging: isLoadMore,
    //   type: type,
    //   star: star,
    // );
  }

  Widget _separatorWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      margin: EdgeInsets.only(left: 75.w, right: 20.w),
      child: Divider(color: AppColors.lightGrey, height: 1.h, thickness: 1.1),
    );
  }
}

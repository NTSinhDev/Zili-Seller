part of '../products_screen.dart';

class _FilterView extends StatelessWidget {
  final Function() callBack;
  const _FilterView({required this.callBack});

  @override
  Widget build(BuildContext context) {
    final CategoryCubit cubit = di<CategoryCubit>()..getAllCategories();
    final CategoryRepository categoryRepository = di<CategoryRepository>();
    return BlocListener<CategoryCubit, CategoryState>(
      bloc: cubit,
      listener: (context, state) {
        if (state is GettingProductsState) {
          context.showLoading(message: "Lọc sản phẩm");
        } else if (state is GotProductsState) {
          context
            ..hideLoading()
            ..navigator.pop();
        } else if (state is FailedGetProductsState) {
          context
            ..hideLoading()
            ..showNotificationDialog(
              message: "Mất kết nối",
              cancelWidget: Container(),
              action: "Đóng",
            );
        }
      },
      child: Drawer(
        backgroundColor: AppColors.white,
        child: SizedBox(
          height: Spaces.screenHeight(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: Spaces.screenWidth(context),
                padding: EdgeInsets.only(left: 72.w, top: 52.h, bottom: 28.4.h),
                color: AppColors.primary,
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 8.h),
                      child: Text(
                        'Sắp xếp'.toUpperCase(),
                        style: AppStyles.text.semiBold(
                          fSize: 18.sp,
                          color: AppColors.lightGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              height(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  width(width: 20.w),
                  Text(
                    'Các dòng cà phê',
                    style: AppStyles.text.semiBold(fSize: 16.sp),
                  ),
                ],
              ),
              height(height: 10),
              Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: StreamBuilder<List<Category>>(
                    stream: categoryRepository.categories.stream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Wrap(
                          runSpacing: 8.w,
                          spacing: 15.w,
                          children: List.generate(
                            8,
                            (index) =>
                                PlaceholderWidget(width: 121.w, height: 31.h),
                          ),
                        );
                      }
                      return Wrap(
                        runSpacing: 8.w,
                        spacing: 15.w,
                        children: snapshot.data!
                            .map((category) => TagWidget(
                                  label: category.name,
                                  isActive:
                                      isActive(categoryRepository, category),
                                  onTap: () => onSeletedCategory(
                                    categoryRepository,
                                    category,
                                  ),
                                ))
                            .toList(),
                      );
                    }),
              ),
              height(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Divider(
                  color: AppColors.grayEA,
                  thickness: 1,
                  height: 1.h,
                ),
              ),
              height(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  width(width: 20.w),
                  Text(
                    'Giá sản phẩm',
                    style: AppStyles.text.semiBold(fSize: 16.sp),
                  ),
                ],
              ),
              height(height: 18),
              // const PriceRangeSlider(),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  width(width: 20.w),
                  Expanded(
                    child: CustomButtonWidget(
                      onTap: () async {
                        await cubit.getProducts();
                        callBack();
                      },
                      radius: 5,
                      label: 'Áp dụng ngay',
                    ),
                  ),
                  width(width: 20.w),
                ],
              ),
              height(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  bool isActive(CategoryRepository categoryRepository, Category category) {
    if (!categoryRepository.behaviorSelected.hasValue) return false;
    final categories = categoryRepository.behaviorSelected.value;
    final isActive =
        categories.where((element) => element.id == category.id).toList();
    return isActive.isNotEmpty;
  }

  void onSeletedCategory(CategoryRepository repository, Category category) {
    final BehaviorSubject<List<Category>> streamData =
        repository.behaviorSelected;
    List<Category> categories = [];
    if (streamData.hasValue) {
      categories = streamData.value;
      final isDuplicate =
          categories.where((element) => element.id == category.id).toList();
      if (isDuplicate.isEmpty) {
        categories.add(category);
      } else {
        categories.remove(category);
      }
    } else {
      categories.add(category);
    }
    repository.behaviorSelected.sink.add(categories);
  }
}

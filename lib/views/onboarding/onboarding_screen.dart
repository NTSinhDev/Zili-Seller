import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/views/home/home_screen.dart';
part 'background.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Brightness themeMode = MediaQuery.of(context).platformBrightness;
    return _Background(
      themeMode: themeMode,
      child: SizedBox(
        width: Spaces.screenWidth(context),
        height: Spaces.screenHeight(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            height(height: 197),
            SvgPicture.asset(
              AppConstant.svgs.logoApp,
              width: 154.w,
              height: 84.h,
              fit: BoxFit.fill,
              colorFilter: themeMode == Brightness.dark
                  ? const ColorFilter.mode(
                      AppColors.white,
                      BlendMode.srcIn,
                    )
                  : null,
            ),
            height(height: 49.15),
            width(
              width: 200.w,
              child: Text(
                "Câu chuyện này là của chúng tôi",
                style: AppStyles.text.passionsConflict(
                  fSize: 43.sp,
                  height: 0.785,
                  color: themeMode == Brightness.dark ? AppColors.white : null,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            height(height: 19),
            width(
              width: 350.w,
              child: Text(
                "Zili Coffee là hành trình đi tìm kiếm hương vị tuyệt hảo của hạt cà phê từ những nguyên liệu tốt nhất. Đây không đơn thuần là kết quả của công nghệ tiên tiến hiện đại mà còn là sự pha trộn hoàn hảo giữa tình yêu và đam mê của người nông dân vùng cao nguyên Lâm Viên - Di Linh trên con đường tìm kiếm và tạo ra tách cà phê Zili thực sự thơm ngon",
                style: AppStyles.text.medium(
                  fSize: 12.sp,
                  height: 1.435,
                  color: themeMode == Brightness.dark ? AppColors.white :AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            height(height: 123),
            InkWell(
              onTap: () {
                context.navigator.push(
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                child: Text(
                  "Bỏ qua",
                  style: AppStyles.text
                      .semiBold(
                        fSize: 16.sp,
                        color:themeMode == Brightness.dark ? AppColors.white : AppColors.primary,
                        height: 0.785,
                      )
                      .copyWith(decoration: TextDecoration.underline),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:zili_coffee/res/res.dart';

import '../../utils/extension/extension.dart';

/// Màn hình xem trước ảnh mẫu.
///
/// Hiển thị full-screen với khả năng zoom/pan (photo_view).
/// Dùng khi user nhấn "Xem mẫu" ở mục chọn loại báo giá.
///
/// [imageUrl] được trim và load qua CachedNetworkImage với User-Agent header
/// để tránh bị chặn bởi CDN/sever.
class PreviewImageUrlScreen extends StatelessWidget {
  const PreviewImageUrlScreen({
    super.key,
    required this.imageUrl,
    this.title = 'Xem mẫu',
  });

  /// URL ảnh mẫu (bắt buộc, đã kiểm tra null/empty trước khi mở màn hình).
  final String imageUrl;

  /// Tiêu đề hiển thị trên AppBar.
  final String title;

  /// Headers gửi kèm request tải ảnh. Một số CDN chặn request thiếu User-Agent.
  static const Map<String, String> _httpHeaders = {
    'User-Agent':
        'Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36',
  };

  static void open(
    BuildContext context, {
    required String title,
    required String imageUrl,
  }) {
    context.navigator.push(
      MaterialPageRoute<void>(
        builder: (_) => PreviewImageUrlScreen(imageUrl: imageUrl, title: title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final url = imageUrl.trim();
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black.withValues(alpha: 0.7),
        elevation: 0,
        title: Text(
          title,
          style: AppStyles.text.semiBold(fSize: 16.sp, color: AppColors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.close, color: AppColors.white, size: 24.r),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: PhotoView.customChild(
        child: SizedBox.expand(
          child: CachedNetworkImage(
            imageUrl: url,
            httpHeaders: _httpHeaders,
            fit: BoxFit.contain,
            placeholder: (_, __) => const Center(
              child: CircularProgressIndicator(color: AppColors.white),
            ),
            errorWidget: (_, __, ___) => _buildErrorView(),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    debugPrint('TemplateMailPreviewScreen failed to load: ${imageUrl.trim()}');
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image_outlined,
              size: 64.r,
              color: AppColors.white.withValues(alpha: 0.54),
            ),
            SizedBox(height: 16.h),
            Text(
              'Không thể tải ảnh mẫu',
              textAlign: TextAlign.center,
              style: AppStyles.text.medium(
                fSize: 14.sp,
                color: AppColors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

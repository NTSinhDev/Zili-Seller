# Bottom Sheet Widgets

Thư mục này chứa các widget liên quan đến bottom sheet trong ứng dụng.

## BottomSheetHeader

Widget header cho bottom sheet với title và close button. Thường được sử dụng ở đầu bottom sheet để hiển thị tiêu đề và nút đóng.

### 📍 Vị trí
```
lib/utils/widgets/bottom_sheet/bottom_sheet_header.dart
```

### 🎯 Mục đích sử dụng
- Header cho bottom sheet với title
- Hiển thị nút đóng bottom sheet
- Phân cách nội dung với border bottom
- Tái sử dụng ở nhiều bottom sheet khác nhau

### ✨ Tính năng
- ✅ Hiển thị title text (có thể customize style)
- ✅ Close button với icon (có thể customize hoặc ẩn)
- ✅ Border bottom để phân cách (có thể customize)
- ✅ Padding có thể customize
- ✅ Responsive với ScreenUtil

### 📦 Import
```dart
import 'package:zili_coffee/utils/widgets/widgets.dart';
// Hoặc
import 'package:zili_coffee/utils/widgets/bottom_sheet/bottom_sheet_header.dart';
```

### 🚀 Sử dụng cơ bản

#### 1. Basic Header với Close Button
```dart
BottomSheetHeader(
  title: 'Hình thức thanh toán',
  onClose: () => Navigator.pop(context),
)
```

#### 2. Header không có Close Button
```dart
BottomSheetHeader(
  title: 'Chọn địa chỉ',
  showCloseButton: false,
)
```

#### 3. Custom Styled Header
```dart
BottomSheetHeader(
  title: 'Custom Header',
  onClose: () => Navigator.pop(context),
  titleStyle: AppStyles.text.bold(fSize: 18.sp),
  borderColor: Colors.blue,
  padding: EdgeInsets.all(16.w),
)
```

### 🎨 Customization

#### Custom Title Style
```dart
BottomSheetHeader(
  title: 'Payment Methods',
  onClose: onClose,
  titleStyle: AppStyles.text.bold(
    fSize: 18.sp,
    color: Colors.blue,
  ),
)
```

#### Custom Close Button
```dart
BottomSheetHeader(
  title: 'Select Option',
  onClose: onClose,
  closeButton: Container(
    padding: EdgeInsets.all(8.w),
    decoration: BoxDecoration(
      color: Colors.red.shade50,
      shape: BoxShape.circle,
    ),
    child: Icon(Icons.close, color: Colors.red),
  ),
)
```

#### Custom Close Icon
```dart
BottomSheetHeader(
  title: 'Options',
  onClose: onClose,
  closeIcon: Icons.cancel,
  closeIconColor: Colors.red,
  closeIconSize: 20.sp,
)
```

### 📋 API Reference

#### Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `title` | `String` | Title hiển thị (required) |

#### Optional Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `onClose` | `VoidCallback?` | `null` | Callback khi tap vào close button |
| `showCloseButton` | `bool?` | `true` nếu có `onClose`, `false` nếu không | Hiển thị close button hay không |
| `titleStyle` | `TextStyle?` | `AppStyles.text.semiBold(fSize: 16.sp)` | Style của title text |
| `borderColor` | `Color?` | `AppColors.greyC0` | Màu border bottom |
| `padding` | `EdgeInsets?` | `EdgeInsets.fromLTRB(20.w, 10.h, 12.w, 5.h)` | Padding cho header |
| `mainAxisAlignment` | `MainAxisAlignment?` | `MainAxisAlignment.spaceBetween` | Main axis alignment của RowWidget |
| `closeButton` | `Widget?` | `null` | Custom close button widget |
| `closeButtonPadding` | `EdgeInsets?` | `EdgeInsets.all(4.w)` | Padding cho close button container |
| `closeIcon` | `IconData?` | `Icons.close` | Icon cho close button |
| `closeIconColor` | `Color?` | `AppColors.grey84` | Màu của close icon |
| `closeIconSize` | `double?` | `24.sp` | Size của close icon |

### 🔄 Behavior

#### Close Button Display Logic
- Nếu `showCloseButton == true`: Hiển thị close button
- Nếu `showCloseButton == false`: Ẩn close button
- Nếu `showCloseButton == null`: 
  - Hiển thị nếu `onClose != null`
  - Ẩn nếu `onClose == null`

### 📝 Examples

#### Example 1: Payment Method Selector (Current Usage)
```dart
showModalBottomSheet(
  context: context,
  builder: (context) => Container(
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    child: ColumnWidget(
      mainAxisSize: MainAxisSize.min,
      children: [
        BottomSheetHeader(
          title: 'Hình thức thanh toán',
          onClose: () => Navigator.pop(context),
        ),
        // ... rest of content
      ],
    ),
  ),
)
```

#### Example 2: Address Selector
```dart
BottomSheetHeader(
  title: 'Chọn địa chỉ giao hàng',
  onClose: () => Navigator.pop(context),
  titleStyle: AppStyles.text.bold(fSize: 18.sp),
)
```

#### Example 3: Custom Styled Header
```dart
BottomSheetHeader(
  title: 'Select Payment Method',
  onClose: () => Navigator.pop(context),
  titleStyle: AppStyles.text.bold(
    fSize: 20.sp,
    color: AppColors.primary,
  ),
  borderColor: AppColors.primary,
  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
  closeButton: Container(
    padding: EdgeInsets.all(8.w),
    decoration: BoxDecoration(
      color: AppColors.scarlet.withOpacity(0.1),
      shape: BoxShape.circle,
    ),
    child: Icon(
      Icons.close,
      color: AppColors.scarlet,
      size: 20.sp,
    ),
  ),
)
```

### 🔗 Related Widgets
- [OpenBottomSheetListButton] - Widget button để mở bottom sheet
- [BottomSheetListItem] - Widget hiển thị item trong bottom sheet list
- [CustomModalBottomSheet] - Widget wrapper cho bottom sheet

### 📚 Best Practices

1. **Luôn cung cấp onClose callback**: Giúp người dùng có thể đóng bottom sheet
   ```dart
   onClose: () => Navigator.pop(context),  // ✅ Good
   // onClose: null,  // ❌ Bad (không có cách đóng)
   ```

2. **Sử dụng title có ý nghĩa**: Giúp người dùng hiểu rõ nội dung bottom sheet
   ```dart
   title: 'Hình thức thanh toán',  // ✅ Good
   title: 'Select',  // ❌ Bad (quá mơ hồ)
   ```

3. **Customize khi cần**: Chỉ customize khi thực sự cần thiết, giữ default cho consistency
   ```dart
   // ✅ Good: Chỉ customize khi cần highlight
   BottomSheetHeader(
     title: 'Important Selection',
     onClose: onClose,
     titleStyle: AppStyles.text.bold(fSize: 18.sp),  // Highlight important
   )
   ```

4. **Ẩn close button khi không cần**: Một số bottom sheet có thể không cần close button
   ```dart
   BottomSheetHeader(
     title: 'Information',
     showCloseButton: false,  // ✅ Good (nếu có cách đóng khác)
   )
   ```

### 🐛 Troubleshooting

#### Issue: Close button không hiển thị
**Nguyên nhân**: `onClose` là null và `showCloseButton` không được set  
**Giải pháp**: Truyền `onClose` callback hoặc set `showCloseButton: true`

#### Issue: Close button không hoạt động
**Nguyên nhân**: `onClose` callback không được truyền hoặc không đúng  
**Giải pháp**: Kiểm tra `onClose` callback có đúng không

#### Issue: Title style không áp dụng
**Nguyên nhân**: Có thể bị override bởi style khác  
**Giải pháp**: Kiểm tra `titleStyle` parameter có được truyền đúng không

### 📅 Changelog

#### v1.0.0 (2025-01-XX)
- ✅ Initial release
- ✅ Basic functionality: title, close button
- ✅ Customization options: colors, fonts, padding, border
- ✅ Custom close button support
- ✅ Auto show/hide close button based on onClose

### 👥 Contributors
- Created as part of Payment Screen implementation
- Extracted from `payment_section.dart` for reusability

---

## OpenBottomSheetListButton

Widget button để mở bottom sheet với danh sách. Widget này hiển thị một button có label và value, khi tap sẽ mở bottom sheet. Thường được sử dụng để chọn một item từ danh sách.

### 📍 Vị trí
```
lib/utils/widgets/bottom_sheet/open_bottom_sheet_list_button.dart
```

### 🎯 Mục đích sử dụng
- Chọn phương thức thanh toán
- Chọn địa chỉ giao hàng
- Chọn bất kỳ option nào từ danh sách
- Hiển thị giá trị đã chọn với placeholder khi chưa chọn

### ✨ Tính năng
- ✅ Hiển thị label (text nhỏ, màu xám) phía trên
- ✅ Hiển thị value (text lớn, màu đen) hoặc placeholder (màu xám) phía dưới
- ✅ Icon chevron_right bên phải (có thể customize)
- ✅ Tự động đổi màu text dựa trên việc có value hay không
- ✅ Border và background có thể customize
- ✅ Responsive với ScreenUtil

### 📦 Import
```dart
import 'package:zili_coffee/utils/widgets/widgets.dart';
// Hoặc
import 'package:zili_coffee/utils/widgets/bottom_sheet/open_bottom_sheet_list_button.dart';
```

### 🚀 Sử dụng cơ bản

#### 1. Payment Method Selector
```dart
OpenBottomSheetListButton(
  label: 'Hình thức thanh toán',
  value: selectedPaymentMethod?.displayName,
  placeholder: 'Chọn hình thức',
  onTap: () => showPaymentMethodSelector(),
)
```

#### 2. Address Selector
```dart
OpenBottomSheetListButton(
  label: 'Địa chỉ giao hàng',
  value: selectedAddress?.fullAddress,
  placeholder: 'Chọn địa chỉ',
  onTap: () => showAddressSelector(),
)
```

#### 3. Custom Option Selector
```dart
OpenBottomSheetListButton(
  label: 'Chọn option',
  value: selectedOption,
  placeholder: 'Chọn...',
  onTap: () => showOptionsBottomSheet(),
)
```

### 🎨 Customization

#### Custom Colors
```dart
OpenBottomSheetListButton(
  label: 'Payment Method',
  value: selectedMethod,
  placeholder: 'Select method',
  onTap: onTap,
  backgroundColor: Colors.blue.shade50,
  borderColor: Colors.blue,
  valueTextColor: Colors.blue,
  placeholderTextColor: Colors.grey,
)
```

#### Custom Font Sizes
```dart
OpenBottomSheetListButton(
  label: 'Large Text',
  value: selectedValue,
  placeholder: 'Select...',
  onTap: onTap,
  labelFontSize: 14.sp,
  valueFontSize: 16.sp,
)
```

#### Custom Padding & Border
```dart
OpenBottomSheetListButton(
  label: 'Custom Style',
  value: selectedValue,
  placeholder: 'Select...',
  onTap: onTap,
  padding: EdgeInsets.all(16.w),
  borderRadius: 12.r,
)
```

#### Custom Trailing Icon
```dart
OpenBottomSheetListButton(
  label: 'Custom Icon',
  value: selectedValue,
  placeholder: 'Select...',
  onTap: onTap,
  trailing: Icon(Icons.arrow_drop_down),
  // Hoặc
  trailingIconSize: 20.sp,
  trailingIconColor: Colors.blue,
)
```

### 📋 API Reference

#### Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `label` | `String` | Label hiển thị phía trên (required) |
| `onTap` | `VoidCallback` | Callback khi tap vào button (required) |

#### Optional Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `value` | `String?` | `null` | Value hiển thị phía dưới |
| `placeholder` | `String?` | `''` | Placeholder text khi value null hoặc empty |
| `backgroundColor` | `Color?` | `AppColors.white` | Màu nền của container |
| `borderColor` | `Color?` | `AppColors.greyC0` | Màu border |
| `labelTextColor` | `Color?` | `AppColors.grey84` | Màu text label |
| `valueTextColor` | `Color?` | `AppColors.black3` | Màu text value (khi có value) |
| `placeholderTextColor` | `Color?` | `AppColors.grey84` | Màu text placeholder (khi không có value) |
| `labelFontSize` | `double?` | `12.sp` | Font size của label |
| `valueFontSize` | `double?` | `14.sp` | Font size của value |
| `padding` | `EdgeInsetsGeometry?` | `EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h)` | Padding cho container |
| `borderRadius` | `double?` | `8.r` | Border radius |
| `trailing` | `Widget?` | `Icon(Icons.chevron_right)` | Custom trailing widget |
| `trailingIconSize` | `double?` | `24.sp` | Size của icon trailing (chỉ áp dụng khi không dùng custom trailing) |
| `trailingIconColor` | `Color?` | `AppColors.grey84` | Màu icon trailing (chỉ áp dụng khi không dùng custom trailing) |

### 🔄 Behavior

#### Value Display Logic
- Nếu `value != null && value!.isNotEmpty`: Hiển thị value với màu `valueTextColor` (mặc định: đen)
- Nếu `value == null || value!.isEmpty`: Hiển thị `placeholder` với màu `placeholderTextColor` (mặc định: xám)

#### Color Logic
```dart
// Tự động đổi màu dựa trên việc có value hay không
color: _hasValue
    ? (valueTextColor ?? AppColors.black3)  // Có value → màu đen
    : (placeholderTextColor ?? AppColors.grey84)  // Không có value → màu xám
```

### 📝 Examples

#### Example 1: Payment Method (Current Usage)
```dart
class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  SellerPaymentMethod? _selectedPaymentMethod;
  
  void _showPaymentMethodSelector() {
    // Show bottom sheet with payment methods
  }
  
  @override
  Widget build(BuildContext context) {
    return OpenBottomSheetListButton(
      label: 'Hình thức thanh toán',
      value: _selectedPaymentMethod?.displayName,
      placeholder: 'Chọn hình thức',
      onTap: _showPaymentMethodSelector,
    );
  }
}
```

#### Example 2: Address Selector
```dart
OpenBottomSheetListButton(
  label: 'Địa chỉ giao hàng',
  value: selectedAddress != null 
    ? '${selectedAddress!.name} - ${selectedAddress!.phone}'
    : null,
  placeholder: 'Chọn địa chỉ',
  onTap: () {
    showModalBottomSheet(
      context: context,
      builder: (context) => AddressListBottomSheet(
        addresses: addresses,
        onAddressSelected: (address) {
          setState(() => selectedAddress = address);
        },
      ),
    );
  },
)
```

#### Example 3: Custom Styled Button
```dart
OpenBottomSheetListButton(
  label: 'Chọn màu sắc',
  value: selectedColor?.name,
  placeholder: 'Chọn màu',
  onTap: _showColorPicker,
  backgroundColor: Colors.grey.shade100,
  borderColor: Colors.blue,
  borderRadius: 12.r,
  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
  labelFontSize: 13.sp,
  valueFontSize: 15.sp,
  valueTextColor: Colors.blue,
  trailing: Icon(Icons.palette, color: Colors.blue),
)
```

### 🔗 Related Widgets
- `BottomSheetListItem`: Widget hiển thị item trong bottom sheet list
- `CustomModalBottomSheet`: Widget wrapper cho bottom sheet

### 📚 Best Practices

1. **Luôn cung cấp placeholder**: Giúp người dùng hiểu rõ cần chọn gì
   ```dart
   placeholder: 'Chọn hình thức',  // ✅ Good
   // placeholder: null,  // ❌ Bad
   ```

2. **Sử dụng value có ý nghĩa**: Hiển thị thông tin quan trọng nhất
   ```dart
   value: paymentMethod?.displayName,  // ✅ Good
   value: paymentMethod?.id,  // ❌ Bad (ID không có ý nghĩa với user)
   ```

3. **Customize khi cần**: Chỉ customize khi thực sự cần thiết, giữ default cho consistency
   ```dart
   // ✅ Good: Chỉ customize khi cần highlight
   OpenBottomSheetListButton(
     label: 'Important Selection',
     value: selectedValue,
     onTap: onTap,
     backgroundColor: Colors.blue.shade50,  // Highlight important field
   )
   ```

4. **Xử lý null value**: Luôn kiểm tra null trước khi truyền vào value
   ```dart
   value: selectedItem?.displayName,  // ✅ Good (sử dụng ?. để handle null)
   value: selectedItem.displayName,  // ❌ Bad (có thể throw error nếu null)
   ```

### 🐛 Troubleshooting

#### Issue: Value không hiển thị
**Nguyên nhân**: Value có thể là empty string `''`  
**Giải pháp**: Kiểm tra `value != null && value!.isNotEmpty`

#### Issue: Placeholder không hiển thị
**Nguyên nhân**: Không truyền `placeholder` parameter  
**Giải pháp**: Luôn truyền `placeholder` parameter

#### Issue: Màu text không đúng
**Nguyên nhân**: Logic tự động đổi màu dựa trên `_hasValue`  
**Giải pháp**: Kiểm tra `value` có null hoặc empty không

### 📅 Changelog

#### v1.0.0 (2025-01-XX)
- ✅ Initial release
- ✅ Basic functionality: label, value, placeholder
- ✅ Customization options: colors, fonts, padding, border
- ✅ Auto color switching based on value presence
- ✅ Custom trailing widget support

### 👥 Contributors
- Created as part of Payment Screen implementation
- Extracted from `payment_section.dart` for reusability


# Đặc Tả Thiết Kế UI/UX - Màn Hình Khách Hàng

## Tổng Quan

Màn hình **"Khách hàng"** (Customer Management Screen) là màn hình quản lý danh sách khách hàng, cho phép người dùng tìm kiếm, lọc, sắp xếp và quản lý thông tin khách hàng trong hệ thống.

## Mục Đích

- Hiển thị danh sách tất cả khách hàng
- Tìm kiếm khách hàng theo tên, số điện thoại, mã
- Lọc khách hàng theo trạng thái (Tất cả, Đang giao dịch)
- Sắp xếp và lọc nâng cao
- Xem thông tin chi tiết khách hàng
- Thêm khách hàng mới

## Cấu Trúc Màn Hình

### 1. System Status Bar (Top Bar)
**Vị trí**: Cực trên cùng màn hình  
**Màu nền**: Trong suốt hoặc theo theme hệ thống

**Thông tin hiển thị**:
- **Bên trái**: Thời gian hiện tại (ví dụ: "9:29")
- **Bên phải**:
  - Tốc độ mạng: "0,00 KB/s"
  - Icon thông báo (bell icon)
  - Cường độ tín hiệu (signal bars - đầy đủ)
  - Icon Wi-Fi (đầy đủ)
  - Pin: "47%" với icon pin

**Kỹ thuật**:
- Sử dụng `SystemChrome` hoặc `SafeArea` để hiển thị
- Tự động cập nhật từ hệ thống

### 2. Navigation Bar
**Vị trí**: Ngay dưới System Status Bar  
**Chiều cao**: ~56.h (Material Design AppBar height)  
**Màu nền**: Trắng (`AppColors.white`)

**Components**:
- **Back Button** (Bên trái):
  - Icon: `Icons.arrow_back` hoặc custom back icon
  - Kích thước: 24.sp
  - Màu: `AppColors.black3`
  - Action: `Navigator.pop(context)`
  
- **Sync/Download Button** (Bên phải):
  - Icon: Cloud với mũi tên xuống
  - Kích thước: 24.sp
  - Màu: `AppColors.black3`
  - Action: Đồng bộ dữ liệu khách hàng
  
- **User/Profile Icons** (Bên phải):
  - Icon: Hai người (group icon)
  - Kích thước: 24.sp
  - Màu: `AppColors.black3`
  - Action: Mở menu người dùng hoặc cài đặt

**Implementation**:
```dart
AppbarWidget.lightAppBar(
  context,
  label: 'Khách hàng',
  leading: IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () => Navigator.pop(context),
  ),
  actions: [
    IconButton(
      icon: Icon(Icons.cloud_download),
      onPressed: _syncCustomers,
    ),
    IconButton(
      icon: Icon(Icons.people),
      onPressed: _showUserMenu,
    ),
  ],
)
```

### 3. Screen Title
**Vị trí**: Dưới Navigation Bar  
**Padding**: `EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h)`

**Text**:
- Nội dung: "Khách hàng"
- Style: `AppStyles.text.bold(fSize: 24.sp, color: AppColors.black3)`
- Alignment: Center hoặc Left
- Font weight: Bold

### 4. Search Bar
**Vị trí**: Dưới Screen Title  
**Padding**: `EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h)`

**Design**:
- **Container**:
  - Màu nền: `AppColors.background` hoặc `AppColors.greyF5`
  - Border radius: `8.r` hoặc `12.r`
  - Height: `48.h`
  - Padding: `EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h)`

- **Content**:
  - **Leading Icon**: 
    - Icon: `Icons.search`
    - Kích thước: `20.sp`
    - Màu: `AppColors.grey84`
    - Margin right: `12.w`
  
  - **Text Field**:
    - Placeholder: "Nhập tên, số điện thoại, mã"
    - Style: `AppStyles.text.medium(fSize: 14.sp, color: AppColors.black3)`
    - Hint style: `AppStyles.text.medium(fSize: 14.sp, color: AppColors.grey84)`
    - Border: None (vì có container background)
    - Text input action: `TextInputAction.search`

**Functionality**:
- Debounce search: 500ms
- Search theo: `name`, `phone`, `code`
- Hiển thị loading indicator khi đang search
- Clear button khi có text

**Implementation**:
```dart
CommonSearchBar(
  controller: _searchController,
  hintSearch: 'Nhập tên, số điện thoại, mã',
  onChanged: (value) {
    EasyDebounce.debounce(
      'customerSearch',
      Duration(milliseconds: 500),
      () => _onSearch(value),
    );
  },
)
```

### 5. Filter Tabs
**Vị trí**: Dưới Search Bar  
**Padding**: `EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h)`

**Layout**: Row với 2 tabs và 2 action buttons

**Tabs**:
- **Tab 1: "Tất cả"** (All)
  - Style khi selected:
    - Text color: `AppColors.primary`
    - Font weight: SemiBold
    - Underline: `Border(bottom: BorderSide(color: AppColors.primary, width: 2.w))`
  - Style khi unselected:
    - Text color: `AppColors.black3`
    - Font weight: Medium
    - Underline: None
  
- **Tab 2: "Đang giao dịch"** (In Transaction)
  - Style tương tự Tab 1
  - Filter: Chỉ hiển thị khách hàng có `totalOrder > 0` hoặc `lastPurchaseAt != null`

**Action Buttons** (Bên phải tabs):
- **Sort Button**:
  - Icon: `Icons.swap_vert` (double arrow up/down)
  - Kích thước: `24.sp`
  - Màu: `AppColors.black3`
  - Action: Mở bottom sheet sắp xếp (Tên A-Z, Tên Z-A, Số đơn tăng, Số đơn giảm, Tổng chi tiêu tăng, Tổng chi tiêu giảm)
  
- **Filter Button**:
  - Icon: `Icons.filter_list` với gear icon
  - Kích thước: `24.sp`
  - Màu: `AppColors.black3`
  - Action: Mở bottom sheet filter (Theo khoảng thời gian, Theo tổng chi tiêu, Theo số đơn hàng, v.v.)

**Implementation**:
```dart
Row(
  children: [
    Expanded(
      child: Row(
        children: [
          _buildTab('Tất cả', isSelected: _selectedTab == 0),
          SizedBox(width: 24.w),
          _buildTab('Đang giao dịch', isSelected: _selectedTab == 1),
        ],
      ),
    ),
    IconButton(
      icon: Icon(Icons.swap_vert),
      onPressed: _showSortOptions,
    ),
    IconButton(
      icon: Icon(Icons.filter_list),
      onPressed: _showFilterOptions,
    ),
  ],
)
```

### 6. Customer Count
**Vị trí**: Dưới Filter Tabs  
**Padding**: `EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h)`

**Text**:
- Format: "{count} khách hàng" (ví dụ: "99 khách hàng")
- Style: `AppStyles.text.medium(fSize: 14.sp, color: AppColors.grey84)`
- Dynamic: Cập nhật theo số lượng khách hàng hiện tại

**Implementation**:
```dart
Text(
  '${_customers.length} khách hàng',
  style: AppStyles.text.medium(
    fSize: 14.sp,
    color: AppColors.grey84,
  ),
)
```

### 7. Customer List
**Vị trí**: Dưới Customer Count, chiếm phần còn lại của màn hình  
**Scroll**: Vertical scroll với pull-to-refresh và load more

**List Item Design**:

Mỗi item có:
- **Separator**: `Divider(color: AppColors.greyC0, height: 1.h)`
- **Padding**: `EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h)`
- **Tap area**: Toàn bộ item (InkWell)

**Item Layout** (Row):
- **Left Section** (Expanded):
  - **Customer Name**:
    - Text: `customer.fullName` hoặc `customer.displayName`
    - Style: `AppStyles.text.semiBold(fSize: 16.sp, color: AppColors.black3)`
    - Max lines: 1
    - Overflow: `TextOverflow.ellipsis`
  
  - **Phone Number** (Optional):
    - Text: `customer.phone ?? "---"`
    - Style: `AppStyles.text.medium(fSize: 14.sp, color: AppColors.grey84)`
    - Hiển thị "---" nếu không có
  
  - **Address** (Optional):
    - Text: `customer.purchaseAddress?.fullAddress ?? "---"`
    - Style: `AppStyles.text.medium(fSize: 12.sp, color: AppColors.grey84)`
    - Max lines: 1
    - Overflow: `TextOverflow.ellipsis`
    - Hiển thị "---" nếu không có

- **Right Section**:
  - **Transaction Count**:
    - Text: "{count}" (ví dụ: "0")
    - Style: `AppStyles.text.medium(fSize: 14.sp, color: AppColors.black3)`
    - Alignment: Right
  
  - **Status Badge**:
    - Text: "Đang giao dịch"
    - Style: `AppStyles.text.medium(fSize: 12.sp, color: AppColors.green)` hoặc `AppColors.primary`
    - Background: Trong suốt hoặc `AppColors.green.withOpacity(0.1)`
    - Padding: `EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h)`
    - Border radius: `4.r`

**Item States**:
- **Normal**: Background trắng
- **Pressed**: Background `AppColors.background`
- **Selected**: Border `AppColors.primary` với background `AppColors.primary.withOpacity(0.1)`

**Empty State**:
- Hiển thị khi không có khách hàng
- Icon: `Icons.people_outline`
- Text: "Chưa có khách hàng"
- Subtitle: "Nhấn nút + để thêm khách hàng mới"

**Loading State**:
- Shimmer effect hoặc skeleton loading
- Hiển thị 5-10 placeholder items

**Implementation**:
```dart
ListView.separated(
  itemCount: _customers.length,
  separatorBuilder: (context, index) => Divider(
    color: AppColors.greyC0,
    height: 1.h,
  ),
  itemBuilder: (context, index) {
    final customer = _customers[index];
    return _CustomerListItem(
      customer: customer,
      onTap: () => _navigateToCustomerDetail(customer),
    );
  },
)
```

### 8. Floating Action Button (FAB)
**Vị trí**: Bottom right corner  
**Offset**: `EdgeInsets.only(right: 16.w, bottom: 16.h)`

**Design**:
- **Shape**: Circular
- **Size**: 56.w x 56.h
- **Background**: `AppColors.primary`
- **Icon**: `Icons.add` (white, size: 24.sp)
- **Elevation**: 4-6

**Action**: 
- Navigate to "Add Customer" screen hoặc show bottom sheet form

**Implementation**:
```dart
FloatingActionButton(
  onPressed: () => Navigator.pushNamed(
    context,
    AddCustomerScreen.keyName,
  ),
  backgroundColor: AppColors.primary,
  child: Icon(Icons.add, color: AppColors.white),
)
```

## States & Interactions

### 1. Initial Load State
- Hiển thị shimmer/skeleton loading
- Gọi API: `CustomerCubit.filterCustomers(isInitialLoad: true)`
- State: `LoadingCustomerState`

### 2. Search State
- Debounce: 500ms
- Inline loading indicator trong search bar
- Gọi API: `CustomerCubit.filterCustomers(keyword: searchText)`
- State: `LoadingCustomerState(event: "search")`

### 3. Filter State
- Tab "Tất cả": Hiển thị tất cả khách hàng
- Tab "Đang giao dịch": Filter `totalOrder > 0` hoặc `lastPurchaseAt != null`
- Update customer count

### 4. Sort State
- Options:
  - Tên A-Z
  - Tên Z-A
  - Số đơn tăng dần
  - Số đơn giảm dần
  - Tổng chi tiêu tăng dần
  - Tổng chi tiêu giảm dần
- Apply sort và refresh list

### 5. Filter State (Advanced)
- Options:
  - Theo khoảng thời gian (lastPurchaseAt)
  - Theo tổng chi tiêu (totalSpending range)
  - Theo số đơn hàng (totalOrder range)
  - Theo trạng thái (active, inactive)
- Apply filter và refresh list

### 6. Pull to Refresh
- Action: `CustomerCubit.filterCustomers(keyword: currentKeyword, event: "refresh")`
- Show refresh indicator
- Reload danh sách từ đầu

### 7. Load More (Pagination)
- Trigger: Khi scroll gần cuối list (80% scroll)
- Action: `CustomerCubit.loadMoreCustomers(offset: currentLength)`
- Append items vào list hiện tại
- Show loading indicator ở cuối list

### 8. Item Tap
- Navigate to Customer Detail Screen
- Pass customer object: `Navigator.pushNamed(context, CustomerDetailScreen.keyName, arguments: customer)`

### 9. Empty State
- Hiển thị khi `_customers.isEmpty`
- Show empty state widget với icon và message
- CTA: "Thêm khách hàng" button

### 10. Error State
- Hiển thị error message
- Retry button
- State: `FailedCustomerState`

## Data Model

### Customer Model
```dart
class Customer {
  final String id;
  final String? code;
  final String? fullName;
  final String? phone;
  final String? email;
  final String? avatar;
  final Address? purchaseAddress;
  final Address? billingAddress;
  final int totalOrder;
  final double totalSpending;
  final DateTime? lastPurchaseAt;
  final UserStatus status;
  // ... other fields
}
```

### Display Fields
- **Name**: `customer.fullName ?? customer.displayName ?? "---"`
- **Phone**: `customer.phone ?? "---"`
- **Address**: `customer.purchaseAddress?.fullAddress ?? "---"`
- **Transaction Count**: `customer.totalOrder.toString()`
- **Status**: 
  - "Đang giao dịch" nếu `customer.totalOrder > 0` hoặc `customer.lastPurchaseAt != null`
  - "Chưa giao dịch" nếu `customer.totalOrder == 0`

## Colors & Styles

### Colors
- **Primary**: `AppColors.primary` (Blue)
- **Background**: `AppColors.white`
- **Text Primary**: `AppColors.black3`
- **Text Secondary**: `AppColors.grey84`
- **Divider**: `AppColors.greyC0`
- **Status Active**: `AppColors.green` hoặc `AppColors.primary`
- **Search Background**: `AppColors.background` hoặc `AppColors.greyF5`

### Typography
- **Title**: `AppStyles.text.bold(fSize: 24.sp)`
- **Customer Name**: `AppStyles.text.semiBold(fSize: 16.sp)`
- **Phone/Address**: `AppStyles.text.medium(fSize: 14.sp, color: AppColors.grey84)`
- **Count**: `AppStyles.text.medium(fSize: 14.sp, color: AppColors.grey84)`
- **Status**: `AppStyles.text.medium(fSize: 12.sp, color: AppColors.green)`

## Responsive Design

### Screen Sizes
- **Small**: < 360dp width
  - Reduce padding: `12.w` thay vì `16.w`
  - Smaller font sizes: `-2.sp`
  - Compact list items
  
- **Medium**: 360dp - 600dp width
  - Standard padding: `16.w`
  - Standard font sizes
  
- **Large**: > 600dp width
  - Increased padding: `24.w`
  - Larger font sizes: `+2.sp`
  - Grid layout option (2 columns)

### Orientation
- **Portrait**: Vertical list (default)
- **Landscape**: Có thể chuyển sang grid layout hoặc tăng số cột

## Performance Considerations

### 1. List Optimization
- Sử dụng `ListView.builder` thay vì `ListView`
- Lazy loading với pagination
- Cache customer list trong repository

### 2. Search Optimization
- Debounce search input (500ms)
- Cancel previous search requests
- Show loading indicator trong search bar

### 3. Image Loading
- Lazy load avatars với `cached_network_image`
- Placeholder khi loading
- Error fallback icon

### 4. State Management
- Sử dụng `BlocBuilder` để rebuild chỉ khi cần
- StreamBuilder cho reactive updates
- Dispose controllers properly

## Accessibility

### Screen Reader Support
- Semantic labels cho tất cả interactive elements
- Customer name là heading level 2
- Status text có semantic meaning

### Touch Targets
- Minimum touch target: 48x48 dp
- List items có padding đủ lớn
- FAB size: 56x56 dp

### Color Contrast
- Text trên background: WCAG AA compliant
- Status colors có contrast đủ

## Error Handling

### Network Errors
- Hiển thị SnackBar với error message
- Retry button
- Offline indicator nếu không có internet

### Empty States
- No customers: "Chưa có khách hàng"
- No search results: "Không tìm thấy khách hàng"
- Filter no results: "Không có khách hàng phù hợp"

### Loading States
- Initial load: Full screen shimmer
- Search: Inline loading trong search bar
- Load more: Loading indicator ở cuối list
- Refresh: Pull-to-refresh indicator

## Navigation Flow

### From This Screen
1. **Back Button** → Previous screen
2. **Customer Item Tap** → Customer Detail Screen
3. **FAB** → Add Customer Screen
4. **Sort Button** → Sort Options Bottom Sheet
5. **Filter Button** → Filter Options Bottom Sheet
6. **Sync Button** → Sync data (show progress)

### To This Screen
- From: Order Creation Screen, Home Screen, Menu
- Route: `/customers` hoặc `CustomerScreen.keyName`

## API Integration

### Endpoints
- **Filter Customers**: `GET /business/customer/filter`
  - Query params: `keyword`, `limit`, `offset`
  - Returns: `{count: int, customers: List<Customer>}`

### State Management
- **Cubit**: `CustomerCubit`
- **States**: 
  - `LoadingCustomerState` (với event: "initial", "search", "loadMore", "refresh")
  - `CustomerFilterLoadedState`
  - `FailedCustomerState`
- **Repository**: `CustomerRepository`
  - Stream: `customersFilter.stream`
  - Value: `customersFilter.valueOrNull`

## Testing Considerations

### Unit Tests
- Search functionality
- Filter logic
- Sort logic
- Pagination logic

### Widget Tests
- List item rendering
- Empty state display
- Loading state display
- Error state display

### Integration Tests
- Full search flow
- Filter by tab
- Sort options
- Add customer flow
- Navigate to detail

## Future Enhancements

### Phase 1
- [ ] Advanced filters (date range, spending range)
- [ ] Export customer list
- [ ] Bulk actions (select multiple customers)

### Phase 2
- [ ] Customer groups/tags
- [ ] Customer notes
- [ ] Customer history timeline
- [ ] Quick actions (call, message, email)

### Phase 3
- [ ] Customer analytics dashboard
- [ ] Customer segmentation
- [ ] Automated customer insights

## Implementation Checklist

### UI Components
- [ ] System Status Bar
- [ ] Navigation Bar với back, sync, user icons
- [ ] Screen Title
- [ ] Search Bar với debounce
- [ ] Filter Tabs (Tất cả, Đang giao dịch)
- [ ] Sort Button
- [ ] Filter Button
- [ ] Customer Count
- [ ] Customer List với separators
- [ ] Customer List Item component
- [ ] FAB
- [ ] Empty State
- [ ] Loading State (shimmer)
- [ ] Error State

### Functionality
- [ ] Search với debounce
- [ ] Filter by tab
- [ ] Sort options bottom sheet
- [ ] Filter options bottom sheet
- [ ] Pull to refresh
- [ ] Load more pagination
- [ ] Navigate to customer detail
- [ ] Navigate to add customer
- [ ] Sync data functionality

### State Management
- [ ] Integrate CustomerCubit
- [ ] Handle LoadingCustomerState
- [ ] Handle CustomerFilterLoadedState
- [ ] Handle FailedCustomerState
- [ ] StreamBuilder cho customer list
- [ ] Update customer count

### API Integration
- [ ] Call filterCustomers API
- [ ] Handle pagination
- [ ] Handle search
- [ ] Handle refresh
- [ ] Error handling

## File Structure

```
lib/views/customer/
├── docs.md (this file)
├── customer_screen.dart (main screen)
├── components/
│   ├── customer_list_item.dart
│   ├── customer_search_bar.dart
│   ├── customer_filter_tabs.dart
│   ├── customer_sort_bottom_sheet.dart
│   ├── customer_filter_bottom_sheet.dart
│   └── customer_empty_state.dart
└── add_customer/
    └── add_customer_screen.dart
```

## Notes

- Màn hình này là màn hình quản lý khách hàng chính, khác với `SelectCustomersScreen` (dùng trong order creation)
- Customer count cập nhật real-time khi filter/search
- Status "Đang giao dịch" có thể được định nghĩa khác nhau tùy business logic
- FAB có thể được thay thế bằng button trong AppBar nếu design yêu cầu
- Sort và Filter có thể được combine vào một bottom sheet nếu cần


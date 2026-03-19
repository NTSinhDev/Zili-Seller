// Example usage of LoadingScreen pattern
// This file demonstrates how to use LoadingScreen for pre-loading data

/// Example: How to use LoadingScreen before navigating to CreateOrderScreen
/// 
/// Import: import 'package:zili_coffee/views/loading/loading_screen.dart';
/// 
/// Usage:
/// ```dart
/// LoadingScreen.navigate(
///   context,
///   tasks: [
///     LoadingTask(
///       name: 'Chi nhánh',
///       loader: () async {
///         // Load default branch
///         return await branchRepository.getDefaultBranch();
///       },
///       errorMessage: 'Không thể tải thông tin chi nhánh',
///     ),
///     LoadingTask(
///       name: 'Danh sách sản phẩm',
///       loader: () async {
///         // Load products list
///         return await productRepository.getProducts();
///       },
///       errorMessage: 'Không thể tải danh sách sản phẩm',
///     ),
///     LoadingTask(
///       name: 'Danh sách khách hàng',
///       loader: () async {
///         // Load customers list
///         return await customerRepository.getCustomers();
///       },
///       errorMessage: 'Không thể tải danh sách khách hàng',
///     ),
///     LoadingTask(
///       name: 'Danh sách nhân viên',
///       loader: () async {
///         // Load staff list
///         return await staffRepository.getStaff();
///       },
///       errorMessage: 'Không thể tải danh sách nhân viên',
///     ),
///   ],
///   successRoute: CreateOrderScreen.keyName,
///   loadingMessage: 'Đang chuẩn bị dữ liệu...',
///   sequential: true, // Load sequentially
///   onSuccess: (data) {
///     // Optional: Handle success
///     print('Loaded data: $data');
///   },
///   onError: (errorMessage, failedTask) {
///     // Optional: Handle error
///     print('Error: $errorMessage');
///   },
/// );
/// ```
/// 
/// Or using direct navigation:
/// ```dart
/// Navigator.pushNamed(
///   context,
///   LoadingScreen.keyName,
///   arguments: {
///     'tasks': [
///       LoadingTask(
///         name: 'Chi nhánh',
///         loader: () async => await branchRepository.getDefaultBranch(),
///       ),
///       LoadingTask(
///         name: 'Sản phẩm',
///         loader: () async => await productRepository.getProducts(),
///       ),
///     ],
///     'successRoute': CreateOrderScreen.keyName,
///     'loadingMessage': 'Đang tải dữ liệu...',
///     'sequential': true,
///   },
/// );
/// ```


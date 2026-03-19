# Changelog
All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog, and this project adheres to Semantic Versioning.

<!--
## [Unreleased]
### Added
- Module thông báo
### Changed
### Fixed
- Lỗi tạo thời gian cho `ngày bán` và `ngày hẹn giao` của đơn hàng
### Removed
-->

## [1.3.4] - 11/03/2026
### Added
- Added utility functions to handle numeric operations and mitigate floating-point precision issues ([floating error](https://stackoverflow.com/questions/57481767/dart-rounding-errors)).
- Added permission checks before rendering UI components.
- Added a feature to send print documents to the Local Server.
### Changed
- Updated currency formatting: "." is now used as the thousands separator and "," as the decimal separator.  
  Example: `10.000,5` = `10000.5`.  
  The previous currency format used the `en` locale and has been changed to `vi`.
### Fixed
- Fixed decimal number input issue on iOS.
- Fixed an issue where retail/wholesale prices were not updated for quotation items with quantity.
- Fixed an issue where collaborator information was not displayed in order details.

## [1.3.3] - 05/03/2026
### Added
- Add pull to refresh for details order.
- Add pull to refresh for details quotaion.
- Create collaborator information card on order details.
### Changed
- Center align customer information.
- Adjust button layout for Admin in details quotaion.
- Update UI of quantity dot for order line item.
- Update UI of measureUnit's tag selecter.
- Hide review mock UI.
### Fixed
- Error when adding a second "additional service".
- Missing a render case for shipper's name on order.
- Missing a render case for bank payment method on order.
- Missing customer address in quote details.
- Missing bankCode for payment infomation when create order.
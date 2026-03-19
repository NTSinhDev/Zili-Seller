# Memory Bank - Context Storage

Thư mục này chứa các file context để có thể import vào các chat mới và tiếp tục làm việc.

## 📁 Cấu trúc

```
memory-bank/
├── README.md                    # File này
├── 00-project-overview.md       # Tổng quan project
├── 01-architecture.md           # Kiến trúc hệ thống
├── 02-components.md             # Components chính
├── 03-development-process.md    # Quy trình phát triển
├── 04-api-documentation.md      # Tài liệu API
├── 05-progress-log.md           # Log tiến độ
└── notes/                       # Context theo feature
    ├── CONTEXT_TEMPLATE.md      # Template để tạo context mới
    └── product-variant-filter.md # Context về Product Variant Filter feature
```

## 🔄 Cách sử dụng

### Tự động với Cursor Rules

Cursor sẽ **tự động đọc tất cả Memory Bank files** khi bắt đầu mỗi task nhờ file `.cursor/rules/memory-bank.mdc`. Bạn không cần làm gì thêm!

### Manual Import (nếu cần)

Nếu muốn import context cụ thể từ `notes/`:

1. **Reference file trong chat**:
   ```
   Import context từ @memory-bank/notes/product-variant-filter.md và tiếp tục...
   ```

2. **Hoặc copy nội dung**:
   ```
   Đây là context từ chat trước:
   [paste nội dung file .md]
   
   Tiếp tục với: [mô tả task mới]
   ```

## 📝 Format Context File

Mỗi file context đại diện cho **1 đoạn chat**, chỉ ghi lại những gì đã thực hiện:

```markdown
# [Feature Name] - Context

## ✅ Đã thực hiện trong đoạn chat này
- Task 1: Tạo/sửa file X
- Task 2: Implement feature Y
- Task 3: ...

## 📁 Files đã tạo/sửa
- `path/to/file1.dart` - [Mô tả]
- `path/to/file2.dart` - [Mô tả]

## ⚠️ Lưu ý
- [Note quan trọng]

## 🔜 Chưa hoàn thành / Cần làm tiếp
- [ ] Task 1
- [ ] Task 2
```

## 🎯 Best Practices

1. **Cập nhật core files**: Cập nhật các file `00-05-*.md` sau mỗi thay đổi quan trọng
2. **Progress log**: Luôn ghi lại trong `05-progress-log.md` theo thứ tự thời gian
3. **Feature notes**: Tạo file trong `notes/` cho mỗi feature/chat session
4. **Keep it concise**: Giữ nội dung ngắn gọn, tập trung vào những gì đã làm
5. **Update regularly**: Cập nhật Memory Bank sau mỗi feature lớn hoặc architectural change

## 📚 Core Memory Files

- `00-project-overview.md` - Tổng quan project, tech stack, cấu trúc
- `01-architecture.md` - Kiến trúc Clean Architecture, design patterns
- `02-components.md` - Chi tiết các components chính
- `03-development-process.md` - Quy trình phát triển, testing, deployment
- `04-api-documentation.md` - Tài liệu API endpoints và authentication
- `05-progress-log.md` - Log tiến độ theo thời gian

## 📝 Feature Notes (notes/)

- `notes/select-products-screen.md` - SelectProductsScreen & Order Module integration
- `notes/product-variant-filter.md` - Product Variant Filter API integration
- `notes/CONTEXT_TEMPLATE.md` - Template để tạo context mới

## 📚 Documentation (docs/)

- `docs/middleware-guide.md` - Hướng dẫn về Middleware & Model pattern
- `docs/middleware-template.dart` - Template code để tạo Middleware nhanh
- `docs/model-template.dart` - Template code để tạo Model

## 📋 System Documents (documents/)

- `documents/list-screen-ui-pattern.md` - UI/UX pattern chung cho màn hình list với tabs, filter và search (tham khảo: `../../documents/list-screen-ui-pattern.md`)


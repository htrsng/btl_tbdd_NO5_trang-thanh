# SkinAI - Ứng dụng Phân tích Da bằng Flutter

SkinAI là một dự án ứng dụng di động được xây dựng bằng Flutter, với mục tiêu giúp người dùng hiểu rõ hơn về tình trạng da của mình thông qua việc phân tích hình ảnh và một bài khảo sát ngắn. Dựa trên kết quả, ứng dụng sẽ đưa ra các gợi ý được cá nhân hóa về sản phẩm và thói quen chăm sóc da.

## Ảnh chụp màn hình

| Màn hình Tải ảnh | Màn hình Khảo sát | Màn hình Kết quả |
| :---: | :---: | :---: |
| |
| **Màn hình Gợi ý** | **Màn hình Lịch sử** | **Màn hình Hồ sơ** |
| |

## Tính năng chính

- **Luồng Phân tích Đa bước:** Trải nghiệm người dùng được dẫn dắt qua 4 bước rõ ràng: Giới thiệu -> Tải ảnh -> Khảo sát -> Kết quả.
- **Tải ảnh Đa góc độ:** Giao diện camera tùy chỉnh cho phép người dùng tải lên 3 ảnh (trái, chính diện, phải). Hỗ trợ xem ảnh toàn màn hình và lướt qua lại.
- **Khảo sát Thông minh:** Một bài khảo sát gồm 5 câu hỏi để thu thập thông tin về lối sống và cảm nhận của người dùng. Kết quả `Loại da` được suy luận từ tất cả các câu trả lời.
- **Hiển thị Kết quả Chi tiết:**
    -   Hiển thị điểm số trung bình được tính toán từ các chỉ số phụ.
    -   Hiển thị loại da được cá nhân hóa.
    -   Lưới các chỉ số chi tiết (Mụn, Lỗ chân lông, Sắc tố, v.v.).
    -   Mục "teaser" cho các gợi ý cải thiện và sản phẩm.
    -   Tấm panel có thể kéo (`DraggableScrollableSheet`) để xem chi tiết.
-  **Gợi ý Cá nhân hóa:**
    -   Giao diện 3 tab: Thói quen, Sản phẩm, Lối sống.
    -   Điều hướng thông minh từ màn hình kết quả đến thẳng tab "Sản phẩm".
- **Lịch sử & Biểu đồ Tiến trình:**
    -   Hiển thị danh sách các lần phân tích cũ.
    -   Biểu đồ đường (`LineChart`) trực quan hóa sự thay đổi của điểm số da theo thời gian.
    -   Chức năng xem lại chi tiết, xóa từng mục hoặc xóa tất cả.
- **Quản lý Hồ sơ & Cài đặt:**
    -   Cho phép người dùng thay đổi ngôn ngữ (Anh/Việt) và chế độ Sáng/Tối.
    -   Lựa chọn được lưu lại cho các lần sử dụng sau.
- **Kiến trúc Vững chắc:**
    -   Sử dụng Riverpod để quản lý trạng thái một cách hiệu quả.
    -   Hỗ trợ đa ngôn ngữ đầy đủ thông qua `flutter_gen`.
    -   Hệ thống Theme nhất quán cho cả chế độ Sáng và Tối.

## Công nghệ sử dụng

-   **Framework:** Flutter
-   **Ngôn ngữ:** Dart
-   **Quản lý Trạng thái:** Riverpod
-   **Giao diện & UX:**
    -   `image_picker`: Chọn ảnh từ thư viện/camera.
    -   `fl_chart`: Vẽ biểu đồ đường.
    -   `lottie`: Hiển thị animation trong phần giới thiệu.
-   **Lưu trữ Cục bộ:** `shared_preferences` (dùng để lưu lựa chọn Ngôn ngữ và Theme).
-   **Model & Dữ liệu:** `json_serializable` & `build_runner` để tự động tạo code cho model.
-   **Đa ngôn ngữ (i18n):** `flutter_gen` và các file `.arb`.

## Cấu trúc thư mục
```
lib/
├── data/          # Chứa dữ liệu tĩnh
├── l10n/          # Chứa các file ngôn ngữ .arb
├── models/        # Định nghĩa các đối tượng dữ liệu 
├── providers/     # Chứa các State Notifier của Riverpod
├── screens/       # Chứa các màn hình chính và các bước 
├── utils/         # Chứa các file tiện ích (màu sắc,theme)
├── widgets/       # Chứa các widget có thể tái sử dụng
└── main.dart      # Điểm khởi đầu của ứng dụng
```


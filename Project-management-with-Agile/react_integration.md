# Báo cáo: Giải pháp tích hợp React vào dự án Spring Boot (Luxury PC)

Báo cáo này hướng dẫn chi tiết cách thức kết nối và tích hợp thư viện **React** làm Frontend cho dự án backend **Spring Boot** hiện tại.

---

## 1. Tổng quan kiến trúc (Architecture Overview)

Hiện tại, dự án đang chạy theo mô hình **Monolith** sử dụng **Thymeleaf** làm View Engine để render HTML trực tiếp từ phía Server. 

Khi chuyển sang sử dụng **React**, kiến trúc sẽ tách biệt rõ ràng thành mô hình **Client-Server**:
1. **Backend (Spring Boot):** Đóng vai trò là một **RESTful API Service**, chỉ xử lý nghiệp vụ, giao tiếp cơ sở dữ liệu và trả về dữ liệu thuần dạng JSON (thay vì trả về view HTML).
2. **Frontend (React):** Hoạt động như một **SPA (Single Page Application)** chạy trên trình duyệt client, gửi yêu cầu (HTTP Request) tới Backend để lấy dữ liệu JSON và tự động render giao diện cho người dùng.

---

## 2. Cách thức kết nối giữa React và Spring Boot

Để React và Spring Boot kết nối thành công, hệ thống cần đáp ứng 3 yếu tố kỹ thuật cốt lõi sau:

### 2.1 Cấu hình CORS (Cross-Origin Resource Sharing)
Mặc định, trình duyệt chặn các yêu cầu gọi API từ một cổng khác (ví dụ: React chạy ở `http://localhost:5173` gọi tới Spring Boot ở `http://localhost:8080`). Backend Spring Boot cần cho phép nguồn (Origin) của React truy cập.

### 2.2 Đổi sang `@RestController` thay vì `@Controller`
Các Controller của Spring Boot sẽ sử dụng `@RestController` để tự động chuyển hóa các đối tượng trả về (Entity/DTO) thành chuỗi JSON thay vì tìm kiếm file HTML Thymeleaf.

### 2.3 Bảo mật & Xác thực (Authentication)
* **Giải pháp Session cũ (Cookie):** React vẫn có thể sử dụng Session bằng cách cấu hình thuộc tính `credentials: 'include'` khi gửi fetch/axios để trình duyệt tự đính kèm Cookie Session.
* **Giải pháp JWT (Khuyên dùng):** Sử dụng **JSON Web Token (JWT)**. Khi đăng nhập thành công, Spring Boot trả về 1 chuỗi Token. React lưu token này ở `localStorage` hoặc `cookie` và đính kèm vào Header `Authorization: Bearer <Token>` trong các lượt gọi API tiếp theo.

---

## 3. Ví dụ thực tế (Code Example)

Dưới đây là ví dụ hoàn chỉnh về tính năng hiển thị danh sách sản phẩm kết nối giữa Spring Boot (Backend) và React (Frontend).

### 3.1 Phía Backend (Spring Boot Controller)

Tạo một `@RestController` tại package `poly.edu.controller` để cung cấp API lấy sản phẩm:

```java
package poly.edu.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import poly.edu.entity.Product;
import poly.edu.service.ProductService;
import java.util.List;

@RestController
@RequestMapping("/api/v1")
// Cho phép React Server (Vite) ở cổng 5173 gọi API
@CrossOrigin(origins = "http://localhost:5173") 
public class ProductApiController {

    @Autowired
    private ProductService productService;

    // Endpoint: GET http://localhost:8080/api/v1/products
    @GetMapping("/products")
    public List<Product> getAllProducts() {
        return productService.getAllProducts(); 
        // Spring Boot tự chuyển List<Product> thành JSON array
    }
}
```

### 3.2 Phía Frontend (React Component - JSX)

Trong ứng dụng React, ta gọi API bằng `fetch` hoặc `axios` để lấy danh sách sản phẩm và hiển thị lên giao diện:

```jsx
import React, { useState, useEffect } from 'react';

function ProductList() {
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // Gọi API khi component được mount
  useEffect(() => {
    fetch('http://localhost:8080/api/v1/products')
      .then((response) => {
        if (!response.ok) {
          throw new Error('Không thể tải dữ liệu sản phẩm');
        }
        return response.json(); // Chuyển phản hồi JSON thành Object
      })
      .then((data) => {
        setProducts(data);
        setLoading(false);
      })
      .catch((err) => {
        setError(err.message);
        setLoading(false);
      });
  }, []);

  if (loading) return <div className="loader">Đang tải sản phẩm...</div>;
  if (error) return <div className="error">Lỗi: {error}</div>;

  return (
    <div className="product-container" style={{ padding: '2rem' }}>
      <h2>Danh sách sản phẩm (Kết nối React - Spring Boot)</h2>
      <div className="product-grid" style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: '1.5rem' }}>
        {products.map((product) => (
          <div key={product.id} className="product-card" style={{ border: '1px solid #c9a84c', padding: '1rem' }}>
            <img src={product.image || '/placeholder.png'} alt={product.name} style={{ width: '100%' }} />
            <h3>{product.name}</h3>
            <p style={{ color: '#c9a84c', fontWeight: 'bold' }}>
              {product.price.toLocaleString('vi-VN')}₫
            </p>
            <p>{product.description}</p>
          </div>
        ))}
      </div>
    </div>
  );
}

export default ProductList;
```

---

## 4. Phương án triển khai & Vận hành (Deployment Options)

Khi tích hợp React vào dự án Spring Boot, có hai phương án chính để deploy:

| Tiêu chí | Phương án 1: Tách biệt hoàn toàn (Decoupled) | Phương án 2: Đóng gói chung (Integrated Monolith) |
| :--- | :--- | :--- |
| **Cách chạy** | React deploy trên host tĩnh (Vercel, Netlify). <br>Spring Boot deploy trên VPS/Cloud (AWS, Heroku). | Build React thành các file tĩnh (`index.html`, `js`, `css`) rồi copy vào thư mục `src/main/resources/static/` của Spring Boot. |
| **Lợi ích** | - Team Frontend & Backend làm việc độc lập.<br>- Dễ scale phần front-end riêng biệt.<br>- Tránh tải nặng cho server Java. | - Chỉ cần quản lý 1 server duy nhất.<br>- Deploy ra 1 file `.jar` chạy trực tiếp.<br>- Không lo ngại về lỗi CORS. |
| **Nhược điểm** | - Phải cấu hình CORS và bảo mật JWT.<br>- Quản lý 2 hosting riêng biệt. | - Thời gian build lâu hơn (phải chạy build JS trước khi build Java).<br>- Tốn tài nguyên server khi tải lượng lớn file tĩnh. |

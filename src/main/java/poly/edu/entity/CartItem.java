package poly.edu.entity;

import java.io.Serializable;

public class CartItem implements Serializable {
    private Integer id;
    private String name;
    private Double price;
    private Integer quantity;
    private String image;
    private Integer stock;

    // 1. Constructor KHÔNG tham số (Bắt buộc để tránh lỗi 'is not applicable')
    public CartItem() {
    }

    // 2. Constructor 4 tham số
    public CartItem(Integer id, String name, Double price, Integer quantity) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.quantity = quantity;
    }

    // 3. Các Getter và Setter chuẩn
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public Double getPrice() { return price; }
    public void setPrice(Double price) { this.price = price; }

    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public Integer getStock() { return stock; }
    public void setStock(Integer stock) { this.stock = stock; }

    /**
     * Phương thức bổ trợ tính tổng tiền cho từng dòng sản phẩm
     * Giúp hiển thị dữ liệu ở trang Checkout mượt mà hơn
     */
    public Double getAmount() {
        if (this.price == null || this.quantity == null) {
            return 0.0;
        }
        return this.price * this.quantity;
    }
}

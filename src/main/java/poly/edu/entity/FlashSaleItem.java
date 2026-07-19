package poly.edu.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "flash_sale_items")
public class FlashSaleItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "flash_sale_id")
    private FlashSale flashSale;

    @ManyToOne
    @JoinColumn(name = "product_id")
    private Product product;

    @Column(name = "sale_price")
    private Double salePrice;

    @Column(name = "sale_quantity")
    private Integer saleQuantity;

    @Column(name = "sold_count")
    private Integer soldCount = 0;

    public FlashSaleItem() {
    }

    public FlashSaleItem(Integer id, FlashSale flashSale, Product product, Double salePrice, Integer saleQuantity, Integer soldCount) {
        this.id = id;
        this.flashSale = flashSale;
        this.product = product;
        this.salePrice = salePrice;
        this.saleQuantity = saleQuantity;
        this.soldCount = soldCount;
    }

    @PrePersist
    protected void onCreate() {
        if (this.soldCount == null) this.soldCount = 0;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public FlashSale getFlashSale() {
        return flashSale;
    }

    public void setFlashSale(FlashSale flashSale) {
        this.flashSale = flashSale;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public Double getSalePrice() {
        return salePrice;
    }

    public void setSalePrice(Double salePrice) {
        this.salePrice = salePrice;
    }

    public Integer getSaleQuantity() {
        return saleQuantity;
    }

    public void setSaleQuantity(Integer saleQuantity) {
        this.saleQuantity = saleQuantity;
    }

    public Integer getSoldCount() {
        return soldCount;
    }

    public void setSoldCount(Integer soldCount) {
        this.soldCount = soldCount;
    }

    /**
     * Phần trăm giảm giá so với giá gốc
     */
    public int getDiscountPercent() {
        if (product == null || product.getPrice() == null || product.getPrice() == 0 || salePrice == null) return 0;
        return (int) Math.round((1 - salePrice / product.getPrice()) * 100);
    }

    /**
     * Phần trăm đã bán
     */
    public int getSoldPercent() {
        if (saleQuantity == null || saleQuantity == 0 || soldCount == null) return 0;
        return Math.min(100, (int) Math.round((double) soldCount / saleQuantity * 100));
    }

    /**
     * Còn hàng sale không
     */
    public boolean isAvailable() {
        if (saleQuantity == null || soldCount == null) return false;
        return soldCount < saleQuantity;
    }
}

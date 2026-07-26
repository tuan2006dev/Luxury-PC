package poly.edu.service;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import poly.edu.dao.ProductDAO;
import poly.edu.entity.Product;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ProductService {

    final ProductDAO productDAO;

    public List<Product> getAllProducts() {
        return productDAO.findAll();
    }

    public org.springframework.data.domain.Page<Product> getProductsPage(String keyword, int page, int size) {
        org.springframework.data.domain.Pageable pageable = org.springframework.data.domain.PageRequest.of(page, size);
        if (keyword != null && !keyword.trim().isEmpty()) {
            return productDAO.findByNameContainingIgnoreCase(keyword.trim(), pageable);
        }
        return productDAO.findAllWithCategory(pageable);
    }

    @Cacheable("topProducts")
    public List<Product> getTopProducts(int limit) {
        return productDAO.findTopProducts(org.springframework.data.domain.PageRequest.of(0, limit));
    }

    @Cacheable("featuredProducts")
    public List<Product> getFeaturedProducts() {
        return productDAO.findFeaturedProducts(org.springframework.data.domain.PageRequest.of(0, 20));
    }

    @Cacheable("flashSaleProducts")
    public List<Product> getFlashSaleProducts() {
        return productDAO.findFlashSaleProducts();
    }

    // Đã cập nhật lại tên hàm gọi sang DAO khớp với bước trước
    public List<Product> getProductsByCategory(Integer categoryId) {
        return productDAO.findByCategoryIdAndImageIsNotNull(categoryId);
    }


    public Product getProductById(Integer id) {
        return productDAO.findById(id).orElse(null);
    }

    public List<Product> searchProducts(Integer cid, Double min, Double max, String kw, String brand) {
        return productDAO.searchProducts(cid, min, max, kw, brand, org.springframework.data.domain.PageRequest.of(0, 100)); // Limit to top 100 for performance
    }

    @CacheEvict(value = {"featuredProducts", "flashSaleProducts", "topProducts"}, allEntries = true)
    @Transactional
    public Product saveProduct(Product product) {
        return productDAO.save(product);
    }

    @CacheEvict(value = {"featuredProducts", "flashSaleProducts", "topProducts"}, allEntries = true)
    @Transactional
    public void deleteProduct(Integer id) {
        productDAO.deleteCartItemsByProductId(id);
        productDAO.deleteWishlistItemsByProductId(id);
        productDAO.deleteFlashSaleItemsByProductId(id);
        productDAO.deleteReviewsByProductId(id);
        productDAO.deleteInventoryByProductId(id);
        productDAO.deleteStockMovementsByProductId(id);
        productDAO.deleteComboDetailsByProductId(id);
        productDAO.unlinkOrderItemsByProductId(id);
        
        try {
            productDAO.deleteById(id);
        } catch (org.springframework.dao.DataIntegrityViolationException e) {
            throw new RuntimeException("Sản phẩm đã được mua trong đơn hàng và không thể xóa để bảo toàn dữ liệu lịch sử!");
        }
    }

}


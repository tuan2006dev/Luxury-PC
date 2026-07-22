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

    public List<String> getAllBrands() {
        return productDAO.findDistinctBrands();
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

    public org.springframework.data.domain.Page<Product> searchProducts(Integer cid, Double min, Double max, String kw, String brand, int page, int size, String sortType) {
        org.springframework.data.domain.Sort sortObj;
        if (sortType == null) sortType = "newest";
        switch (sortType) {
            case "price_asc": sortObj = org.springframework.data.domain.Sort.by("price").ascending(); break;
            case "price_desc": sortObj = org.springframework.data.domain.Sort.by("price").descending(); break;
            case "name_asc": sortObj = org.springframework.data.domain.Sort.by("name").ascending(); break;
            case "name_desc": sortObj = org.springframework.data.domain.Sort.by("name").descending(); break;
            case "newest": 
            default: sortObj = org.springframework.data.domain.Sort.by("createdAt").descending(); break;
        }
        return productDAO.searchProducts(cid, min, max, kw, brand, org.springframework.data.domain.PageRequest.of(page, size, sortObj)); 
    }

    public org.springframework.data.domain.Page<Product> searchProductsInFlashSale(List<Integer> flashSaleIds, Integer cid, Double min, Double max, String kw, String brand, int page, int size, String sortType) {
        if (flashSaleIds == null || flashSaleIds.isEmpty()) {
            return org.springframework.data.domain.Page.empty();
        }
        org.springframework.data.domain.Sort sortObj;
        if (sortType == null) sortType = "newest";
        switch (sortType) {
            case "price_asc": sortObj = org.springframework.data.domain.Sort.by("price").ascending(); break;
            case "price_desc": sortObj = org.springframework.data.domain.Sort.by("price").descending(); break;
            case "name_asc": sortObj = org.springframework.data.domain.Sort.by("name").ascending(); break;
            case "name_desc": sortObj = org.springframework.data.domain.Sort.by("name").descending(); break;
            case "newest": 
            default: sortObj = org.springframework.data.domain.Sort.by("createdAt").descending(); break;
        }
        return productDAO.searchProductsInFlashSale(flashSaleIds, cid, min, max, kw, brand, org.springframework.data.domain.PageRequest.of(page, size, sortObj)); 
    }

    @CacheEvict(value = {"featuredProducts", "flashSaleProducts", "topProducts"}, allEntries = true)
    @Transactional
    public Product saveProduct(Product product) {
        return productDAO.save(product);
    }

    @CacheEvict(value = {"featuredProducts", "flashSaleProducts", "topProducts"}, allEntries = true)
    @Transactional
    public void deleteProduct(Integer id) {
        productDAO.deleteById(id);
    }

}


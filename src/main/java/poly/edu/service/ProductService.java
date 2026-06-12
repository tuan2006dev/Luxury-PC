package poly.edu.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import poly.edu.dao.ProductDAO;
import poly.edu.entity.Product;

import java.util.List;

@Service
public class ProductService {

    @Autowired
    ProductDAO productDAO;

    public List<Product> getAllProducts() {
        return productDAO.findAll();
    }

    public List<Product> getFeaturedProducts() {
        return productDAO.findFeaturedProducts();
    }

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

    public List<Product> searchProducts(Integer cid, Double min, Double max, String kw) {
        return productDAO.searchProducts(cid, min, max, kw);
    }

    @Transactional
    public Product saveProduct(Product product) {
        return productDAO.save(product);
    }

    @Transactional
    public void deleteProduct(Integer id) {
        productDAO.deleteById(id);
    }

}


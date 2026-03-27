package poly.edu.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
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

    public List<Product> getProductsByCategory(Integer categoryId) {
        return productDAO.findByCategoryId(categoryId);
    }

<<<<<<< Updated upstream
}
=======
    public Product getProductById(Integer id) {
        return productDAO.findById(id).orElse(null);
    }

    public List<Product> searchProducts(Integer cid, Double min, Double max, String kw) {
        return productDAO.searchProducts(cid, min, max, kw);
    }

}
>>>>>>> Stashed changes

package poly.edu.controller.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import poly.edu.entity.Product;
import poly.edu.service.ProductService;

import java.util.List;
import java.util.stream.Collectors;

@RestController
public class TestDB {

    @Autowired
    private ProductService productService;

    @GetMapping("/testdb")
    public String test() {
        try {
            List<Product> list = productService.getAllProducts();
            StringBuilder sb = new StringBuilder();
            for(Product p : list) {
                sb.append(p.getId()).append(" | ").append(p.getName()).append(" | ").append(p.getImage()).append("\n");
            }
            return sb.toString();
        } catch (Exception e) {
            return "Connection Failed: " + e.getMessage();
        }
    }
}
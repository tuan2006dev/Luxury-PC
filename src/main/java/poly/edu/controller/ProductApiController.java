package poly.edu.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import poly.edu.entity.Product;
import poly.edu.service.ProductService;

import java.util.*;
import java.util.stream.Collectors;

@RestController
@CrossOrigin(origins = "*") // Allow React to connect seamlessly
public class ProductApiController {

    @Autowired
    private ProductService productService;

    @GetMapping("/api/products")
    public List<Map<String, Object>> getProducts() {
        return productService.getAllProducts().stream().map(p -> {
            Map<String, Object> map = new HashMap<>();
            map.put("id", p.getId());
            map.put("name", p.getName());
            
            String categoryName = "Linh Kiện";
            if (p.getCategory() != null && p.getCategory().getName() != null) {
                categoryName = p.getCategory().getName();
            }
            map.put("cat", categoryName);
            
            double price = p.getPrice() != null ? p.getPrice() : 0.0;
            map.put("price", String.format("%,.0f₫", price).replace(',', '.'));
            
            // Generate icon based on category loosely
            String icon = "📦";
            String catLow = categoryName.toLowerCase();
            if (catLow.contains("cpu")) icon = "🖥️";
            else if (catLow.contains("vga") || catLow.contains("card")) icon = "🎮";
            else if (catLow.contains("ram")) icon = "🧠";
            else if (catLow.contains("main") || catLow.contains("bo mạch")) icon = "⚙️";
            else if (catLow.contains("ssd") || catLow.contains("hdd")) icon = "💾";
            else if (catLow.contains("màn") || catLow.contains("monitor")) icon = "📺";
            else if (catLow.contains("nguồn") || catLow.contains("psu")) icon = "⚡";
            
            map.put("icon", icon);
            return map;
        }).collect(Collectors.toList());
    }
}

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
            // URL để điều hướng đến trang chi tiết sản phẩm
            map.put("productUrl", "/product/" + p.getId());
            
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

    /**
     * API: Get categorized products for 3D PC Builder
     * Fetches from Supabase database and parses them into Case, Mainboard, CPU, GPU, RAM, PSU categories.
     */
    @GetMapping("/api/build/components")
    public Map<String, List<Map<String, Object>>> getBuildComponents() {
        Map<String, List<Map<String, Object>>> result = new HashMap<>();
        for (String cat : new String[]{"CASE", "MAINBOARD", "CPU", "COOLER", "RAM", "GPU", "PSU", "MONITOR", "KEYBOARD", "MOUSE"}) {
            result.put(cat, new ArrayList<>());
        }

        List<Product> dbProducts = productService.getAllProducts();
        for (Product p : dbProducts) {
            if (p == null || p.getName() == null) continue;
            
            String dbCatName = p.getCategory() != null ? p.getCategory().getName().toLowerCase() : "";
            String pName = p.getName().toLowerCase();
            String matchedCat = null;

            if (dbCatName.contains("case") || dbCatName.contains("vỏ") || pName.contains("vỏ case") || pName.contains("case ")) {
                matchedCat = "CASE";
            } else if (dbCatName.contains("main") || dbCatName.contains("bo mạch") || pName.contains("mainboard") || pName.contains("main ")) {
                matchedCat = "MAINBOARD";
            } else if (dbCatName.contains("cpu") || dbCatName.contains("vi xử lý") || pName.contains("intel") || pName.contains("ryzen") || pName.contains("core i")) {
                matchedCat = "CPU";
            } else if (dbCatName.contains("tản") || dbCatName.contains("cooler") || dbCatName.contains("fan") || pName.contains("tản nhiệt") || pName.contains("aio")) {
                matchedCat = "COOLER";
            } else if (dbCatName.contains("ram") || pName.contains("ram ") || pName.contains("ddr5") || pName.contains("ddr4")) {
                matchedCat = "RAM";
            } else if (dbCatName.contains("vga") || dbCatName.contains("card") || dbCatName.contains("đồ họa") || pName.contains("nvidia") || pName.contains("radeon") || pName.contains("rtx") || pName.contains("gtx") || pName.contains("rx ")) {
                matchedCat = "GPU";
            } else if (dbCatName.contains("nguồn") || dbCatName.contains("psu") || pName.contains("nguồn ") || pName.contains("psu ")) {
                matchedCat = "PSU";
            } else if (dbCatName.contains("màn") || dbCatName.contains("monitor") || pName.contains("màn hình") || pName.contains("monitor")) {
                matchedCat = "MONITOR";
            } else if (dbCatName.contains("phím") || dbCatName.contains("keyboard") || pName.contains("bàn phím") || pName.contains("keyboard")) {
                matchedCat = "KEYBOARD";
            } else if (dbCatName.contains("chuột") || dbCatName.contains("mouse") || pName.contains("chuột ") || pName.contains("mouse")) {
                matchedCat = "MOUSE";
            }

            if (matchedCat != null) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", String.valueOf(p.getId()));
                map.put("name", p.getName());
                map.put("price", p.getPrice() != null ? p.getPrice().intValue() : 0);
                map.put("spec", p.getDescription() != null && !p.getDescription().isEmpty() ? p.getDescription() : "Linh kiện chính hãng");
                
                String imageUrl = p.getImage();
                if (imageUrl != null && !imageUrl.isEmpty()) {
                    if (!imageUrl.startsWith("http")) {
                        imageUrl = "/images/products/" + imageUrl;
                    }
                    map.put("image", imageUrl);
                } else {
                    map.put("image", "/images/placeholder.png");
                }
                
                // Color and sizes based on category
                String color = "#c9a84c";
                List<Double> size = Arrays.asList(0.5, 0.5, 0.5);
                List<Double> pos = Arrays.asList(0.0, 0.0, 0.0);
                
                if (matchedCat.equals("CASE")) {
                    color = p.getName().toLowerCase().contains("white") ? "#eaeaea" : "#1a1a1a";
                    size = Arrays.asList(4.0, 5.0, 4.5);
                } else if (matchedCat.equals("MAINBOARD")) {
                    color = "#1c1e24";
                    size = Arrays.asList(2.5, 3.2, 0.15);
                } else if (matchedCat.equals("CPU")) {
                    color = p.getName().toLowerCase().contains("intel") ? "#0071c5" : "#f35c00";
                    size = Arrays.asList(0.6, 0.6, 0.1);
                    pos = Arrays.asList(-0.2, 0.5, 0.1);
                } else if (matchedCat.equals("COOLER")) {
                    color = "#333333";
                    size = Arrays.asList(0.9, 0.9, 0.4);
                    pos = Arrays.asList(-0.2, 0.5, 0.45);
                } else if (matchedCat.equals("RAM")) {
                    color = "#c9a84c";
                    size = Arrays.asList(0.1, 1.2, 0.3);
                    pos = Arrays.asList(0.4, 0.5, 0.2);
                } else if (matchedCat.equals("GPU")) {
                    color = "#444444";
                    size = Arrays.asList(0.8, 2.5, 0.7);
                    pos = Arrays.asList(0.1, -0.6, 0.6);
                } else if (matchedCat.equals("PSU")) {
                    color = "#111111";
                    size = Arrays.asList(1.8, 1.2, 1.5);
                    pos = Arrays.asList(0.0, -2.1, -1.2);
                } else if (matchedCat.equals("MONITOR")) {
                    color = "#111111";
                    size = Arrays.asList(6.2, 3.2, 0.4);
                    pos = Arrays.asList(-2.0, 0.6, -0.4);
                } else if (matchedCat.equals("KEYBOARD")) {
                    color = "#1a1a1a";
                    size = Arrays.asList(1.4, 0.08, 0.55);
                    pos = Arrays.asList(-2.0, -2.75, 1.8);
                } else if (matchedCat.equals("MOUSE")) {
                    color = "#111111";
                    size = Arrays.asList(0.22, 0.12, 0.38);
                    pos = Arrays.asList(-0.6, -2.75, 1.8);
                }
                
                map.put("color", color);
                map.put("size", size);
                map.put("pos", pos);
                
                result.get(matchedCat).add(map);
            }
        }
        
        // Add fallback items if a category is empty in DB
        Map<String, List<Map<String, Object>>> fallbackData = getFallbackComponents();
        for (String cat : result.keySet()) {
            if (result.get(cat).isEmpty()) {
                result.put(cat, fallbackData.get(cat));
            }
        }
        
        return result;
    }

    private Map<String, List<Map<String, Object>>> getFallbackComponents() {
        Map<String, List<Map<String, Object>>> fallback = new HashMap<>();
        
        // CASE
        List<Map<String, Object>> cases = new ArrayList<>();
        cases.add(createItem("case_lianli", "Lian Li O11 Dynamic EVO", 4500000, "Mid Tower | Kính cường lực kép", "#1a1a1a", Arrays.asList(4.0, 5.0, 4.5), null, "https://images.unsplash.com/photo-1587202372775-e229f172b9d7?q=80&w=200"));
        cases.add(createItem("case_corsair", "Corsair 5000D Airflow White", 3900000, "Mid Tower | Mặt thép thông thoáng", "#eaeaea", Arrays.asList(4.0, 5.2, 4.8), null, "https://images.unsplash.com/photo-1624705002806-5d72df19c3ad?q=80&w=200"));
        fallback.put("CASE", cases);
        
        // MAINBOARD
        List<Map<String, Object>> mainboards = new ArrayList<>();
        mainboards.add(createItem("main_asus", "ASUS ROG Maximus Z790 Hero", 18500000, "LGA 1700 | DDR5 | PCIe 5.0", "#1c1e24", Arrays.asList(2.5, 3.2, 0.15), null, "https://images.unsplash.com/photo-1555664424-778a1e5e1b48?q=80&w=200"));
        fallback.put("MAINBOARD", mainboards);
        
        // CPU
        List<Map<String, Object>> cpus = new ArrayList<>();
        cpus.add(createItem("cpu_i9", "Intel Core i9-14900K", 14500000, "24 Cores | 32 Threads | Up to 6.0GHz", "#0071c5", Arrays.asList(0.6, 0.6, 0.1), Arrays.asList(-0.2, 0.5, 0.1), "https://images.unsplash.com/photo-1591488320449-011701bb6704?q=80&w=200"));
        cpus.add(createItem("cpu_r9", "AMD Ryzen 9 7950X3D", 15200000, "16 Cores | 32 Threads | 3D V-Cache", "#f35c00", Arrays.asList(0.6, 0.6, 0.1), Arrays.asList(-0.2, 0.5, 0.1), "https://images.unsplash.com/photo-1591488320449-011701bb6704?q=80&w=200"));
        fallback.put("CPU", cpus);
        
        // COOLER
        List<Map<String, Object>> coolers = new ArrayList<>();
        coolers.add(createItem("cooler_nzxt", "NZXT Kraken Elite 360 RGB", 7800000, "AIO Liquid | Màn hình LCD 2.36\"", "#333333", Arrays.asList(0.9, 0.9, 0.4), Arrays.asList(-0.2, 0.5, 0.45), "https://images.unsplash.com/photo-1616348436168-de43ad0db179?q=80&w=200"));
        fallback.put("COOLER", coolers);
        
        // RAM
        List<Map<String, Object>> rams = new ArrayList<>();
        rams.add(createItem("ram_gskill", "G.Skill Trident Z5 RGB 32GB", 3800000, "DDR5 6400MHz | 2x16GB", "#c9a84c", Arrays.asList(0.1, 1.2, 0.3), Arrays.asList(0.4, 0.5, 0.2), "https://images.unsplash.com/photo-1562976540-1502c2145186?q=80&w=200"));
        fallback.put("RAM", rams);
        
        // GPU
        List<Map<String, Object>> gpus = new ArrayList<>();
        gpus.add(createItem("gpu_4090", "NVIDIA RTX 4090 Founders Edition", 54900000, "24GB GDDR6X | DLSS 3.0", "#444444", Arrays.asList(0.8, 2.5, 0.7), Arrays.asList(0.1, -0.6, 0.6), "https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?q=80&w=200"));
        fallback.put("GPU", gpus);
        
        // PSU
        List<Map<String, Object>> psus = new ArrayList<>();
        psus.add(createItem("psu_seasonic", "Seasonic Prime TX-1300W Gold", 9500000, "1300W | 80 Plus Titanium", "#111111", Arrays.asList(1.8, 1.2, 1.5), Arrays.asList(0.0, -2.1, -1.2), "https://images.unsplash.com/photo-1591488320449-011701bb6704?q=80&w=200"));
        fallback.put("PSU", psus);
        
        // MONITOR
        List<Map<String, Object>> monitors = new ArrayList<>();
        monitors.add(createItem("mon_asus_rog_49", "ASUS ROG Swift OLED PG49WCD", 38900000, "49\" Curved | DQHD 144Hz | 0.03ms OLED", "#111111", Arrays.asList(6.2, 3.2, 0.4), Arrays.asList(-2.0, 0.6, -0.4), "https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?q=80&w=200"));
        monitors.add(createItem("mon_samsung_g9", "Samsung Odyssey Neo G9", 42500000, "49\" Mini-LED | Dual QHD 240Hz | Curved", "#f0f0f0", Arrays.asList(6.2, 3.2, 0.5), Arrays.asList(-2.0, 0.6, -0.4), "https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?q=80&w=200"));
        fallback.put("MONITOR", monitors);
 
        // KEYBOARD
        List<Map<String, Object>> keyboards = new ArrayList<>();
        keyboards.add(createItem("kb_corsair_k100", "Corsair K100 RGB Optical-Mechanical", 6200000, "Fullsize | Corsair OPX switches | PBT", "#1a1a1a", Arrays.asList(1.4, 0.08, 0.55), Arrays.asList(-2.0, -2.75, 1.8), "https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?q=80&w=200"));
        keyboards.add(createItem("kb_asus_azoth", "ASUS ROG Azoth OLED Wireless", 5900000, "75% Gasket mount | Hot-swappable | OLED", "#2e2e2e", Arrays.asList(1.4, 0.08, 0.55), Arrays.asList(-2.0, -2.75, 1.8), "https://images.unsplash.com/photo-1587829741301-dc798b83add3?q=80&w=200"));
        fallback.put("KEYBOARD", keyboards);
 
        // MOUSE
        List<Map<String, Object>> mice = new ArrayList<>();
        mice.add(createItem("mouse_gpro_superlight", "Logitech G Pro X Superlight 2", 3800000, "Wireless | 60g Lightweight | Hero 2 Sensor", "#111111", Arrays.asList(0.22, 0.12, 0.38), Arrays.asList(-0.6, -2.75, 1.8), "https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?q=80&w=200"));
        mice.add(createItem("mouse_razer_basilisk", "Razer Basilisk V3 Pro White", 4200000, "Wireless | Focus Pro 30K | Chroma RGB", "#e8e8e8", Arrays.asList(0.24, 0.14, 0.4), Arrays.asList(-0.6, -2.75, 1.8), "https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?q=80&w=200"));
        fallback.put("MOUSE", mice);
        
        return fallback;
    }
    
    private Map<String, Object> createItem(String id, String name, int price, String spec, String color, List<Double> size, List<Double> pos, String image) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", id);
        map.put("name", name);
        map.put("price", price);
        map.put("spec", spec);
        map.put("color", color);
        map.put("size", size);
        if (pos != null) {
            map.put("pos", pos);
        }
        map.put("image", image != null ? image : "/images/placeholder.png");
        return map;
    }
}

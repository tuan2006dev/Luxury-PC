package poly.edu.controller.web;

import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import poly.edu.dao.ProductDAO;
import poly.edu.entity.Product;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import poly.edu.dao.PcComboDAO;
import poly.edu.entity.PcCombo;

@Controller
@RequiredArgsConstructor
public class BuildPcController {

    private static final Logger log = LoggerFactory.getLogger(BuildPcController.class);

    private final ProductDAO productDAO;

    private final PcComboDAO pcComboDAO;

    @GetMapping("/build-pc")
    public String buildPc(Model model) {
        List<Product> allProducts = productDAO.findAll();
        List<PcCombo> combos = pcComboDAO.findAll();
        model.addAttribute("combos", combos);
        
        // Group products by category name for the frontend JS to use
        Map<String, List<Map<String, Object>>> productsData = new HashMap<>();
        
        String[] categories = {"CPU", "Mainboard", "RAM", "VGA", "Storage", "PSU", "Case", "Cooling"};
        
        for (String cat : categories) {
            List<Map<String, Object>> catProducts = allProducts.stream()
                .filter(p -> {
                    if (p.getCategory() == null || p.getCategory().getName() == null) return false;
                    String cName = p.getCategory().getName().toLowerCase();
                    String tCat = cat.toLowerCase();
                    if (cName.equals(tCat)) return true;
                    if (tCat.equals("vga") && (cName.contains("gpu") || cName.contains("vga") || cName.contains("card"))) return true;
                    if (tCat.equals("storage") && (cName.contains("ssd") || cName.contains("hdd") || cName.contains("storage") || cName.contains("ổ cứng"))) return true;
                    if (tCat.equals("psu") && (cName.contains("psu") || cName.contains("nguồn") || cName.contains("nguon"))) return true;
                    if (tCat.equals("case") && (cName.contains("case") || cName.contains("vỏ"))) return true;
                    if (tCat.equals("cooling") && (cName.contains("cool") || cName.contains("tản") || cName.contains("fan"))) return true;
                    if (tCat.equals("mainboard") && (cName.contains("main") || cName.contains("bo mạch"))) return true;
                    return false;
                })
                .map(p -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("id", p.getId());
                    map.put("name", p.getName());
                    map.put("price", p.getPrice());
                    String imgPath = p.getImage();
                    if (imgPath != null && !imgPath.startsWith("http") && !imgPath.startsWith("/images/")) {
                        imgPath = "/images/products/" + imgPath;
                    }
                    map.put("img", imgPath);
                    
                    // Parse power from description if available (e.g. "TDP: 125W")
                    int power = 0;
                    if (p.getDescription() != null && p.getDescription().contains("TDP:")) {
                        try {
                            String powStr = p.getDescription().replaceAll("[^0-9]", "");
                            if(!powStr.isEmpty()) power = Integer.parseInt(powStr);
                        } catch (NumberFormatException e) {
                            // Non-critical: product description has no parseable TDP value; defaulting to 0
                            log.debug("Could not parse TDP from description for product id={}: {}", p.getId(), e.getMessage());
                        }
                    }
                    map.put("power", power);
                    map.put("description", p.getDescription());
                    return map;
                })
                .collect(Collectors.toList());
            String jsCat = cat.toLowerCase();
            if (jsCat.equals("storage")) {
                jsCat = "ssd";
            }
            productsData.put(jsCat, catProducts);
        }
        
        List<Map<String, Object>> combosData = combos.stream().map(c -> {
            Map<String, Object> cMap = new HashMap<>();
            cMap.put("id", c.getId());
            cMap.put("price", c.getPrice());
            cMap.put("name", c.getName());
            cMap.put("description", c.getDescription());
            
            // Generate combo saving for display
            cMap.put("saving", 500000); // Fixed saving for now, or could compute
            
            Map<String, Integer> details = new HashMap<>();
            if (c.getDetails() != null) {
                c.getDetails().forEach(d -> {
                    if (d.getProduct() != null) {
                        details.put(d.getSlotType(), d.getProduct().getId());
                    }
                });
            }
            cMap.put("details", details);
            return cMap;
        }).collect(Collectors.toList());

        model.addAttribute("productsData", productsData);
        model.addAttribute("combosData", combosData);
        
        return "build-pc";
    }
}

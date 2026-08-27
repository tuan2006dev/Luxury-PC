package poly.edu.config;

import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import poly.edu.dao.CategoryDAO;
import poly.edu.dao.ProductDAO;
import poly.edu.entity.Category;
import poly.edu.entity.Product;

import java.util.Date;
import java.util.List;

@Component
@RequiredArgsConstructor
public class BuildPcDataSeeder implements CommandLineRunner {

    private static final Logger log = LoggerFactory.getLogger(BuildPcDataSeeder.class);

    private final CategoryDAO categoryDAO;

    private final ProductDAO productDAO;

    private final poly.edu.dao.PcComboDAO comboDAO;

    private final poly.edu.dao.PcComboDetailDAO comboDetailDAO;

    @Override
    public void run(String... args) throws Exception {
        log.info("[BuildPcDataSeeder] Checking and seeding Build PC data...");
        
        try {
            // SQL Server uses IDENTITY for auto-increment, no need for setval.
        } catch (Exception e) {
            log.warn("[BuildPcDataSeeder] Could not reset DB sequences: {}", e.getMessage());
        }

        // Ensure categories exist
        String[] categoryNames = {"CPU", "Mainboard", "RAM", "VGA", "Storage", "PSU", "Case", "Cooling"};
        List<Category> existingCategories = categoryDAO.findAll();
        
        for (String name : categoryNames) {
            boolean exists = existingCategories.stream().anyMatch(c -> c.getName().equalsIgnoreCase(name));
            if (!exists) {
                try {
                    Category c = new Category();
                    c.setName(name);
                    categoryDAO.save(c);
                    log.info("[BuildPcDataSeeder] Seeded category: {}", name);
                } catch (Exception e) {
                    log.warn("[BuildPcDataSeeder] Could not seed category {}: {}", name, e.getMessage());
                }
            }
        }

        existingCategories = categoryDAO.findAll(); // Reload to get IDs

        // Seed products if not exist
        seedProduct(existingCategories, "CPU", "Intel Core Ultra 7 265F (Tray)", 12000000.0, "/images/products/ultra7_265f.jpg", "125");
        seedProduct(existingCategories, "CPU", "Intel Core i5 12400F / 2.5GHz Turbo 4.4GHz (TRAY) - CHÍNH HÃNG", 2500000.0, "/images/products/i5_12400f.png", "65");
        seedProduct(existingCategories, "CPU", "Intel Core i7 14700F (Tray)", 9500000.0, "/images/products/i7_14700f.jpg", "65");
        seedProduct(existingCategories, "CPU", "Intel Core i9 14900K (Tray)", 14000000.0, "/images/products/i9_14900k.jpg", "125");
        seedProduct(existingCategories, "CPU", "Intel Core Ultra 9 285K", 16500000.0, "/images/products/ultra9_285k.jpg", "125");
        
        seedProduct(existingCategories, "Mainboard", "GIGABYTE Z890 EAGLE WIFI7 (DDR5)", 7500000.0, "/images/products/gigabyte_z890_eagle.jpg", "40");
        seedProduct(existingCategories, "Mainboard", "GIGABYTE H610M-H V3 (DDR4)", 1800000.0, "/images/products/gigabyte_h610m.jpg", "30");
        seedProduct(existingCategories, "Mainboard", "GIGABYTE B760M GAMING PLUS WIFI DDR4", 3500000.0, "/images/products/gigabyte_b760m_gaming.jpg", "40");
        seedProduct(existingCategories, "Mainboard", "ASUS ROG MAXIMUS Z790 HERO", 15000000.0, "/images/products/asus_rog_z790.jpg", "60");
        seedProduct(existingCategories, "Mainboard", "ProArt Z790-CREATOR WIFI", 12000000.0, "/images/products/proart_z790.jpg", "55");

        seedProduct(existingCategories, "RAM", "RAM Kingmax Horizon 16GB DDR5 Bus 5600Mhz", 1200000.0, "/images/products/kingmax_horizon_5600.jpg", "10");
        seedProduct(existingCategories, "RAM", "Ram KingSpec Heatsink Red 1x16GB DDR4 Bus 3200Mhz", 750000.0, "/images/products/kingspec_heatsink_red.jpg", "10");
        seedProduct(existingCategories, "RAM", "Corsair Dominator Titanium 64GB", 6500000.0, "/images/products/corsair_dominator_64gb.jpg", "15");
        seedProduct(existingCategories, "RAM", "G.Skill Trident Z5 64GB DDR5", 5500000.0, "/images/products/gskill_trident_64gb.jpg", "15");

        seedProduct(existingCategories, "VGA", "MSI GeForce RTX 5070 Ti 16GB Shadow 3X OC", 25000000.0, "/images/products/msi_rtx_5070ti_shadow.jpg", "250");
        seedProduct(existingCategories, "VGA", "GIGABYTE GeForce RTX 5080 WINDFORCE OC SFF 16G", 35000000.0, "/images/products/gigabyte_rtx_5080_windforce.jpg", "300");
        seedProduct(existingCategories, "VGA", "MSI GeForce RTX 5060 Ventus 2X OC 8GB", 8500000.0, "/images/products/msi_rtx_5060_ventus.jpg", "150");
        seedProduct(existingCategories, "VGA", "ZOTAC GeForce RTX 5060 Ti 8GB TWIN EDGE GDDR7", 11000000.0, "/images/products/zotac_rtx_5060ti_twin.png", "160");
        seedProduct(existingCategories, "VGA", "ASUS ROG Strix RTX 5090 24GB", 65000000.0, "/images/products/asus_rog_rtx_5090.jpg", "450");

        seedProduct(existingCategories, "Storage", "Ổ cứng SSD Kingston NV3 1TB M.2 PCIe NVMe Gen4", 1800000.0, "/images/products/kingston_nv3_1tb.jpg", "10");
        seedProduct(existingCategories, "Storage", "Ổ Cứng SSD KingSpec NVMe 512GB (NE-512)", 800000.0, "/images/products/kingspec_nvme_512gb.jpg", "10");
        seedProduct(existingCategories, "Storage", "Samsung 990 PRO 2TB", 4500000.0, "/images/products/samsung_990pro.jpg", "15");

        seedProduct(existingCategories, "PSU", "Corsair RM850e ATX 3.1 - 80 Plus Gold - Full Modular (850W)", 3500000.0, "/images/products/corsair_rm850e.jpg", "0");
        seedProduct(existingCategories, "PSU", "Cooler Master MWE 650 - 80 Plus Bronze - V3 230V (650W)", 1500000.0, "/images/products/cooler_master_mwe_650.jpg", "0");
        seedProduct(existingCategories, "PSU", "Nguồn FSP HV PRO 650W - 80 Plus Bronze", 1400000.0, "/images/products/fsp_hv_pro_650w.png", "0");
        seedProduct(existingCategories, "PSU", "Corsair CX650 - 80 Plus Bronze (650W)", 1600000.0, "/images/products/corsair_cx650.jpg", "0");

        seedProduct(existingCategories, "Case", "Corsair 3500X TG Mid Tower Black", 2000000.0, "/images/products/corsair_3500x_black.png", "0");
        seedProduct(existingCategories, "Case", "Corsair FRAME 4500X RS-R ARGB Panoramic Black", 3500000.0, "/images/products/corsair_frame_4500x.jpg", "0");
        seedProduct(existingCategories, "Case", "Vỏ máy tính Xigmatek QUANTUM 4AF", 800000.0, "/images/products/xigmatek_quantum_4af.jpg", "0");

        seedProduct(existingCategories, "Cooling", "Tản nhiệt AIO Corsair NAUTILUS 360 ARGB Black", 2800000.0, "/images/products/corsair_nautilus_360.jpg", "15");
        seedProduct(existingCategories, "Cooling", "Cooler Master Hyper 212 Spectrum V3 ARGB", 600000.0, "/images/products/cooler_master_212_spectrum.jpg", "5");
        seedProduct(existingCategories, "Cooling", "ROG Ryujin III 360 ARGB", 8500000.0, "/images/products/rog_ryujin_360.jpg", "20");

        try {
            // SQL Server uses IDENTITY for auto-increment, no need for setval.
        } catch (Exception e) {}

        // Seed Combos
        List<Product> allProds = productDAO.findAll();
        seedCombo(allProds, "Combo 1: LXR Core Ultra 7 / RTX 5070Ti", "HOT", "#ef4444", 67000000.0, "/images/combo1.jpg", 
            "Ultra 7", "Z890", "Kingmax Horizon", "5070 Ti", "1TB", "850e", "3500X", "NAUTILUS");
        seedCombo(allProds, "Combo 2: LXR Core Ultra 7 / RTX 5080", "PREMIUM", "#eab308", 67000000.0, "/images/combo2.jpg", 
            "Ultra 7", "Z890", "Kingmax Horizon", "5080", "1TB", "850e", "4500X", "NAUTILUS");
        seedCombo(allProds, "Combo 3: LXR Intel i5-12400F / RTX 5060", "SALE", "#22c55e", 47000000.0, "/images/combo3.jpg", 
            "12400F", "H610M", "Heatsink Red", "5060 Ventus", "512GB", "MWE 650", "QUANTUM", "Hyper 212");
        seedCombo(allProds, "Combo 4: LXR Intel i5-12400F / RTX 5060 Ti", "VALUE", "#3b82f6", 22000000.0, "/images/combo4.jpg", 
            "12400F", "B760M", "Heatsink Red", "5060 Ti", "512GB", "HV PRO", "QUANTUM", "Hyper 212");
        seedCombo(allProds, "Combo 5: LXR Intel i7-14700F / RTX 5060", "PERFORMANCE", "#f97316", 25000000.0, "/images/combo5.jpg", 
            "14700F", "B760M", "Heatsink Red", "5060 Ventus", "512GB", "CX650", "3500X", "NAUTILUS");
        seedCombo(allProds, "Combo 6: LXR AMD Ryzen 9 / RTX 5090", "ULTIMATE", "var(--gold)", 120000000.0, "/images/combo2.jpg", 
            "14900K", "HERO", "Dominator", "5090", "990 PRO", "850e", "FRAME", "Ryujin");
        seedCombo(allProds, "Combo 7: LXR Studio / RTX 5080", "CREATOR", "#a855f7", 85000000.0, "/images/combo1.jpg", 
            "285K", "CREATOR", "G.Skill", "5080", "990 PRO", "850e", "FRAME", "NAUTILUS");
    }

    private void seedProduct(List<Category> categories, String categoryName, String productName, Double price, String image, String power) {
        Category category = categories.stream()
                .filter(c -> c.getName().equalsIgnoreCase(categoryName))
                .findFirst()
                .orElse(null);

        if (category == null) return;

        List<Product> allProducts = productDAO.findAll();
        boolean exists = allProducts.stream().anyMatch(p -> p.getName().equalsIgnoreCase(productName));
        
        if (!exists) {
            try {
                Product p = new Product();
                p.setName(productName);
                p.setPrice(price);
                p.setImage(image);
                p.setStock(100);
                p.setCategory(category);
                p.setCreatedAt(new Date());
                p.setDescription("TDP: " + power + "W"); // Lưu thông số công suất vào mô tả tạm thời
                productDAO.save(p);
                log.info("[BuildPcDataSeeder] Seeded product: {}", productName);
            } catch (Exception e) {
                log.warn("[BuildPcDataSeeder] Could not seed product {}: {}", productName, e.getMessage());
            }
        }
    }

    private void seedCombo(List<Product> allProds, String name, String badge, String badgeColor, Double price, String image,
                           String cpuKey, String mainKey, String ramKey, String vgaKey, String storageKey, String psuKey, String caseKey, String coolingKey) {
        if (comboDAO.findAll().stream().anyMatch(c -> c.getName().equals(name))) return;

        poly.edu.entity.PcCombo combo = new poly.edu.entity.PcCombo();
        combo.setName(name);
        combo.setBadge(badge);
        combo.setBadgeColor(badgeColor);
        combo.setPrice(price);
        combo.setImage(image);
        combo = comboDAO.save(combo);

        addComboDetail(combo, allProds, "cpu", cpuKey);
        addComboDetail(combo, allProds, "mainboard", mainKey);
        addComboDetail(combo, allProds, "ram", ramKey);
        addComboDetail(combo, allProds, "vga", vgaKey);
        addComboDetail(combo, allProds, "storage", storageKey);
        addComboDetail(combo, allProds, "psu", psuKey);
        addComboDetail(combo, allProds, "case", caseKey);
        addComboDetail(combo, allProds, "cooling", coolingKey);
    }

    private void addComboDetail(poly.edu.entity.PcCombo combo, List<Product> allProds, String type, String key) {
        Product p = allProds.stream()
                .filter(prod -> prod.getCategory().getName().equalsIgnoreCase(type) && prod.getName().toLowerCase().contains(key.toLowerCase()))
                .findFirst()
                .orElse(allProds.stream().filter(prod -> prod.getCategory().getName().equalsIgnoreCase(type)).findFirst().orElse(null));
        
        if (p != null) {
            poly.edu.entity.PcComboDetail detail = new poly.edu.entity.PcComboDetail();
            detail.setCombo(combo);
            detail.setProduct(p);
            detail.setSlotType(type);
            comboDetailDAO.save(detail);
        }
    }
}

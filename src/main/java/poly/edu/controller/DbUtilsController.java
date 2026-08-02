package poly.edu.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import poly.edu.dao.ProductDAO;
import poly.edu.entity.Product;
import java.util.List;

@RestController
@RequiredArgsConstructor
public class DbUtilsController {
    private final ProductDAO productDAO;

    @GetMapping("/api/utils/force-update-images")
    public String forceUpdateImages() {
        List<Product> products = productDAO.findAll();
        int updated = 0;
        for (Product p : products) {
            String name = p.getName() != null ? p.getName().toLowerCase() : "";
            
            if (name.contains("rtx") || name.contains("rx") || name.contains("radeon") || name.contains("vga") || name.contains("card") || name.contains("gtx")) {
                p.setImage("asus_rog_rtx_4090.jpg");
            } else if (name.contains("core") || name.contains("ryzen") || name.contains("cpu") || name.contains("intel") || name.contains("amd") || name.contains("threadripper")) {
                p.setImage("i9_14900k.jpg");
            } else if (name.contains("z790") || name.contains("b760") || name.contains("x670") || name.contains("mainboard") || name.contains("motherboard") || name.contains("z890") || name.contains("h610") || name.contains("b650")) {
                p.setImage("z790_dark_kingpin.jpg");
            } else if (name.contains("ram") || name.contains("ddr4") || name.contains("ddr5") || name.contains("g.skill") || name.contains("trident") || name.contains("hof") || name.contains("corsair vengeance")) {
                p.setImage("galax_hof_32gb.jpg");
            } else if (name.contains("ssd") || name.contains("nvme") || name.contains("samsung") || name.contains("crucial") || name.contains("sabrent") || name.contains("kingston") || name.contains("hdd")) {
                p.setImage("sabrent_rocket_4tb.jpg");
            } else if (name.contains("nguồn") || name.contains("psu") || name.contains("corsair") || name.contains("fsp") || name.contains("cooler master")) {
                p.setImage("corsair_rm850e.jpg");
            } else if (name.contains("tản nhiệt") || name.contains("cooler") || name.contains("aio") || name.contains("ryujin") || name.contains("nautilus") || name.contains("fan") || name.contains("quạt")) {
                p.setImage("rog_ryujin_360.jpg");
            } else if (name.contains("màn hình") || name.contains("monitor") || name.contains("aw34") || name.contains("pg42") || name.contains("xeneon") || name.contains("odyssey") || name.contains("asus rog swift") || name.contains("display")) {
                p.setImage("samsung_990pro.jpg");
            } else {
                p.setImage("corsair_3500x_black.png");
            }
            
            productDAO.save(p);
            updated++;
        }
        return "SUCCESSFULLY UPDATED " + updated + " PRODUCTS TO LOCAL IMAGES!";
    }
}

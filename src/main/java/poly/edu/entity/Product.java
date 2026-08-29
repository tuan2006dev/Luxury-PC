package poly.edu.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "products")
public class Product implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @NotBlank(message = "Tên sản phẩm không được để trống")
    private String name;

    @NotNull(message = "Giá sản phẩm không được để trống")
    @Positive(message = "Giá sản phẩm phải lớn hơn 0")
    private Double price;
    private String description;
    private String image;
    private Integer stock = 0;
    
    @Column(name = "brand", length = 100)
    private String brand;

    @ManyToOne
    @JoinColumn(name = "category_id")
    private Category category;

    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;

    public Product() {
    }

    public Product(Integer id, String name, Double price, String description, String image, Integer stock, String brand, Category category, Date createdAt) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.description = description;
        this.image = image;
        this.stock = stock;
        this.brand = brand;
        this.category = category;
        this.createdAt = createdAt;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public Integer getStock() {
        return stock != null ? stock : 0;
    }

    public void setStock(Integer stock) {
        this.stock = stock != null ? stock : 0;
    }

    public String getBrand() {
        if (brand != null && !brand.trim().isEmpty()) {
            return brand;
        }
        if (name != null && !name.trim().isEmpty()) {
            String nameUpper = name.toUpperCase();
            if (nameUpper.contains("INTEL")) return "Intel";
            if (nameUpper.contains("AMD")) return "AMD";
            if (nameUpper.contains("NVIDIA")) return "NVIDIA";
            if (nameUpper.contains("ASUS") || nameUpper.contains("ROG") || nameUpper.contains("TUF")) return "ASUS";
            if (nameUpper.contains("MSI")) return "MSI";
            if (nameUpper.contains("GIGABYTE") || nameUpper.contains("AORUS")) return "Gigabyte";
            if (nameUpper.contains("CORSAIR") || nameUpper.contains("VENGEANCE") || nameUpper.contains("DOMINATOR")) return "Corsair";
            if (nameUpper.contains("RAZER")) return "Razer";
            if (nameUpper.contains("LOGITECH")) return "Logitech";
            if (nameUpper.contains("KINGSTON") || nameUpper.contains("FURY")) return "Kingston";
            if (nameUpper.contains("SAMSUNG")) return "Samsung";
            if (nameUpper.contains("WESTERN DIGITAL") || nameUpper.contains("WD") || nameUpper.contains("FIRECUDA")) return "Western Digital";
            if (nameUpper.contains("SEAGATE")) return "Seagate";
            if (nameUpper.contains("G.SKILL") || nameUpper.contains("TRIDENT") || nameUpper.contains("RIPJAWS")) return "G.Skill";
            if (nameUpper.contains("CRUCIAL")) return "Crucial";
            if (nameUpper.contains("T-FORCE") || nameUpper.contains("TEAMGROUP") || nameUpper.contains("TEAM")) return "TeamGroup";
            if (nameUpper.contains("ADATA") || nameUpper.contains("XPG")) return "ADATA";
            if (nameUpper.contains("LEXAR")) return "Lexar";
            if (nameUpper.contains("ZOTAC")) return "Zotac";
            if (nameUpper.contains("GALAX")) return "Galax";
            if (nameUpper.contains("EVGA")) return "EVGA";
            if (nameUpper.contains("SAPPHIRE")) return "Sapphire";
            if (nameUpper.contains("POWERCOLOR")) return "PowerColor";
            if (nameUpper.contains("STEELSERIES")) return "SteelSeries";
            if (nameUpper.contains("DAREU")) return "Dareu";
            if (nameUpper.contains("RAPOO")) return "Rapoo";
            if (nameUpper.contains("FANTECH")) return "Fantech";
            if (nameUpper.contains("HYPERX")) return "HyperX";
            if (nameUpper.contains("BIOSTAR")) return "Biostar";
            if (nameUpper.contains("COLORFUL") || nameUpper.contains("CVN")) return "Colorful";
            if (nameUpper.contains("ASROCK")) return "ASRock";
            if (nameUpper.contains("NZXT")) return "NZXT";
            if (nameUpper.contains("THERMALTAKE")) return "Thermaltake";
            if (nameUpper.contains("NOCTUA")) return "Noctua";
            if (nameUpper.contains("DEEPCOOL")) return "DeepCool";
            if (nameUpper.contains("ID-COOLING")) return "ID-Cooling";
            if (nameUpper.contains("COOLER MASTER")) return "Cooler Master";
            if (nameUpper.contains("XIGMATEK")) return "Xigmatek";
            if (nameUpper.contains("MIK")) return "MIK";
            if (nameUpper.contains("SAMA")) return "SAMA";
            if (nameUpper.contains("VIEWSONIC")) return "ViewSonic";
            if (nameUpper.contains("LG")) return "LG";
            if (nameUpper.contains("DELL")) return "Dell";
            if (nameUpper.contains("HP")) return "HP";
            if (nameUpper.contains("ACER")) return "Acer";
            if (nameUpper.contains("AOC")) return "AOC";
            if (nameUpper.contains("BENQ")) return "BenQ";
        }
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}

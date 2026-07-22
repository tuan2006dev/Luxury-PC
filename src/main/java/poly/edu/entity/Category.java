package poly.edu.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import java.io.Serializable;

@Entity
@Table(name = "categories")
public class Category implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @NotBlank(message = "Tên danh mục không được để trống")
    @Column(unique = true)
    private String name;

    public Category() {
    }

    public Category(Integer id, String name) {
        this.id = id;
        this.name = name;
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

    @Transient
    public String getCategoryImage() {
        if (name == null) return "/images/ui-new/PC.png";
        String n = name.trim().toUpperCase();
        if (n.contains("RAM")) return "/images/ui-new/RAM.png";
        if (n.contains("VGA") || n.contains("CARD MÀN HÌNH")) return "/images/ui-new/VGA.png";
        if (n.contains("CASE") || n.contains("VỎ MÁY TÍNH")) return "/images/ui-new/Case.png";
        if (n.contains("MAINBOARD") || n.contains("BO MẠCH")) return "/images/ui-new/Mainboard.png";
        if (n.contains("CPU") || n.contains("VI XỬ LÝ")) return "/images/ui-new/CPU.png";
        if (n.contains("SSD")) return "/images/ui-new/SSD.png";
        if (n.contains("HDD") || n.contains("Ổ CỨNG")) return "/images/ui-new/HDD.png";
        if (n.contains("PSU") || n.contains("NGUỒN")) return "/images/ui-new/PSU.png";
        if (n.contains("MÀN HÌNH") || n.contains("MONITOR")) return "/images/ui-new/Màn hình.png";
        if (n.contains("TẢN NHIỆT") || n.contains("COOLING")) return "/images/ui-new/Cooling.png";
        if (n.contains("BÀN PHÍM") || n.contains("KEYBOARD")) return "/images/ui-new/Keyboard.png";
        if (n.contains("CHUỘT") || n.contains("MOUSE")) return "/images/ui-new/Mouse.png";
        if (n.contains("TAI NGHE") || n.contains("HEADSET")) return "/images/ui-new/Headset.png";
        return "/images/ui-new/PC.png";
    }
}

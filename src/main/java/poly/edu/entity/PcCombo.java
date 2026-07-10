package poly.edu.entity;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "pc_combos")
public class PcCombo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    
    private String description;
    
    private String image;
    
    private String badge; // e.g. HOT, PREMIUM, SALE, ULTIMATE
    
    private String badgeColor; // e.g. #a855f7
    
    private Double price;

    @OneToMany(mappedBy = "combo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<PcComboDetail> details;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
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

    public String getBadge() {
        return badge;
    }

    public void setBadge(String badge) {
        this.badge = badge;
    }

    public String getBadgeColor() {
        return badgeColor;
    }

    public void setBadgeColor(String badgeColor) {
        this.badgeColor = badgeColor;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public List<PcComboDetail> getDetails() {
        return details;
    }

    public void setDetails(List<PcComboDetail> details) {
        this.details = details;
    }
}

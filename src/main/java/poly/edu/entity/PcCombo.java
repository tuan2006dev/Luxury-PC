package poly.edu.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.util.List;

@Data
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
}

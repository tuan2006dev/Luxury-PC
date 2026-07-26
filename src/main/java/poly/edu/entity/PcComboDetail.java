package poly.edu.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "pc_combo_details")
public class PcComboDetail {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "combo_id")
    private PcCombo combo;

    @ManyToOne
    @JoinColumn(name = "product_id")
    private Product product;

    private String slotType; // e.g. cpu, mainboard, ram, vga, storage, psu, case, cooling

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public PcCombo getCombo() {
        return combo;
    }

    public void setCombo(PcCombo combo) {
        this.combo = combo;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public String getSlotType() {
        return slotType;
    }

    public void setSlotType(String slotType) {
        this.slotType = slotType;
    }
}

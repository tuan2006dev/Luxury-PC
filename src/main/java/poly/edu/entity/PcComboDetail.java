package poly.edu.entity;

import jakarta.persistence.*;
import lombok.Data;

@Data
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
}

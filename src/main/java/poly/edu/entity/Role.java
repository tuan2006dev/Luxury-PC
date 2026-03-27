package poly.edu.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;
import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;

@Data
@Entity
@Table(name = "roles")
public class Role implements Serializable {
    @Id
    private Integer id;
    private String name;

    @JsonIgnore
    @OneToMany(mappedBy = "role")
    List<UserRole> userRoles;
}

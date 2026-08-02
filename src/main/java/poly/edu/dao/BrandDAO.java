package poly.edu.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import poly.edu.entity.Brand;

import java.util.List;

public interface BrandDAO extends JpaRepository<Brand, Integer> {
    List<Brand> findAllByOrderByDisplayOrderAsc();
}

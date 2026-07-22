package poly.edu.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import poly.edu.entity.Brand;

import java.util.List;

@Repository
public interface BrandDAO extends JpaRepository<Brand, Integer> {
    List<Brand> findAllByOrderByDisplayOrderAsc();
}

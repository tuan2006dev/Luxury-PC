package poly.edu.service;

import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import poly.edu.dao.BrandDAO;
import poly.edu.entity.Brand;

import java.util.List;

@Service
@RequiredArgsConstructor
public class BrandService {
    
    private final BrandDAO brandDAO;

    @Cacheable("allBrands")
    public List<Brand> getAllBrands() {
        return brandDAO.findAllByOrderByDisplayOrderAsc();
    }
}

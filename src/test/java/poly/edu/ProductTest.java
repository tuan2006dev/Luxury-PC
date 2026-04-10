package poly.edu;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import jakarta.validation.ConstraintViolationException;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;
import poly.edu.dao.ProductDAO;
import poly.edu.entity.Product;

import java.util.Optional;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
public class ProductTest {

    @Autowired
    private ProductDAO productDAO;

    @Test
    public void AUT_SP_01_KiemTraLuuSPMoiThanhCong() {
        Product p = new Product();
        p.setName("iPhone 15");
        p.setPrice(20000000.0);
        
        Product saved = productDAO.save(p);
        assertNotNull(saved.getId());
        assertEquals("iPhone 15", saved.getName());
    }

    @Test
    public void AUT_SP_02_KiemTraTimSPTheoID() {
        Product p = new Product();
        p.setName("iPhone 15");
        p.setPrice(20000000.0);
        Product saved = productDAO.saveAndFlush(p);

        Optional<Product> found = productDAO.findById(saved.getId());
        assertTrue(found.isPresent());
        assertEquals("iPhone 15", found.get().getName());
    }

    @Test
    public void AUT_SP_03_KiemTraChanLuuSPThieuTen() {
        Product p = new Product();
        p.setName(null); // Thiếu tên
        p.setPrice(5000.0);

        assertThrows(Exception.class, () -> {
            productDAO.saveAndFlush(p);
        });
    }

    @Test
    public void AUT_SP_04_KiemTraCapNhatGiaSP() {
        Product p = new Product();
        p.setName("Test Product");
        p.setPrice(20000000.0);
        Product saved = productDAO.saveAndFlush(p);

        saved.setPrice(25000000.0);
        Product updated = productDAO.saveAndFlush(saved);

        assertEquals(25000000.0, updated.getPrice());
    }

    @Test
    public void AUT_SP_05_KiemTraXoaSanPham() {
        Product p = new Product();
        p.setName("Product to Delete");
        p.setPrice(1000.0);
        Product saved = productDAO.saveAndFlush(p);
        Integer id = saved.getId();

        productDAO.deleteById(id);
        productDAO.flush();

        assertFalse(productDAO.findById(id).isPresent());
    }
}

package poly.edu;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;
import poly.edu.dao.CategoryDAO;
import poly.edu.entity.Category;

import java.util.List;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
public class CategoryTest {

    @Autowired
    private CategoryDAO categoryDAO;

    @Test
    public void AUT_DM_01_TaoDanhMucMoi() {
        Category cat = new Category();
        cat.setName("Laptop Gaming");
        Category saved = categoryDAO.save(cat);
        assertNotNull(saved.getId());
        assertEquals("Laptop Gaming", saved.getName());
    }

    @Test
    public void AUT_DM_02_ChanTrungTenDanhMuc() {
        Category cat1 = new Category();
        cat1.setName("Linh Kiện");
        categoryDAO.save(cat1);

        Category cat2 = new Category();
        cat2.setName("Linh Kiện");
        
        // JpaRepository.save() might not throw immediately due to buffering, 
        // flush() forces the interaction with DB
        assertThrows(DataIntegrityViolationException.class, () -> {
            categoryDAO.saveAndFlush(cat2);
        });
    }

    @Test
    public void AUT_DM_03_LayTatCaDanhMuc() {
        Category cat = new Category();
        cat.setName("Monitor");
        categoryDAO.save(cat);

        List<Category> list = categoryDAO.findAll();
        assertTrue(list.size() > 0);
    }

    @Test
    public void AUT_DM_04_XoaDanhMucTrong() {
        Category cat = new Category();
        cat.setName("Mouse");
        Category saved = categoryDAO.saveAndFlush(cat);
        Integer id = saved.getId();

        categoryDAO.deleteById(id);
        categoryDAO.flush();

        assertFalse(categoryDAO.findById(id).isPresent());
    }
}

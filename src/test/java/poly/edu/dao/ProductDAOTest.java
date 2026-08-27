package poly.edu.dao;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.data.domain.PageRequest;
import org.springframework.test.context.ActiveProfiles;
import poly.edu.entity.Category;
import poly.edu.entity.Product;

import java.util.Date;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;

@DataJpaTest
@ActiveProfiles("test")
public class ProductDAOTest {

    @Autowired
    private TestEntityManager entityManager;

    @Autowired
    private ProductDAO productDAO;

    private Category cpuCategory;
    private Category gpuCategory;
    private Category ramCategory;

    @BeforeEach
    public void setup() {
        cpuCategory = new Category(null, "CPU");
        entityManager.persist(cpuCategory);

        gpuCategory = new Category(null, "GPU");
        entityManager.persist(gpuCategory);

        ramCategory = new Category(null, "RAM");
        entityManager.persist(ramCategory);

        Product p1 = new Product(null, "Intel Core i9", 500.0, "High end CPU", "i9.png", 5, "Intel", cpuCategory, new Date());
        entityManager.persist(p1);

        Product p2 = new Product(null, "NVIDIA RTX 4090", 1500.0, "High end GPU", "4090.png", 15, "NVIDIA", gpuCategory, new Date());
        entityManager.persist(p2);

        Product p3 = new Product(null, "Corsair 32GB", 150.0, "DDR5 RAM", null, 8, "Corsair", ramCategory, new Date());
        entityManager.persist(p3);

        // Add reviews to CPU and GPU so they have high stars for findFeaturedProducts test
        poly.edu.entity.Review r1 = new poly.edu.entity.Review();
        r1.setStars(5);
        r1.setProduct(p1);
        entityManager.persist(r1);

        poly.edu.entity.Review r2 = new poly.edu.entity.Review();
        r2.setStars(5);
        r2.setProduct(p2);
        entityManager.persist(r2);

        entityManager.flush();
        entityManager.clear();
    }

    @Test
    public void testRepositoryIsNotNull() {
        assertThat(productDAO).isNotNull();
    }

    @Test
    public void testFindByIdForUpdate() {
        List<Product> all = productDAO.findAll();
        Integer id = all.get(0).getId();

        Optional<Product> found = productDAO.findByIdForUpdate(id);
        assertThat(found).isPresent();
        assertThat(found.get().getName()).isEqualTo(all.get(0).getName());
    }

    @Test
    public void testFindAllWithJoinFetch() {
        List<Product> products = productDAO.findAll();
        assertThat(products).hasSize(3);
        assertThat(products.get(0).getCategory().getName()).isNotNull();
    }

    @Test
    public void testFindTopProducts() {
        List<Product> products = productDAO.findTopProducts(PageRequest.of(0, 2));
        assertThat(products).hasSize(2);
        assertThat(products.get(0).getId()).isGreaterThan(products.get(1).getId());
    }

    @Test
    public void testFindFeaturedProducts() {
        List<Product> featured = productDAO.findFeaturedProducts(PageRequest.of(0, 2));
        assertThat(featured).hasSize(2);
        assertThat(featured).extracting(p -> p.getCategory().getName())
                .containsExactlyInAnyOrder("CPU", "GPU");
    }

    @Test
    public void testFindFlashSaleProducts() {
        List<Product> flashSale = productDAO.findFlashSaleProducts();
        assertThat(flashSale).hasSize(2);
        assertThat(flashSale).extracting(Product::getName)
                .containsExactlyInAnyOrder("Intel Core i9", "Corsair 32GB");
    }

    @Test
    public void testFindByCategoryId() {
        List<Product> cpus = productDAO.findByCategoryId(cpuCategory.getId());
        assertThat(cpus).hasSize(1);
        assertThat(cpus.get(0).getName()).isEqualTo("Intel Core i9");
    }

    @Test
    public void testFindByCategoryIdAndImageIsNotNull() {
        List<Product> rams = productDAO.findByCategoryIdAndImageIsNotNull(ramCategory.getId());
        assertThat(rams).isEmpty();

        List<Product> cpus = productDAO.findByCategoryIdAndImageIsNotNull(cpuCategory.getId());
        assertThat(cpus).hasSize(1);
    }

    @Test
    public void testSearchProducts() {
        List<Product> byBrand = productDAO.searchProducts(null, null, null, null, "Intel", PageRequest.of(0, 10)).getContent();
        assertThat(byBrand).hasSize(1);
        assertThat(byBrand.get(0).getName()).isEqualTo("Intel Core i9");

        List<Product> byPriceAndCat = productDAO.searchProducts(gpuCategory.getId(), 1000.0, 2000.0, null, null, PageRequest.of(0, 10)).getContent();
        assertThat(byPriceAndCat).hasSize(1);
        assertThat(byPriceAndCat.get(0).getName()).isEqualTo("NVIDIA RTX 4090");

        List<Product> byKeyword = productDAO.searchProducts(null, null, null, "DDR5", null, PageRequest.of(0, 10)).getContent();
        assertThat(byKeyword).isEmpty(); // image is null for RAM

        List<Product> byKeywordWithImage = productDAO.searchProducts(null, null, null, "High", null, PageRequest.of(0, 10)).getContent();
        assertThat(byKeywordWithImage).hasSize(2); 
    }
}

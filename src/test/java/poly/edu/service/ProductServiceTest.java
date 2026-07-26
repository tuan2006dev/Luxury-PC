package poly.edu.service;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import poly.edu.dao.ProductDAO;
import poly.edu.entity.Product;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class ProductServiceTest {

    @Mock private ProductDAO productDAO;

    @InjectMocks
    private ProductService productService;

    @Test
    void getProductById_ReturnsProduct() {
        Product p = new Product();
        p.setId(1);
        when(productDAO.findById(1)).thenReturn(Optional.of(p));

        Product result = productService.getProductById(1);
        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1);
    }

    @Test
    void searchProducts_CallsDAO() {
        Product p = new Product();
        p.setId(1);
        when(productDAO.searchProducts(any(), any(), any(), anyString(), any(), any())).thenReturn(List.of(p));

        List<Product> list = productService.searchProducts(null, null, null, "keyword", null);
        assertThat(list).hasSize(1);
    }
}

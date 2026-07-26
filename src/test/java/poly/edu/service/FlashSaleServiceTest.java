package poly.edu.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import poly.edu.dao.FlashSaleDAO;
import poly.edu.dao.FlashSaleItemDAO;
import poly.edu.dao.ProductDAO;
import poly.edu.entity.FlashSale;
import poly.edu.entity.FlashSaleItem;
import poly.edu.entity.Product;

import java.util.Date;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class FlashSaleServiceTest {

    @Mock private FlashSaleDAO flashSaleDAO;
    @Mock private FlashSaleItemDAO flashSaleItemDAO;
    @Mock private ProductDAO productDAO;

    @InjectMocks
    private FlashSaleService flashSaleService;

    private FlashSale currentSale;
    private Product product;
    private FlashSaleItem flashSaleItem;

    @BeforeEach
    void setUp() {
        currentSale = new FlashSale();
        currentSale.setId(1);
        currentSale.setActive(true);
        currentSale.setStartTime(new Date(System.currentTimeMillis() - 1000));
        currentSale.setEndTime(new Date(System.currentTimeMillis() + 100000));

        product = new Product();
        product.setId(10);
        product.setPrice(100.0);
        product.setStock(50);

        flashSaleItem = new FlashSaleItem();
        flashSaleItem.setId(100);
        flashSaleItem.setFlashSale(currentSale);
        flashSaleItem.setProduct(product);
        flashSaleItem.setSalePrice(80.0);
        flashSaleItem.setSaleQuantity(10);
        flashSaleItem.setSoldCount(2);
    }

    @Test
    void getCurrentFlashSale_ReturnsActiveSale() {
        when(flashSaleDAO.findCurrentActiveSale()).thenReturn(List.of(currentSale));
        Optional<FlashSale> sale = flashSaleService.getCurrentFlashSale();
        assertThat(sale).isPresent();
        assertThat(sale.get().getId()).isEqualTo(1);
    }

    @Test
    void getEffectivePrice_ReturnsSalePrice_IfInFlashSale() {
        when(flashSaleDAO.findCurrentActiveSale()).thenReturn(List.of(currentSale));
        when(flashSaleItemDAO.findByFlashSaleIdAndProductId(1, 10)).thenReturn(Optional.of(flashSaleItem));

        Double price = flashSaleService.getEffectivePrice(10);
        assertThat(price).isEqualTo(80.0);
    }

    @Test
    void getEffectivePrice_ReturnsOriginalPrice_IfNotInFlashSale() {
        when(flashSaleDAO.findCurrentActiveSale()).thenReturn(List.of(currentSale));
        when(flashSaleItemDAO.findByFlashSaleIdAndProductId(1, 10)).thenReturn(Optional.empty());
        when(productDAO.findById(10)).thenReturn(Optional.of(product));

        Double price = flashSaleService.getEffectivePrice(10);
        assertThat(price).isEqualTo(100.0);
    }

    @Test
    void incrementSoldCount_IncrementsCorrectly() {
        when(flashSaleDAO.findCurrentActiveSale()).thenReturn(List.of(currentSale));
        when(flashSaleItemDAO.findByFlashSaleIdAndProductId(1, 10)).thenReturn(Optional.of(flashSaleItem));

        flashSaleService.incrementSoldCount(10, 5);

        verify(flashSaleItemDAO, times(1)).save(argThat(i -> i.getSoldCount() == 7));
    }
}

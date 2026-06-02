package poly.edu.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import poly.edu.dao.FlashSaleDAO;
import poly.edu.dao.FlashSaleItemDAO;
import poly.edu.dao.ProductDAO;
import poly.edu.entity.FlashSale;
import poly.edu.entity.FlashSaleItem;
import poly.edu.entity.Product;

import java.util.*;

@Service
public class FlashSaleService {

    @Autowired
    private FlashSaleDAO flashSaleDAO;

    @Autowired
    private FlashSaleItemDAO flashSaleItemDAO;

    @Autowired
    private ProductDAO productDAO;

    /**
     * Lấy chương trình Flash Sale đang diễn ra
     */
    public Optional<FlashSale> getCurrentFlashSale() {
        return flashSaleDAO.findCurrentActiveSale(new Date());
    }

    /**
     * Lấy danh sách sản phẩm trong Flash Sale đang diễn ra
     */
    public List<FlashSaleItem> getCurrentFlashSaleItems() {
        Optional<FlashSale> current = getCurrentFlashSale();
        if (current.isEmpty()) return Collections.emptyList();
        return flashSaleItemDAO.findByFlashSaleIdWithProduct(current.get().getId());
    }

    /**
     * Lấy tất cả Flash Sale (admin)
     */
    public List<FlashSale> getAllFlashSales() {
        return flashSaleDAO.findAllByOrderByCreatedAtDesc();
    }

    public FlashSale getById(Integer id) {
        return flashSaleDAO.findById(id).orElse(null);
    }

    public List<FlashSaleItem> getItemsBySaleId(Integer saleId) {
        return flashSaleItemDAO.findByFlashSaleIdWithProduct(saleId);
    }

    public FlashSale saveFlashSale(FlashSale flashSale) {
        return flashSaleDAO.save(flashSale);
    }

    public void deleteFlashSale(Integer id) {
        flashSaleDAO.deleteById(id);
    }

    /**
     * Thêm sản phẩm vào chương trình Flash Sale
     */
    @Transactional
    public FlashSaleItem addItemToSale(Integer saleId, Integer productId, Double salePrice, Integer saleQuantity) {
        FlashSale sale = flashSaleDAO.findById(saleId).orElse(null);
        Product product = productDAO.findById(productId).orElse(null);
        if (sale == null || product == null) return null;

        // Kiểm tra sản phẩm đã có trong sale chưa
        Optional<FlashSaleItem> existing = flashSaleItemDAO.findByFlashSaleIdAndProductId(saleId, productId);
        if (existing.isPresent()) {
            FlashSaleItem item = existing.get();
            item.setSalePrice(salePrice);
            item.setSaleQuantity(saleQuantity);
            return flashSaleItemDAO.save(item);
        }

        FlashSaleItem item = new FlashSaleItem();
        item.setFlashSale(sale);
        item.setProduct(product);
        item.setSalePrice(salePrice);
        item.setSaleQuantity(saleQuantity);
        item.setSoldCount(0);
        return flashSaleItemDAO.save(item);
    }

    public void removeItemFromSale(Integer itemId) {
        flashSaleItemDAO.deleteById(itemId);
    }

    /**
     * Lấy giá effective: nếu sản phẩm đang trong flash sale → giá sale, ngược lại → giá gốc
     */
    public Double getEffectivePrice(Integer productId) {
        Optional<FlashSale> current = getCurrentFlashSale();
        if (current.isPresent()) {
            Optional<FlashSaleItem> item = flashSaleItemDAO
                    .findByFlashSaleIdAndProductId(current.get().getId(), productId);
            if (item.isPresent() && item.get().isAvailable()) {
                return item.get().getSalePrice();
            }
        }
        Product product = productDAO.findById(productId).orElse(null);
        return product != null ? product.getPrice() : 0.0;
    }

    /**
     * Tăng số lượng đã bán trong flash sale
     */
    @Transactional
    public void incrementSoldCount(Integer productId) {
        Optional<FlashSale> current = getCurrentFlashSale();
        if (current.isPresent()) {
            Optional<FlashSaleItem> item = flashSaleItemDAO
                    .findByFlashSaleIdAndProductId(current.get().getId(), productId);
            if (item.isPresent()) {
                FlashSaleItem fsi = item.get();
                fsi.setSoldCount(fsi.getSoldCount() + 1);
                flashSaleItemDAO.save(fsi);
            }
        }
    }
}

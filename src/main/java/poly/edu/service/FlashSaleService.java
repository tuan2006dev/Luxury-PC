package poly.edu.service;

import lombok.RequiredArgsConstructor;
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
@RequiredArgsConstructor
public class FlashSaleService {

    private final FlashSaleDAO flashSaleDAO;

    private final FlashSaleItemDAO flashSaleItemDAO;

    private final ProductDAO productDAO;

    /**
     * Lấy chương trình Flash Sale đang diễn ra (chỉ đọc, không ghi DB)
     */
    @org.springframework.cache.annotation.Cacheable("currentFlashSale")
    public Optional<FlashSale> getCurrentFlashSale() {
        List<FlashSale> activeSales = flashSaleDAO.findCurrentActiveSale();
        if (activeSales != null && !activeSales.isEmpty()) {
            return Optional.of(activeSales.get(0));
        }
        return Optional.empty();
    }

    /**
     * Job chạy ngầm mỗi phút để tự động bật/tắt flash sale
     */
    @org.springframework.scheduling.annotation.Scheduled(cron = "0 * * * * *")
    @Transactional
    @org.springframework.cache.annotation.CacheEvict(value = {"currentFlashSale", "flashSaleItems"}, allEntries = true)
    public void autoSyncFlashSaleStatus() {
        Date now = new Date();
        List<FlashSale> activeSales = flashSaleDAO.findCurrentActiveSale();
        
        if (activeSales != null && !activeSales.isEmpty()) {
            FlashSale current = activeSales.get(0);
            if (current.getEndTime() != null && current.getEndTime().before(now)) {
                // Hết hạn -> Tắt
                flashSaleDAO.deactivateAllSales();
                
                // Tìm chiến dịch tiếp theo
                List<FlashSale> nextSales = flashSaleDAO.findValidSalesForTime(now);
                if (nextSales != null && !nextSales.isEmpty()) {
                    flashSaleDAO.activateSale(nextSales.get(0).getId());
                }
            }
        } else {
            // Tự động bật nếu có chiến dịch đang trong thời gian
            List<FlashSale> nextSales = flashSaleDAO.findValidSalesForTime(now);
            if (nextSales != null && !nextSales.isEmpty()) {
                activateFlashSale(nextSales.get(0).getId());
            }
        }
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

    @org.springframework.cache.annotation.Cacheable(value = "flashSaleItems", key = "#saleId")
    public List<FlashSaleItem> getItemsBySaleId(Integer saleId) {
        return flashSaleItemDAO.findByFlashSaleIdWithProduct(saleId);
    }

    @org.springframework.cache.annotation.CacheEvict(value = {"currentFlashSale", "flashSaleItems"}, allEntries = true)
    public FlashSale saveFlashSale(FlashSale flashSale) {
        return flashSaleDAO.save(flashSale);
    }

    @org.springframework.cache.annotation.CacheEvict(value = {"currentFlashSale", "flashSaleItems"}, allEntries = true)
    @Transactional
    public void deleteFlashSale(Integer id) {
        List<FlashSaleItem> items = getItemsBySaleId(id);
        if (items != null && !items.isEmpty()) {
            flashSaleItemDAO.deleteAll(items);
        }
        flashSaleDAO.deleteById(id);
    }

    @org.springframework.cache.annotation.CacheEvict(value = {"currentFlashSale", "flashSaleItems"}, allEntries = true)
    @Transactional
    public FlashSaleItem addItemToSale(Integer saleId, Integer productId, Double salePrice, Integer saleQuantity) {
        FlashSale sale = flashSaleDAO.findById(saleId).orElse(null);
        Product product = productDAO.findById(productId).orElse(null);
        if (sale == null || product == null) return null;

        // Giới hạn số lượng flash sale theo tồn kho thực tế của sản phẩm
        int stock = product.getStock() != null ? product.getStock() : 0;
        int clampedQty = (saleQuantity != null && saleQuantity > stock) ? stock : (saleQuantity != null ? saleQuantity : 0);

        // Kiểm tra sản phẩm đã có trong sale chưa
        Optional<FlashSaleItem> existing = flashSaleItemDAO.findByFlashSaleIdAndProductId(saleId, productId);
        if (existing.isPresent()) {
            FlashSaleItem item = existing.get();
            item.setSalePrice(salePrice);
            item.setSaleQuantity(clampedQty);
            return flashSaleItemDAO.save(item);
        }

        FlashSaleItem item = new FlashSaleItem();
        item.setFlashSale(sale);
        item.setProduct(product);
        item.setSalePrice(salePrice);
        item.setSaleQuantity(clampedQty);
        item.setSoldCount(0);
        return flashSaleItemDAO.save(item);
    }

    @org.springframework.cache.annotation.CacheEvict(value = {"currentFlashSale", "flashSaleItems"}, allEntries = true)
    public void removeItemFromSale(Integer itemId) {
        flashSaleItemDAO.deleteById(itemId);
    }

    public Optional<FlashSaleItem> getActiveFlashSaleItem(Integer productId) {
        Optional<FlashSale> current = getCurrentFlashSale();
        if (current.isPresent()) {
            return flashSaleItemDAO.findByFlashSaleIdAndProductId(current.get().getId(), productId);
        }
        return Optional.empty();
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
                int currentSold = fsi.getSoldCount() != null ? fsi.getSoldCount() : 0;
                fsi.setSoldCount(currentSold + 1);
                flashSaleItemDAO.save(fsi);
            }
        }
    }

    @Transactional
    public void incrementSoldCount(Integer productId, Integer quantity) {
        Optional<FlashSale> current = getCurrentFlashSale();
        if (current.isPresent()) {
            Optional<FlashSaleItem> item = flashSaleItemDAO
                    .findByFlashSaleIdAndProductId(current.get().getId(), productId);
            if (item.isPresent()) {
                FlashSaleItem fsi = item.get();
                int currentSold = fsi.getSoldCount() != null ? fsi.getSoldCount() : 0;
                fsi.setSoldCount(currentSold + quantity);
                flashSaleItemDAO.save(fsi);
            }
        }
    }

    /**
     * Kích hoạt chương trình Flash Sale được chọn và tắt tất cả chương trình khác
     */
    @org.springframework.cache.annotation.CacheEvict(value = {"currentFlashSale", "flashSaleItems"}, allEntries = true)
    @Transactional
    public void activateFlashSale(Integer id) {
        flashSaleDAO.deactivateAllSales();
        flashSaleDAO.activateSale(id);
    }

    @org.springframework.cache.annotation.CacheEvict(value = {"currentFlashSale", "flashSaleItems"}, allEntries = true)
    @Transactional
    public void toggleFlashSale(Integer id) {
        FlashSale target = flashSaleDAO.findById(id).orElse(null);
        if (target == null) return;

        boolean targetNewState = !Boolean.TRUE.equals(target.getActive());
        if (targetNewState) {
            flashSaleDAO.deactivateAllSales();
            flashSaleDAO.activateSale(id);
        } else {
            target.setActive(false);
            flashSaleDAO.save(target);
        }
    }
}

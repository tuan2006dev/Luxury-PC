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
    @Transactional
    public Optional<FlashSale> getCurrentFlashSale() {
        Date now = new Date();
        List<FlashSale> activeSales = flashSaleDAO.findCurrentActiveSale();
        if (activeSales != null && !activeSales.isEmpty()) {
            FlashSale current = activeSales.get(0);
            // Kiểm tra xem chiến dịch active đã quá hạn chưa
            if (current.getEndTime() != null && current.getEndTime().before(now)) {
                // Quá hạn -> Tắt kích hoạt chương trình cũ
                current.setActive(false);
                flashSaleDAO.save(current);

                // Tìm chiến dịch tiếp theo phù hợp thời gian hiện tại
                List<FlashSale> nextSales = flashSaleDAO.findValidSalesForTime(now);
                if (nextSales != null && !nextSales.isEmpty()) {
                    FlashSale nextSale = nextSales.get(0);
                    // Kích hoạt chiến dịch mới (đồng thời tắt tất cả chiến dịch khác)
                    activateFlashSale(nextSale.getId());
                    return Optional.of(nextSale);
                }
                return Optional.empty();
            }
            return Optional.of(current);
        } else {
            // Không có chiến dịch nào active -> Tìm xem có chiến dịch nào đang trong thời gian diễn ra để tự động bật
            List<FlashSale> nextSales = flashSaleDAO.findValidSalesForTime(now);
            if (nextSales != null && !nextSales.isEmpty()) {
                FlashSale nextSale = nextSales.get(0);
                activateFlashSale(nextSale.getId());
                return Optional.of(nextSale);
            }
        }
        return Optional.empty();
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

    @Transactional
    public void deleteFlashSale(Integer id) {
        List<FlashSaleItem> items = getItemsBySaleId(id);
        if (items != null && !items.isEmpty()) {
            flashSaleItemDAO.deleteAll(items);
        }
        flashSaleDAO.deleteById(id);
    }

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

    @Transactional
    public void incrementSoldCount(Integer productId, Integer quantity) {
        Optional<FlashSale> current = getCurrentFlashSale();
        if (current.isPresent()) {
            Optional<FlashSaleItem> item = flashSaleItemDAO
                    .findByFlashSaleIdAndProductId(current.get().getId(), productId);
            if (item.isPresent()) {
                FlashSaleItem fsi = item.get();
                fsi.setSoldCount(fsi.getSoldCount() + quantity);
                flashSaleItemDAO.save(fsi);
            }
        }
    }

    /**
     * Kích hoạt chương trình Flash Sale được chọn và tắt tất cả chương trình khác
     */
    @Transactional
    public void activateFlashSale(Integer id) {
        List<FlashSale> sales = flashSaleDAO.findAll();
        for (FlashSale sale : sales) {
            if (sale.getId().equals(id)) {
                sale.setActive(true);
            } else {
                sale.setActive(false);
            }
            flashSaleDAO.save(sale);
        }
    }

    @Transactional
    public void toggleFlashSale(Integer id) {
        FlashSale target = flashSaleDAO.findById(id).orElse(null);
        if (target == null) return;

        boolean targetNewState = !Boolean.TRUE.equals(target.getActive());
        if (targetNewState) {
            // Kích hoạt chương trình được chọn, tắt tất cả chương trình khác
            List<FlashSale> sales = flashSaleDAO.findAll();
            for (FlashSale sale : sales) {
                if (sale.getId().equals(id)) {
                    sale.setActive(true);
                } else {
                    sale.setActive(false);
                }
                flashSaleDAO.save(sale);
            }
        } else {
            // Tắt chương trình đang chọn
            target.setActive(false);
            flashSaleDAO.save(target);
        }
    }
}

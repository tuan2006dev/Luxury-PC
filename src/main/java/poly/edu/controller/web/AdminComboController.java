package poly.edu.controller.web;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import poly.edu.dao.PcComboDAO;
import poly.edu.dao.PcComboDetailDAO;
import poly.edu.dao.ProductDAO;
import poly.edu.entity.AdminLog;
import poly.edu.entity.PcCombo;
import poly.edu.entity.PcComboDetail;
import poly.edu.entity.Product;
import poly.edu.repository.AdminLogRepository;
import poly.edu.service.UploadService;

import java.security.Principal;
import java.util.Optional;

@Controller
@RequestMapping("/admin/combos")
@RequiredArgsConstructor
public class AdminComboController {

    private final PcComboDAO pcComboDAO;
    private final PcComboDetailDAO pcComboDetailDAO;
    private final ProductDAO productDAO;
    private final UploadService uploadService;
    private final AdminLogRepository adminLogRepository;

    @GetMapping
    public String index(Model model) {
        model.addAttribute("combos", pcComboDAO.findAll());
        return "admin/combos/index";
    }

    @GetMapping("/create")
    public String create(Model model) {
        model.addAttribute("combo", new PcCombo());
        model.addAttribute("products", productDAO.findAll());
        return "admin/combos/form";
    }

    @PostMapping("/save")
    public String save(@ModelAttribute PcCombo combo,
                       @RequestParam(value="cpuId", required=false) Integer cpuId,
                       @RequestParam(value="mainboardId", required=false) Integer mainboardId,
                       @RequestParam(value="ramId", required=false) Integer ramId,
                       @RequestParam(value="vgaId", required=false) Integer vgaId,
                       @RequestParam(value="storageId", required=false) Integer storageId,
                       @RequestParam(value="psuId", required=false) Integer psuId,
                       @RequestParam(value="caseId", required=false) Integer caseId,
                       @RequestParam(value="coolingId", required=false) Integer coolingId,
                       @RequestParam(value="imageFile", required=false) MultipartFile imageFile,
                       Principal principal,
                       HttpServletRequest request,
                       RedirectAttributes ra) {
        
        if (imageFile != null && !imageFile.isEmpty()) {
            String fileName = uploadService.save(imageFile, "products");
            combo.setImage(fileName);
        } else if (combo.getId() != null) {
            Optional<PcCombo> existing = pcComboDAO.findById(combo.getId());
            if (existing.isPresent()) {
                combo.setImage(existing.get().getImage());
            }
        }

        boolean isNew = (combo.getId() == null);
        PcCombo savedCombo = pcComboDAO.save(combo);

        // Delete old details if any
        if (savedCombo.getDetails() != null) {
            pcComboDetailDAO.deleteAll(savedCombo.getDetails());
        }

        saveDetail(savedCombo, "cpu", cpuId);
        saveDetail(savedCombo, "mainboard", mainboardId);
        saveDetail(savedCombo, "ram", ramId);
        saveDetail(savedCombo, "vga", vgaId);
        saveDetail(savedCombo, "storage", storageId);
        saveDetail(savedCombo, "psu", psuId);
        saveDetail(savedCombo, "case", caseId);
        saveDetail(savedCombo, "cooling", coolingId);

        logAction(principal, request, isNew ? "Tạo Combo PC mới" : "Cập nhật Combo PC", combo.getName());

        ra.addFlashAttribute("message", "Đã lưu Combo thành công!");
        return "redirect:/admin/combos";
    }

    private void saveDetail(PcCombo combo, String slot, Integer productId) {
        if (productId != null) {
            Optional<Product> pOpt = productDAO.findById(productId);
            if (pOpt.isPresent()) {
                PcComboDetail detail = new PcComboDetail();
                detail.setCombo(combo);
                detail.setProduct(pOpt.get());
                detail.setSlotType(slot);
                pcComboDetailDAO.save(detail);
            }
        }
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable("id") Long id, Model model) {
        Optional<PcCombo> opt = pcComboDAO.findById(id);
        if (opt.isPresent()) {
            model.addAttribute("combo", opt.get());
            model.addAttribute("products", productDAO.findAll());
            return "admin/combos/form";
        }
        return "redirect:/admin/combos";
    }

    @GetMapping("/delete/{id}")
    public String delete(
            @PathVariable("id") Long id,
            Principal principal,
            HttpServletRequest request,
            RedirectAttributes ra) {

        Optional<PcCombo> opt = pcComboDAO.findById(id);
        String targetName = opt.isPresent() ? opt.get().getName() : "Combo #" + id;

        pcComboDAO.deleteById(id);
        logAction(principal, request, "Xóa Combo PC", targetName);

        ra.addFlashAttribute("message", "Đã xóa Combo!");
        return "redirect:/admin/combos";
    }

    private void logAction(Principal principal, HttpServletRequest request, String action, String targetUser) {
        try {
            String username = principal != null ? principal.getName() : "STAFF";
            String ip = request.getHeader("X-Forwarded-For");
            if (ip == null || ip.isBlank() || "unknown".equalsIgnoreCase(ip)) {
                ip = request.getRemoteAddr();
            }
            adminLogRepository.save(new AdminLog(username, action, ip, targetUser));
        } catch (Exception e) {
            // Ignore logging errors
        }
    }
}

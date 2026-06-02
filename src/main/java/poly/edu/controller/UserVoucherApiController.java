package poly.edu.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import poly.edu.entity.User;
import poly.edu.entity.UserVoucher;
import poly.edu.service.UserVoucherService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/user-voucher")
public class UserVoucherApiController {

    @Autowired
    private UserVoucherService userVoucherService;

    @PostMapping("/save")
    public ResponseEntity<Map<String, Object>> saveVoucher(@RequestParam String code, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            Map<String, Object> resp = new HashMap<>();
            resp.put("success", false);
            resp.put("message", "Vui lòng đăng nhập để lưu voucher!");
            return ResponseEntity.status(401).body(resp);
        }

        Map<String, Object> result = userVoucherService.saveVoucherForUser(user, code);
        return ResponseEntity.ok(result);
    }

    @GetMapping("/my-vouchers")
    public ResponseEntity<List<Map<String, Object>>> getMyVouchers(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return ResponseEntity.status(401).build();
        }

        List<UserVoucher> userVouchers = userVoucherService.getMyUnusedVouchers(user);
        List<Map<String, Object>> data = userVouchers.stream().map(uv -> {
            Map<String, Object> map = new HashMap<>();
            map.put("code", uv.getVoucher().getCode());
            map.put("description", uv.getVoucher().getDescription());
            map.put("discountType", uv.getVoucher().getDiscountType().name());
            map.put("discountValue", uv.getVoucher().getDiscountValue());
            map.put("minOrderAmount", uv.getVoucher().getMinOrderAmount());
            map.put("maxDiscountAmount", uv.getVoucher().getMaxDiscountAmount());
            map.put("isValid", uv.getVoucher().isValid()); // still check date limits etc
            map.put("endDate", uv.getVoucher().getEndDate());
            return map;
        }).collect(Collectors.toList());

        return ResponseEntity.ok(data);
    }
}

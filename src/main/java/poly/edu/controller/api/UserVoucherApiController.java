package poly.edu.controller.api;

import lombok.RequiredArgsConstructor;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import poly.edu.entity.User;
import poly.edu.entity.UserVoucher;
import poly.edu.service.ProfileService;
import poly.edu.service.UserVoucherService;

@RestController
@RequestMapping("/api/user-voucher")
@RequiredArgsConstructor
public class UserVoucherApiController {

    private final UserVoucherService userVoucherService;

    private final ProfileService profileService;

    @PostMapping("/save")
    public ResponseEntity<Map<String, Object>> saveVoucher(@RequestParam String code, Authentication authentication) {
        if (!isAuthenticated(authentication)) {
            Map<String, Object> resp = new HashMap<>();
            resp.put("success", false);
            resp.put("message", "Vui lòng đăng nhập để lưu voucher!");
            return ResponseEntity.status(401).body(resp);
        }

        User user = profileService.getCurrentUser(authentication);
        Map<String, Object> result = userVoucherService.saveVoucherForUser(user, code);
        return ResponseEntity.ok(result);
    }

    @GetMapping("/my-vouchers")
    public ResponseEntity<List<Map<String, Object>>> getMyVouchers(Authentication authentication) {
        if (!isAuthenticated(authentication)) {
            return ResponseEntity.status(401).build();
        }

        User user = profileService.getCurrentUser(authentication);
        List<UserVoucher> userVouchers = userVoucherService.getMyUnusedVouchers(user);
        List<Map<String, Object>> data = userVouchers.stream().map(uv -> {
            Map<String, Object> map = new HashMap<>();
            map.put("code", uv.getVoucher().getCode());
            map.put("description", uv.getVoucher().getDescription());
            map.put("discountType", uv.getVoucher().getDiscountType().name());
            map.put("discountValue", uv.getVoucher().getDiscountValue());
            map.put("minOrderAmount", uv.getVoucher().getMinOrderAmount());
            map.put("maxDiscountAmount", uv.getVoucher().getMaxDiscountAmount());
            map.put("isValid", uv.getVoucher().isValid());
            map.put("endDate", uv.getVoucher().getEndDate());
            return map;
        }).collect(Collectors.toList());

        return ResponseEntity.ok(data);
    }

    private static boolean isAuthenticated(Authentication authentication) {
        return authentication != null
                && authentication.isAuthenticated()
                && !"anonymousUser".equals(String.valueOf(authentication.getPrincipal()));
    }
}

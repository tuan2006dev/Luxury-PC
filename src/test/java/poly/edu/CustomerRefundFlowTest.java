package poly.edu;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;
import poly.edu.dao.OrderDAO;
import poly.edu.dao.UserDAO;
import poly.edu.entity.Order;
import poly.edu.entity.User;
import poly.edu.service.AdminService;

import java.util.HashMap;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
@AutoConfigureMockMvc
class CustomerRefundFlowTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private OrderDAO orderDAO;

    @Autowired
    private UserDAO userDAO;

    @Autowired
    private AdminService adminService;

    @Autowired
    private ObjectMapper objectMapper;

    private User testUser;
    private User otherUser;

    @BeforeEach
    void setUp() {
        testUser = userDAO.findByEmail("customer-refund-test@luxury.test");
        if (testUser == null) {
            testUser = new User();
            testUser.setUsername("refunduser");
            testUser.setEmail("customer-refund-test@luxury.test");
            testUser.setPassword("password123");
            testUser.setFullName("Nguyễn Văn Test");
            testUser.setPhone("0988776655");
            testUser = userDAO.saveAndFlush(testUser);
        }

        otherUser = userDAO.findByEmail("other-user-test@luxury.test");
        if (otherUser == null) {
            otherUser = new User();
            otherUser.setUsername("otheruser");
            otherUser.setEmail("other-user-test@luxury.test");
            otherUser.setPassword("password123");
            otherUser.setFullName("Người Dùng Khác");
            otherUser.setPhone("0988776654");
            otherUser = userDAO.saveAndFlush(otherUser);
        }
    }

    private Order createTestOrder(User owner, String status) {
        Order order = new Order();
        order.setUser(owner);
        order.setFullName(owner.getFullName());
        order.setEmail(owner.getEmail());
        order.setPhone(owner.getPhone());
        order.setAddress("123 Phố Test");
        order.setCity("Hà Nội");
        order.setTotalPrice(15_000_000D);
        order.setStatus(status);
        order.setPaymentMethod("COD");
        order.setOrderCode("DH-TEST-" + System.currentTimeMillis() + "-" + (int)(Math.random() * 1000));
        return orderDAO.saveAndFlush(order);
    }

    @Test
    @WithMockUser(username = "customer-refund-test@luxury.test", roles = "USER")
    void customerCanSuccessfullySubmitRefundRequestForCompletedOrder() throws Exception {
        Order order = createTestOrder(testUser, "COMPLETED");

        Map<String, String> body = new HashMap<>();
        body.put("reason", "Sản phẩm bị lỗi cổng cắm nguồn, muốn trả hàng");

        mockMvc.perform(post("/api/profile/orders/" + order.getId() + "/request-refund")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(body)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        Order updated = orderDAO.findById(order.getId()).orElseThrow();
        assertEquals("YEU_CAU_HOAN_TIEN", updated.getStatus());
        assertEquals("COMPLETED", updated.getRefundPreviousStatus());
        assertEquals("Sản phẩm bị lỗi cổng cắm nguồn, muốn trả hàng", updated.getRefundReason());
    }

    @Test
    @WithMockUser(username = "customer-refund-test@luxury.test", roles = "USER")
    void customerCannotSubmitRefundWithoutReason() throws Exception {
        Order order = createTestOrder(testUser, "COMPLETED");

        Map<String, String> body = new HashMap<>();
        body.put("reason", "   ");

        mockMvc.perform(post("/api/profile/orders/" + order.getId() + "/request-refund")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(body)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false));

        Order unchanged = orderDAO.findById(order.getId()).orElseThrow();
        assertEquals("COMPLETED", unchanged.getStatus());
    }

    @Test
    @WithMockUser(username = "customer-refund-test@luxury.test", roles = "USER")
    void customerCannotSubmitRefundForOtherUsersOrder() throws Exception {
        Order order = createTestOrder(otherUser, "COMPLETED");

        Map<String, String> body = new HashMap<>();
        body.put("reason", "Yêu cầu thu hồi trái phép");

        mockMvc.perform(post("/api/profile/orders/" + order.getId() + "/request-refund")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(body)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false));

        Order unchanged = orderDAO.findById(order.getId()).orElseThrow();
        assertEquals("COMPLETED", unchanged.getStatus());
    }

    @Test
    void adminCanApproveOrRejectOrRecallRefundRequest() {
        // 1. Approve flow
        Order order1 = createTestOrder(testUser, "YEU_CAU_HOAN_TIEN");
        order1.setRefundPreviousStatus("COMPLETED");
        order1.setRefundReason("Muốn đổi sản phẩm khác");
        orderDAO.saveAndFlush(order1);

        adminService.approveCustomerRefund(order1.getId(), "Admin đã duyệt thu hồi");
        Order approved = orderDAO.findById(order1.getId()).orElseThrow();
        assertEquals("CHO_HOAN_TIEN", approved.getStatus());
        assertTrue(approved.getAdminNote().contains("Admin đã duyệt thu hồi"));

        adminService.confirmRefund(order1.getId(), "Đã nhận lại hàng và hoàn tiền");
        Order refunded = orderDAO.findById(order1.getId()).orElseThrow();
        assertEquals("DA_HOAN_TIEN", refunded.getStatus());

        // 2. Reject flow
        Order order2 = createTestOrder(testUser, "YEU_CAU_HOAN_TIEN");
        order2.setRefundPreviousStatus("COMPLETED");
        order2.setRefundReason("Không thích nữa");
        orderDAO.saveAndFlush(order2);

        adminService.rejectCustomerRefund(order2.getId(), "Quá hạn đổi trả 7 ngày");
        Order rejected = orderDAO.findById(order2.getId()).orElseThrow();
        assertEquals("COMPLETED", rejected.getStatus());
        assertTrue(rejected.getAdminNote().contains("Quá hạn đổi trả 7 ngày"));

        // 3. Direct recall flow
        Order order3 = createTestOrder(testUser, "COMPLETED");
        adminService.recallOrder(order3.getId(), "Thu hồi lỗi nhà sản xuất");
        Order recalled = orderDAO.findById(order3.getId()).orElseThrow();
        assertEquals("THU_HOI", recalled.getStatus());
        assertTrue(recalled.getAdminNote().contains("Thu hồi lỗi nhà sản xuất"));
    }
}

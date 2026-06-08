package poly.edu;

import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.ui.ExtendedModelMap;
import poly.edu.controller.PaymentController;
import poly.edu.dao.OrderDAO;
import poly.edu.dao.UserDAO;
import poly.edu.entity.CartItem;
import poly.edu.entity.Order;
import poly.edu.entity.User;
import poly.edu.service.AdminService;
import poly.edu.service.CustomerOrderService;

import java.util.HashMap;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrlPattern;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
@AutoConfigureMockMvc
class VietQrOrderFlowTest {

    @Autowired
    private OrderDAO orderDAO;

    @Autowired
    private AdminService adminService;

    @Autowired
    private CustomerOrderService customerOrderService;

    @Autowired
    private UserDAO userDAO;

    @Autowired
    private PaymentController paymentController;

    @Autowired
    private MockMvc mockMvc;

    @Test
    void checkoutCreatesPersistedVietQrOrderAndRedirectsToQrPage() throws Exception {
        MockHttpSession session = new MockHttpSession();
        Map<Integer, CartItem> cart = new HashMap<>();
        cart.put(999_999, new CartItem(999_999, "QA VietQR", 17_200_000D, 1));
        session.setAttribute("cart", cart);

        mockMvc.perform(post("/checkout/submit")
                        .session(session)
                        .param("fullName", "QA VietQR")
                        .param("phone", "0900000000")
                        .param("address", "QA Address")
                        .param("paymentMethod", "VIETQR"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrlPattern("/payment/vietqr?amount=17200000&orderCode=DH*"));

        Order order = orderDAO.findAllOrderedByDate().get(0);
        assertEquals(17_200_000D, order.getTotalPrice());
        assertEquals("VIETQR", order.getPaymentMethod());
        assertEquals("CHO_XAC_NHAN_THANH_TOAN", order.getStatus());
        assertNotNull(order.getOrderCode());
    }

    @Test
    void vietQrPageUsesPersistedOrderAmountAndStatus() {
        Order order = saveOrder("VIETQR", "CHO_XAC_NHAN_THANH_TOAN", 17_200_000D);
        ExtendedModelMap model = new ExtendedModelMap();
        HttpSession session = new MockHttpSession();

        String view = paymentController.vietQrPayment(1L, order.getOrderCode(), model, session);

        assertEquals("payment-vietqr", view);
        assertEquals(17_200_000L, model.get("amount"));
        assertEquals("Chờ xác nhận thanh toán", model.get("paymentStatus"));
        assertEquals("MB Bank", model.get("bankDisplayName"));
        assertEquals("9999999999", model.get("accountNo"));
        assertEquals("LUXURYPC", model.get("accountName"));
        assertEquals(
                "https://img.vietqr.io/image/MB-9999999999-compact.png"
                        + "?amount=17200000&addInfo=THANH+TOAN+" + order.getOrderCode()
                        + "&accountName=LUXURYPC",
                model.get("qrUrl"));
    }

    @Test
    void adminCanConfirmWaitingVietQrOrder() {
        Order order = saveOrder("VIETQR", "CHO_XAC_NHAN_THANH_TOAN", 500_000D);

        adminService.confirmVietQrPayment(order.getId());

        assertEquals("DA_THANH_TOAN", orderDAO.findById(order.getId()).orElseThrow().getStatus());
    }

    @Test
    void adminConfirmationDoesNotChangeCodOrder() {
        Order order = saveOrder("COD", "PENDING", 500_000D);

        adminService.confirmVietQrPayment(order.getId());

        assertEquals("PENDING", orderDAO.findById(order.getId()).orElseThrow().getStatus());
    }

    @Test
    void adminCanRequestAndConfirmVietQrRefundWithNotes() {
        Order order = saveOrder("VIETQR", "DA_THANH_TOAN", 500_000D);

        adminService.requestRefund(order.getId(), "Khách yêu cầu hoàn tiền");
        Order waitingRefund = orderDAO.findById(order.getId()).orElseThrow();
        assertEquals("CHO_HOAN_TIEN", waitingRefund.getStatus());
        assertEquals("Khách yêu cầu hoàn tiền", waitingRefund.getAdminNote());

        adminService.confirmRefund(order.getId(), "Đã chuyển khoản hoàn tiền");
        Order refunded = orderDAO.findById(order.getId()).orElseThrow();
        assertEquals("DA_HOAN_TIEN", refunded.getStatus());
        assertEquals("Khách yêu cầu hoàn tiền | Đã chuyển khoản hoàn tiền", refunded.getAdminNote());
    }

    @Test
    void adminCanRecallPaidOrderButCannotRefundCodPendingOrder() {
        Order paidOrder = saveOrder("VIETQR", "DA_THANH_TOAN", 500_000D);
        adminService.recallOrder(paidOrder.getId(), "Thu hồi để kiểm tra");
        Order recalled = orderDAO.findById(paidOrder.getId()).orElseThrow();
        assertEquals("THU_HOI", recalled.getStatus());
        assertEquals("Thu hồi để kiểm tra", recalled.getAdminNote());

        Order codOrder = saveOrder("COD", "PENDING", 500_000D);
        adminService.requestRefund(codOrder.getId(), "Không hợp lệ");
        assertEquals("PENDING", orderDAO.findById(codOrder.getId()).orElseThrow().getStatus());
    }

    @Test
    void genericStatusUpdateCannotBypassRefundWorkflow() {
        Order order = saveOrder("VIETQR", "DA_THANH_TOAN", 500_000D);

        adminService.updateOrderStatus(order.getId(), "DA_HOAN_TIEN");

        assertEquals("DA_THANH_TOAN", orderDAO.findById(order.getId()).orElseThrow().getStatus());
    }

    @Test
    void customerCanRequestRefundOnlyForOwnedEligibleOrder() {
        User owner = userDAO.findByEmail("nguyentruongq169@gmail.com");
        Order order = saveOrder("VIETQR", "DA_THANH_TOAN", 500_000D);
        order.setUser(owner);
        orderDAO.saveAndFlush(order);

        assertEquals(false, customerOrderService.requestRefund(order.getId(), new User(), "Không hợp lệ"));
        assertTrue(customerOrderService.requestRefund(order.getId(), owner, "Sản phẩm không phù hợp"));

        Order requested = orderDAO.findById(order.getId()).orElseThrow();
        assertEquals("YEU_CAU_HOAN_TIEN", requested.getStatus());
        assertEquals("DA_THANH_TOAN", requested.getRefundPreviousStatus());
        assertEquals("Sản phẩm không phù hợp", requested.getRefundReason());
    }

    @Test
    void adminCanApproveOrRejectCustomerRefundRequest() {
        Order approved = saveOrder("VIETQR", "YEU_CAU_HOAN_TIEN", 500_000D);
        approved.setRefundPreviousStatus("DA_THANH_TOAN");
        orderDAO.saveAndFlush(approved);

        adminService.approveCustomerRefund(approved.getId(), "Đã duyệt");
        assertEquals("CHO_HOAN_TIEN", orderDAO.findById(approved.getId()).orElseThrow().getStatus());

        Order rejected = saveOrder("VIETQR", "YEU_CAU_HOAN_TIEN", 500_000D);
        rejected.setRefundPreviousStatus("COMPLETED");
        orderDAO.saveAndFlush(rejected);

        adminService.rejectCustomerRefund(rejected.getId(), "Không đủ điều kiện");
        Order rejectedResult = orderDAO.findById(rejected.getId()).orElseThrow();
        assertEquals("COMPLETED", rejectedResult.getStatus());
        assertEquals("Không đủ điều kiện", rejectedResult.getAdminNote());
    }

    @Test
    void orderProvidesCustomerFriendlyPaymentLabels() {
        Order order = new Order();
        order.setOrderCode("DH100");
        order.setPaymentMethod("VIETQR");
        order.setStatus("CHO_XAC_NHAN_THANH_TOAN");

        assertEquals("VietQR", order.getPaymentMethodDisplay());
        assertEquals("Chờ xác nhận thanh toán", order.getStatusDisplay());
        assertEquals("THANH TOAN DH100", order.getTransferContent());

        order.setStatus("DA_THANH_TOAN");
        assertEquals("Đã thanh toán", order.getStatusDisplay());
        order.setStatus("PENDING");
        assertEquals("Chờ xử lý", order.getStatusDisplay());
        order.setStatus("CANCELLED");
        assertEquals("Đã hủy", order.getStatusDisplay());
        order.setStatus("COMPLETED");
        assertEquals("Hoàn thành", order.getStatusDisplay());
        order.setStatus("CHO_HOAN_TIEN");
        assertEquals("Chờ hoàn tiền", order.getStatusDisplay());
        order.setStatus("YEU_CAU_HOAN_TIEN");
        assertEquals("Đã yêu cầu hoàn trả", order.getStatusDisplay());
        order.setStatus("DA_HOAN_TIEN");
        assertEquals("Đã hoàn tiền", order.getStatusDisplay());
        order.setStatus("THU_HOI");
        assertEquals("Đã thu hồi", order.getStatusDisplay());
        order.setStatus("DA_HUY");
        assertEquals("Đã hủy", order.getStatusDisplay());
        order.setStatus("HOAN_THANH");
        assertEquals("Hoàn thành", order.getStatusDisplay());

        order.setStatus("DA_THANH_TOAN");
        assertTrue(order.isCustomerRefundEligible());
        order.setStatus("CHO_HOAN_TIEN");
        assertEquals(false, order.isCustomerRefundEligible());

        order.setVoucherCode("QA500K");
        order.setDiscountAmount(500_000D);
        assertEquals("QA500K", order.getVoucherCode());
        assertEquals(500_000D, order.getDiscountAmount());
    }

    private Order saveOrder(String paymentMethod, String status, Double totalPrice) {
        Order order = new Order();
        order.setFullName("QA VietQR");
        order.setPhone("0900000000");
        order.setAddress("QA Address");
        order.setTotalPrice(totalPrice);
        order.setPaymentMethod(paymentMethod);
        order.setStatus(status);
        orderDAO.saveAndFlush(order);
        order.setOrderCode("DH" + order.getId());
        return orderDAO.saveAndFlush(order);
    }
}

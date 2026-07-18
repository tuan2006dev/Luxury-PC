package poly.edu.service;

import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import poly.edu.dao.UserVoucherDAO;
import poly.edu.dao.VoucherDAO;
import poly.edu.entity.UserVoucher;
import java.util.List;
import java.util.Date;

@Service
@RequiredArgsConstructor
public class VoucherScheduler {

    private static final Logger log = LoggerFactory.getLogger(VoucherScheduler.class);

    private final UserVoucherDAO userVoucherDAO;
    private final VoucherService voucherService;

    /**
     * Run every 1 minute to release expired voucher reservations.
     * Restores the global usage count and resets user voucher status to AVAILABLE.
     */
    @Scheduled(fixedRate = 60000)
    public void releaseExpiredVoucherReservations() {
        try {
            List<UserVoucher> expired = userVoucherDAO.findExpiredReservations();
            int restoredCount = 0;
            for (UserVoucher uv : expired) {
                try {
                    voucherService.restoreVoucher(uv.getVoucher().getCode(), uv.getUser().getId());
                    restoredCount++;
                } catch (Exception ex) {
                    log.error("Failed to restore expired reservation for user {} voucher {}", uv.getUser().getId(), uv.getVoucher().getCode(), ex);
                }
            }
            if (restoredCount > 0) {
                log.info("Automatically released {} expired voucher reservations.", restoredCount);
            }
        } catch (Exception e) {
            log.error("Error running VoucherScheduler: releaseExpiredVoucherReservations", e);
        }
    }
}

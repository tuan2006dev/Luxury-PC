package poly.edu.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import poly.edu.entity.User;
import poly.edu.entity.UserVoucher;
import poly.edu.entity.Voucher;

import java.util.List;
import java.util.Optional;

public interface UserVoucherDAO extends JpaRepository<UserVoucher, Integer> {
    
    // Find all vouchers saved by a user
    List<UserVoucher> findByUserOrderBySavedAtDesc(User user);
    
    // Find unused vouchers saved by a user
    List<UserVoucher> findByUserAndIsUsedFalseOrderBySavedAtDesc(User user);
    
    // Find a specific saved voucher
    Optional<UserVoucher> findByUserAndVoucher(User user, Voucher voucher);

    // Find a specific valid user voucher by code for a user
    Optional<UserVoucher> findByUserAndVoucherCodeAndIsUsedFalse(User user, String code);

    // Count how many times a voucher was saved globally (optional logic)
    int countByVoucher(Voucher voucher);
}

package poly.edu.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import poly.edu.entity.ShippingAddress;

public interface ShippingAddressRepository extends JpaRepository<ShippingAddress, Integer> {

    List<ShippingAddress> findByUser_IdOrderByDefaultShippingDescIdAsc(Integer userId);

    long countByUser_Id(Integer userId);

    @org.springframework.data.jpa.repository.Modifying
    @org.springframework.data.jpa.repository.Query("DELETE FROM ShippingAddress sa WHERE sa.user.id = :userId")
    void deleteByUserId(@org.springframework.data.repository.query.Param("userId") Integer userId);
}

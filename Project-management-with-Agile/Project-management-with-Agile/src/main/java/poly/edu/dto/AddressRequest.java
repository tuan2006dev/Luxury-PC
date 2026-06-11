package poly.edu.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AddressRequest {

    @NotBlank(message = "Vui lòng nhập tên người nhận")
    private String recipientName;

    @NotBlank(message = "Vui lòng nhập số điện thoại")
    private String phone;

    @NotBlank(message = "Vui lòng nhập địa chỉ chi tiết")
    private String detailedAddress;

    @NotBlank(message = "Vui lòng nhập quận/huyện")
    private String district;

    @NotBlank(message = "Vui lòng nhập tỉnh/thành phố")
    private String city;

    private String postalCode;
}

package poly.edu.dto;

import jakarta.validation.constraints.NotBlank;

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

    public AddressRequest() {
    }

    public AddressRequest(String recipientName, String phone, String detailedAddress, String district, String city, String postalCode) {
        this.recipientName = recipientName;
        this.phone = phone;
        this.detailedAddress = detailedAddress;
        this.district = district;
        this.city = city;
        this.postalCode = postalCode;
    }

    public String getRecipientName() {
        return recipientName;
    }

    public void setRecipientName(String recipientName) {
        this.recipientName = recipientName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getDetailedAddress() {
        return detailedAddress;
    }

    public void setDetailedAddress(String detailedAddress) {
        this.detailedAddress = detailedAddress;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getPostalCode() {
        return postalCode;
    }

    public void setPostalCode(String postalCode) {
        this.postalCode = postalCode;
    }
}

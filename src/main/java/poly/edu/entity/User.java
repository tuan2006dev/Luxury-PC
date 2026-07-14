package poly.edu.entity;

import jakarta.persistence.*;
import java.util.Date;
import java.util.List;

@Entity
@Table(name="users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String username;
    private String email;
    private String password;
    private String fullName;
    private String phone;
    private String address;
    private String avatar;
    private Boolean gender; // true: Male, false: Female
    private Date birthday;
    private Boolean status = true;

    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
    private List<UserRole> userRoles;

    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;

    public enum AuthProvider {
        LOCAL, GOOGLE, FACEBOOK
    }

    @Enumerated(EnumType.STRING)
    @Column(name = "auth_provider")
    private AuthProvider authProvider = AuthProvider.LOCAL;

    @Column(name = "provider_id")
    private String providerId;

    @Column(name = "notify_order_updates")
    private Boolean notifyOrderUpdates = true;

    @Column(name = "notify_flash_sale")
    private Boolean notifyFlashSale = true;

    @Column(name = "notify_new_products")
    private Boolean notifyNewProducts = false;

    @Column(name = "notify_weekly_newsletter")
    private Boolean notifyWeeklyNewsletter = true;

    @Column(name = "two_factor_enabled")
    private Boolean twoFactorEnabled = false;

    public User() {}

    @PrePersist
    protected void onCreate() {
        this.createdAt = new Date();
    }

    // ===== GETTER & SETTER =====

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public Boolean getGender() {
        return gender;
    }

    public void setGender(Boolean gender) {
        this.gender = gender;
    }

    public Date getBirthday() {
        return birthday;
    }

    public void setBirthday(Date birthday) {
        this.birthday = birthday;
    }

    public Boolean getStatus() {
        return status;
    }

    public void setStatus(Boolean status) {
        this.status = status;
    }

    public List<UserRole> getUserRoles() {
        return userRoles;
    }

    public void setUserRoles(List<UserRole> userRoles) {
        this.userRoles = userRoles;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public AuthProvider getAuthProvider() {
        return authProvider;
    }

    public void setAuthProvider(AuthProvider authProvider) {
        this.authProvider = authProvider;
    }

    public String getProviderId() {
        return providerId;
    }

    public void setProviderId(String providerId) {
        this.providerId = providerId;
    }

    public Boolean getNotifyOrderUpdates() {
        return notifyOrderUpdates;
    }

    public void setNotifyOrderUpdates(Boolean notifyOrderUpdates) {
        this.notifyOrderUpdates = notifyOrderUpdates;
    }

    public Boolean getNotifyFlashSale() {
        return notifyFlashSale;
    }

    public void setNotifyFlashSale(Boolean notifyFlashSale) {
        this.notifyFlashSale = notifyFlashSale;
    }

    public Boolean getNotifyNewProducts() {
        return notifyNewProducts;
    }

    public void setNotifyNewProducts(Boolean notifyNewProducts) {
        this.notifyNewProducts = notifyNewProducts;
    }

    public Boolean getNotifyWeeklyNewsletter() {
        return notifyWeeklyNewsletter;
    }

    public void setNotifyWeeklyNewsletter(Boolean notifyWeeklyNewsletter) {
        this.notifyWeeklyNewsletter = notifyWeeklyNewsletter;
    }

    public Boolean getTwoFactorEnabled() {
        return twoFactorEnabled != null && twoFactorEnabled;
    }

    public void setTwoFactorEnabled(Boolean twoFactorEnabled) {
        this.twoFactorEnabled = twoFactorEnabled;
    }
}
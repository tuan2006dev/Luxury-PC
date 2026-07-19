package poly.edu.entity;

import jakarta.persistence.*;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "flash_sales", indexes = {
    @Index(name = "idx_flashsale_active", columnList = "active"),
    @Index(name = "idx_flashsale_time", columnList = "start_time, end_time")
})
public class FlashSale {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String name;

    @Column(name = "start_time")
    @Temporal(TemporalType.TIMESTAMP)
    private Date startTime;

    @Column(name = "end_time")
    @Temporal(TemporalType.TIMESTAMP)
    private Date endTime;

    private Boolean active = true;

    @Column(name = "banner_image")
    private String bannerImage;

    @Column(name = "description", length = 500)
    private String description;

    /**
     * Giới hạn số lượng sản phẩm Flash Sale mỗi user được mua.
     * null = không giới hạn
     */
    @Column(name = "max_per_user")
    private Integer maxPerUser;

    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;

    @OneToMany(mappedBy = "flashSale", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<FlashSaleItem> items;

    public FlashSale() {
    }

    public FlashSale(Integer id, String name, Date startTime, Date endTime, Boolean active, Date createdAt, List<FlashSaleItem> items) {
        this.id = id;
        this.name = name;
        this.startTime = startTime;
        this.endTime = endTime;
        this.active = active;
        this.createdAt = createdAt;
        this.items = items;
    }

    @PrePersist
    protected void onCreate() {
        this.createdAt = new Date();
        if (this.active == null) this.active = true;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    public Boolean getActive() {
        return active;
    }

    public void setActive(Boolean active) {
        this.active = active;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getBannerImage() {
        return bannerImage;
    }

    public void setBannerImage(String bannerImage) {
        this.bannerImage = bannerImage;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getMaxPerUser() {
        return maxPerUser;
    }

    public void setMaxPerUser(Integer maxPerUser) {
        this.maxPerUser = maxPerUser;
    }

    public List<FlashSaleItem> getItems() {
        return items;
    }

    public void setItems(List<FlashSaleItem> items) {
        this.items = items;
    }

    /**
     * Kiểm tra flash sale có đang diễn ra không
     */
    public boolean isRunning() {
        Date now = new Date();
        return Boolean.TRUE.equals(active)
                && startTime != null && endTime != null
                && !now.before(startTime) && !now.after(endTime);
    }

    /**
     * Trạng thái hiển thị: UPCOMING, RUNNING, ENDED
     */
    public String getStatus() {
        Date now = new Date();
        if (!Boolean.TRUE.equals(active)) return "DISABLED";
        if (startTime != null && now.before(startTime)) return "UPCOMING";
        if (endTime != null && now.after(endTime)) return "ENDED";
        return "RUNNING";
    }
}

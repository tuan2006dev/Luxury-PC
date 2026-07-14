package poly.edu.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "news")
public class News implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @NotBlank(message = "Tiêu đề không được để trống")
    @Size(max = 255, message = "Tiêu đề không quá 255 ký tự")
    @Column(nullable = false, length = 255)
    private String title;

    @NotBlank(message = "Slug không được để trống")
    @Size(max = 255, message = "Slug không quá 255 ký tự")
    @Column(nullable = false, unique = true, length = 255)
    private String slug;

    @NotBlank(message = "Nội dung không được để trống")
    @Column(columnDefinition = "TEXT")
    private String content;

    @Column(length = 255)
    private String thumbnail;

    @NotBlank(message = "Tóm tắt không được để trống")
    @Column(columnDefinition = "TEXT")
    private String summary;

    @Column(name = "view_count", columnDefinition = "BIGINT DEFAULT 0")
    private Long viewCount = 0L;

    @Column(name = "meta_title", length = 255)
    private String metaTitle;

    @Column(name = "meta_description", columnDefinition = "TEXT")
    private String metaDescription;

    @Column(name = "meta_keywords", length = 255)
    private String metaKeywords;

    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    private NewsStatus status = NewsStatus.DRAFT;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    private NewsCategory category;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "author_id", nullable = false)
    private User author;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "created_at", updatable = false)
    private Date createdAt;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "updated_at")
    private Date updatedAt;

    public News() {
    }

    @PrePersist
    protected void onCreate() {
        createdAt = new Date();
        updatedAt = new Date();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = new Date();
    }

    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getSlug() { return slug; }
    public void setSlug(String slug) { this.slug = slug; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getThumbnail() { return thumbnail; }
    public void setThumbnail(String thumbnail) { this.thumbnail = thumbnail; }

    public String getSummary() { return summary; }
    public void setSummary(String summary) { this.summary = summary; }

    public Long getViewCount() { return viewCount; }
    public void setViewCount(Long viewCount) { this.viewCount = viewCount; }

    public String getMetaTitle() { return metaTitle; }
    public void setMetaTitle(String metaTitle) { this.metaTitle = metaTitle; }

    public String getMetaDescription() { return metaDescription; }
    public void setMetaDescription(String metaDescription) { this.metaDescription = metaDescription; }

    public String getMetaKeywords() { return metaKeywords; }
    public void setMetaKeywords(String metaKeywords) { this.metaKeywords = metaKeywords; }

    public NewsStatus getStatus() { return status; }
    public void setStatus(NewsStatus status) { this.status = status; }

    public NewsCategory getCategory() { return category; }
    public void setCategory(NewsCategory category) { this.category = category; }

    public User getAuthor() { return author; }
    public void setAuthor(User author) { this.author = author; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    public String getFormattedViewCount() {
        if (viewCount == null) return "0";
        if (viewCount >= 1000000) {
            return String.format("%.1fM", viewCount / 1000000.0).replace(".0", "");
        } else if (viewCount >= 1000) {
            return String.format("%.1fK", viewCount / 1000.0).replace(".0", "");
        }
        return String.valueOf(viewCount);
    }

    public int getReadingTime() {
        if (content == null || content.isEmpty()) return 1;
        int wordCount = content.split("\\s+").length;
        return Math.max(1, wordCount / 200);
    }
}

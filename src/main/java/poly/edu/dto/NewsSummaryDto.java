package poly.edu.dto;

import poly.edu.entity.NewsStatus;
import java.util.Date;

public class NewsSummaryDto {
    private Integer id;
    private String title;
    private String slug;
    private String summary;
    private String thumbnail;
    private Date createdAt;
    private Long viewCount;
    private NewsStatus status;
    private String categoryName;
    private String authorName;

    public NewsSummaryDto(Integer id, String title, String slug, String summary, String thumbnail, 
                          Date createdAt, Long viewCount, NewsStatus status, 
                          String categoryName, String authorName) {
        this.id = id;
        this.title = title;
        this.slug = slug;
        this.summary = summary;
        this.thumbnail = thumbnail;
        this.createdAt = createdAt;
        this.viewCount = viewCount;
        this.status = status;
        this.categoryName = categoryName;
        this.authorName = authorName;
    }

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getSlug() { return slug; }
    public void setSlug(String slug) { this.slug = slug; }
    
    public String getSummary() { return summary; }
    public void setSummary(String summary) { this.summary = summary; }
    
    public String getThumbnail() { return thumbnail; }
    public void setThumbnail(String thumbnail) { this.thumbnail = thumbnail; }
    
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    
    public Long getViewCount() { return viewCount; }
    public void setViewCount(Long viewCount) { this.viewCount = viewCount; }
    
    public NewsStatus getStatus() { return status; }
    public void setStatus(NewsStatus status) { this.status = status; }
    
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
    
    public String getAuthorName() { return authorName; }
    public void setAuthorName(String authorName) { this.authorName = authorName; }

    public String getFormattedViewCount() {
        if (viewCount == null) return "0";
        if (viewCount >= 1000000) {
            return String.format("%.1fM", viewCount / 1000000.0).replace(".0", "");
        } else if (viewCount >= 1000) {
            return String.format("%.1fK", viewCount / 1000.0).replace(".0", "");
        }
        return String.valueOf(viewCount);
    }
}

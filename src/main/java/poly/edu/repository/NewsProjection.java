package poly.edu.repository;

import poly.edu.entity.NewsCategory;
import poly.edu.entity.NewsStatus;
import poly.edu.entity.User;
import java.util.Date;

public interface NewsProjection {
    Integer getId();
    String getTitle();
    String getSlug();
    String getSummary();
    String getThumbnail();
    Date getCreatedAt();
    Integer getViewCount();
    NewsStatus getStatus();
    NewsCategory getCategory();
    User getAuthor();
}

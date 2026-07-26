package poly.edu.entity;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class NewsTest {

    @Test
    void testSettersAndGetters() {
        // Arrange
        News entity = new News();
        entity.setId(1);
        entity.setTitle("title_test");
        entity.setSlug("slug_test");
        entity.setContent("content_test");
        entity.setThumbnail("thumbnail_test");
        entity.setSummary("summary_test");
        entity.setMetaTitle("metaTitle_test");
        entity.setMetaDescription("metaDescription_test");
        entity.setMetaKeywords("metaKeywords_test");
        entity.setCategory(new NewsCategory());
        entity.setAuthor(new User());
        java.util.Date now = new java.util.Date();
        entity.setCreatedAt(now);
        entity.setUpdatedAt(now);

        // Act & Assert
        assertEquals(1, entity.getId());
        assertEquals("title_test", entity.getTitle());
        assertEquals("slug_test", entity.getSlug());
        assertEquals("content_test", entity.getContent());
        assertEquals("thumbnail_test", entity.getThumbnail());
        assertEquals("summary_test", entity.getSummary());
        assertEquals("metaTitle_test", entity.getMetaTitle());
        assertEquals("metaDescription_test", entity.getMetaDescription());
        assertEquals("metaKeywords_test", entity.getMetaKeywords());
        assertNotNull(entity.getCategory());
        assertNotNull(entity.getAuthor());
        assertEquals(now, entity.getCreatedAt());
        assertEquals(now, entity.getUpdatedAt());
    }
}

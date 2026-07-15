package poly.edu.entity;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class TranslationTest {

    @Test
    void testSettersAndGetters() {
        // Arrange
        Translation entity = new Translation();
        entity.setId(1);
        entity.setKey("key_test");
        entity.setLang("lang_test");
        entity.setValue("value_test");

        // Act & Assert
        assertEquals(1, entity.getId());
        assertEquals("key_test", entity.getKey());
        assertEquals("lang_test", entity.getLang());
        assertEquals("value_test", entity.getValue());
    }
}

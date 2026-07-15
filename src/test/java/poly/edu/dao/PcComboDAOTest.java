package poly.edu.dao;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.test.context.ActiveProfiles;
import static org.assertj.core.api.Assertions.assertThat;
import poly.edu.entity.PcCombo;
import org.springframework.transaction.annotation.Transactional;

@DataJpaTest
@ActiveProfiles("test")
@Transactional
public class PcComboDAOTest {

    @Autowired
    private PcComboDAO repository;

    @Test
    public void testRepositoryIsNotNull() {
        assertThat(repository).isNotNull();
    }
}

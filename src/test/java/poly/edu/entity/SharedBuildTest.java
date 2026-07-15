package poly.edu.entity;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class SharedBuildTest {

    @Test
    void testSettersAndGetters() {
        // Arrange
        SharedBuild entity = new SharedBuild();
        entity.setShareCode("shareCode_test");
        entity.setName("name_test");
        entity.setCaseId("caseId_test");
        entity.setMainboardId("mainboardId_test");
        entity.setCpuId("cpuId_test");
        entity.setCoolerId("coolerId_test");
        entity.setRamId("ramId_test");
        entity.setStorageId("storageId_test");
        entity.setGpuId("gpuId_test");
        entity.setPsuId("psuId_test");
        entity.setTotalPrice(java.math.BigDecimal.ONE);

        // Act & Assert
        assertEquals("shareCode_test", entity.getShareCode());
        assertEquals("name_test", entity.getName());
        assertEquals("caseId_test", entity.getCaseId());
        assertEquals("mainboardId_test", entity.getMainboardId());
        assertEquals("cpuId_test", entity.getCpuId());
        assertEquals("coolerId_test", entity.getCoolerId());
        assertEquals("ramId_test", entity.getRamId());
        assertEquals("storageId_test", entity.getStorageId());
        assertEquals("gpuId_test", entity.getGpuId());
        assertEquals("psuId_test", entity.getPsuId());
        assertEquals(java.math.BigDecimal.ONE, entity.getTotalPrice());
    }
}

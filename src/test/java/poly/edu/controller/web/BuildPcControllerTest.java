package poly.edu.controller.web;

import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import java.util.List;
import java.util.Map;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import poly.edu.dao.PcComboDAO;
import poly.edu.dao.ProductDAO;
import poly.edu.entity.Category;
import poly.edu.entity.Product;

@ExtendWith(MockitoExtension.class)
public class BuildPcControllerTest {

    private MockMvc mockMvc;

    @Mock
    private ProductDAO productDAO;

    @Mock
    private PcComboDAO pcComboDAO;

    @InjectMocks
    private BuildPcController buildPcController;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(buildPcController).build();
    }

    @Test
    void testBuildPc_InvalidCpuDescription_DoesNotCrashAndProvidesFallback() throws Exception {
        // Arrange
        Category cpuCategory = new Category();
        cpuCategory.setName("CPU");

        Product badCpu = new Product();
        badCpu.setId(1);
        badCpu.setName("Intel i9 14900K");
        badCpu.setPrice(15000000.0);
        badCpu.setCategory(cpuCategory);
        // "TDP: INVALID" has no numbers, should trigger NumberFormatException fallback
        badCpu.setDescription("High End CPU TDP: INVALID Watts"); 

        Product goodCpu = new Product();
        goodCpu.setId(2);
        goodCpu.setName("AMD Ryzen 9 7950X");
        goodCpu.setPrice(14000000.0);
        goodCpu.setCategory(cpuCategory);
        goodCpu.setDescription("TDP: 170W"); 

        when(productDAO.findAll()).thenReturn(List.of(badCpu, goodCpu));
        when(pcComboDAO.findAll()).thenReturn(List.of());

        // Act & Assert
        var result = mockMvc.perform(get("/build-pc"))
               .andExpect(status().isOk())
               .andExpect(view().name("build-pc"))
               .andExpect(model().attributeExists("productsData", "combosData"))
               .andReturn();

        // STRICT ASSERTION: Verify the model actually contains the fallback power = 0
        @SuppressWarnings("unchecked")
        Map<String, List<Map<String, Object>>> productsData = 
            (Map<String, List<Map<String, Object>>>) result.getModelAndView().getModel().get("productsData");
            
        List<Map<String, Object>> cpus = productsData.get("cpu");
        org.junit.jupiter.api.Assertions.assertNotNull(cpus, "CPU list should not be null");
        org.junit.jupiter.api.Assertions.assertEquals(2, cpus.size(), "Should contain 2 CPUs");
        
        // Find the bad CPU and verify its power fell back to 0
        Map<String, Object> badCpuData = cpus.stream().filter(c -> c.get("id").equals(1)).findFirst().get();
        org.junit.jupiter.api.Assertions.assertEquals(0, badCpuData.get("power"), "Fallback power must be exactly 0 for invalid description");

        // Find the good CPU and verify its power parsed correctly
        Map<String, Object> goodCpuData = cpus.stream().filter(c -> c.get("id").equals(2)).findFirst().get();
        org.junit.jupiter.api.Assertions.assertEquals(170, goodCpuData.get("power"), "Valid TDP must parse correctly to 170");

        verify(productDAO, times(1)).findAll();
        verify(pcComboDAO, times(1)).findAll();
    }

    @Test
    void testBuildPc_EmptyDatabase_ReturnsViewSuccessfully() throws Exception {
        // Arrange
        when(productDAO.findAll()).thenReturn(List.of());
        when(pcComboDAO.findAll()).thenReturn(List.of());

        // Act & Assert
        mockMvc.perform(get("/build-pc"))
               .andExpect(status().isOk())
               .andExpect(view().name("build-pc"));
    }
}

package poly.edu;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.*;

import java.util.ArrayList;
import java.util.Date;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.transaction.annotation.Transactional;

import poly.edu.entity.User;
import poly.edu.repository.UserRepository;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class ProfilePageTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Test
    void profilePageRendersForLoggedInUser() throws Exception {
        String email = "profile-test@example.com";
        String password = "12345678";

        User user = new User();
        user.setEmail(email);
        user.setUsername(email);
        user.setFullName("Profile Test");
        user.setPassword(passwordEncoder.encode(password));
        user.setBirthday(new Date());
        user.setUserRoles(new ArrayList<>());
        userRepository.saveAndFlush(user);

        MvcResult login = mockMvc.perform(post("/login")
                .with(csrf())
                .param("username", email)
                .param("password", password))
                .andExpect(status().is3xxRedirection())
                .andReturn();

        mockMvc.perform(get("/profile").session((org.springframework.mock.web.MockHttpSession) login.getRequest().getSession(false)))
                .andExpect(status().isOk())
                .andExpect(view().name("account/profile"));
    }

    @Test
    void profileUpdateFormPersistsSubmittedValues() throws Exception {
        String email = "profile-update@example.com";
        String password = "12345678";

        User user = new User();
        user.setEmail(email);
        user.setUsername(email);
        user.setFullName("Old Name");
        user.setPassword(passwordEncoder.encode(password));
        user.setUserRoles(new ArrayList<>());
        userRepository.saveAndFlush(user);

        MvcResult login = mockMvc.perform(post("/login")
                .with(csrf())
                .param("username", email)
                .param("password", password))
                .andExpect(status().is3xxRedirection())
                .andReturn();

        mockMvc.perform(post("/profile/update")
                .with(csrf())
                .session((org.springframework.mock.web.MockHttpSession) login.getRequest().getSession(false))
                .param("firstName", "Nguyen")
                .param("lastName", "Van A")
                .param("email", email)
                .param("phone", "0901234567")
                .param("birthday", "2000-01-02")
                .param("gender", "true"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/profile?tab=info"));

        User updated = userRepository.findByEmail(email).orElseThrow();
        assertEquals("Nguyen Van A", updated.getFullName());
        assertEquals("0901234567", updated.getPhone());
        assertEquals(Boolean.TRUE, updated.getGender());
        assertNotNull(updated.getBirthday());
    }
}

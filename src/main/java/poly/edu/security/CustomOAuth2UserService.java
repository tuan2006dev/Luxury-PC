package poly.edu.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import poly.edu.entity.User;
import poly.edu.repository.UserRepository;

import java.util.Optional;

@Service
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private poly.edu.dao.RoleDAO roleDAO;

    @Autowired
    private poly.edu.dao.UserRoleDAO userRoleDAO;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        // Fetch user from Google/Facebook
        OAuth2User oauth2User = super.loadUser(userRequest);

        String clientName = userRequest.getClientRegistration().getClientName();
        String registrationId = userRequest.getClientRegistration().getRegistrationId();

        CustomOAuth2User customOAuth2User = new CustomOAuth2User(oauth2User, clientName);

        // Save or update user in our database
        processOAuth2User(customOAuth2User, registrationId);

        return customOAuth2User;
    }

    private void processOAuth2User(CustomOAuth2User oauth2User, String registrationId) {
        String email = oauth2User.getEmail();

        // Fix ClassCastException by safely converting the attributes to String
        Object subObj = oauth2User.getAttribute("sub");
        Object idObj = oauth2User.getAttribute("id");
        String providerId = subObj != null ? String.valueOf(subObj) : (idObj != null ? String.valueOf(idObj) : null);

        // First, try to find user by providerId
        Optional<User> userOptional = Optional.empty();
        if (providerId != null) {
            userOptional = userRepository.findByProviderId(providerId);
        }

        // If not found by providerId, try by email (if email is not null)
        if (!userOptional.isPresent() && email != null) {
            userOptional = userRepository.findByEmail(email);
        }

        User user;
        if (userOptional.isPresent()) {
            user = userOptional.get();
            // Handle null authProvider or different provider logic
            if (user.getAuthProvider() == null || !user.getAuthProvider().name().equalsIgnoreCase(registrationId)) {
                user.setAuthProvider(User.AuthProvider.valueOf(registrationId.toUpperCase()));
                user.setProviderId(providerId);
                userRepository.save(user);
            }
        } else {
            // New user registration via OAuth2
            user = new User();

            // If email is null (e.g., from Facebook), generate a fallback email
            if (email == null) {
                String fallbackId = providerId != null ? providerId : "user_" + System.currentTimeMillis();
                email = fallbackId + "@" + registrationId.toLowerCase() + ".com";
            }
            user.setEmail(email);

            // Extract username from email
            String baseUsername = email.split("@")[0];
            user.setUsername(baseUsername);

            Object nameObj = oauth2User.getAttribute("name");
            String name = nameObj != null ? String.valueOf(nameObj) : baseUsername;
            user.setFullName(name);

            // Set a dummy password to satisfy NOT NULL database constraints
            // user.setPassword(java.util.UUID.randomUUID().toString());

            user.setAuthProvider(User.AuthProvider.valueOf(registrationId.toUpperCase()));
            user.setProviderId(providerId);

            User savedUser = userRepository.save(user);

            // Assign default USER role
            poly.edu.entity.Role defaultRole = roleDAO.findByName("USER");
            if (defaultRole != null) {
                poly.edu.entity.UserRole ur = new poly.edu.entity.UserRole();
                ur.setUser(savedUser);
                ur.setRole(defaultRole);
                userRoleDAO.save(ur);
            }
        }
    }
}

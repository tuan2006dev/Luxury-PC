package poly.edu.security;

import lombok.RequiredArgsConstructor;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import poly.edu.entity.User;
import poly.edu.repository.UserRepository;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    private final UserRepository userRepository;

    private final poly.edu.dao.RoleDAO roleDAO;

    private final poly.edu.dao.UserRoleDAO userRoleDAO;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        // Fetch user from Google/Facebook
        OAuth2User oauth2User = super.loadUser(userRequest);

        String clientName = userRequest.getClientRegistration().getClientName();
        String registrationId = userRequest.getClientRegistration().getRegistrationId();

        CustomOAuth2User customOAuth2User = new CustomOAuth2User(oauth2User, clientName);

        // Save or update user in our database & return saved User
        User dbUser = processOAuth2User(customOAuth2User, registrationId);

        // Check if the user account is locked
        if (dbUser != null && !Boolean.TRUE.equals(dbUser.getStatus())) {
            throw new OAuth2AuthenticationException(
                    new org.springframework.security.oauth2.core.OAuth2Error("account_locked",
                            "Tài khoản của bạn đã bị khóa.", null));
        }

        return customOAuth2User;
    }

    private User processOAuth2User(CustomOAuth2User oauth2User, String registrationId) {
        String email = oauth2User.getEmail();

        // Fix ClassCastException by safely converting the attributes to String
        Object subObj = oauth2User.getAttribute("sub");
        Object idObj = oauth2User.getAttribute("id");
        String providerId = subObj != null ? String.valueOf(subObj) : (idObj != null ? String.valueOf(idObj) : null);

        // First, try to find user by provider specific ID
        Optional<User> userOptional = Optional.empty();
        if (providerId != null) {
            if ("facebook".equalsIgnoreCase(registrationId)) {
                userOptional = userRepository.findByFacebookId(providerId);
            } else {
                userOptional = userRepository.findByGoogleId(providerId);
            }
        }

        // If not found by OAuth ID, try by email (if email is not null)
        if (!userOptional.isPresent() && email != null) {
            userOptional = userRepository.findByEmail(email);
        }

        User user;
        if (userOptional.isPresent()) {
            user = userOptional.get();
            // If user already exists, link OAuth ID if not linked yet, but NEVER overwrite authProvider!
            if ("facebook".equalsIgnoreCase(registrationId)) {
                if (user.getFacebookId() == null && providerId != null) {
                    user.setFacebookId(providerId);
                    user = userRepository.save(user);
                }
            } else {
                if (user.getGoogleId() == null && providerId != null) {
                    user.setGoogleId(providerId);
                    user = userRepository.save(user);
                }
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

            user.setAuthProvider(User.AuthProvider.valueOf(registrationId.toUpperCase()));
            if ("facebook".equalsIgnoreCase(registrationId)) {
                user.setFacebookId(providerId);
            } else {
                user.setGoogleId(providerId);
            }

            user.setForceChangePassword(true);
            user = userRepository.save(user);

            // Assign default USER role
            poly.edu.entity.Role defaultRole = roleDAO.findByName("USER");
            if (defaultRole != null) {
                poly.edu.entity.UserRole ur = new poly.edu.entity.UserRole();
                ur.setUser(user);
                ur.setRole(defaultRole);
                userRoleDAO.save(ur);
            }
        }
        return user;
    }
}

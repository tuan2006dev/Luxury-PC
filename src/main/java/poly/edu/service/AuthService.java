package poly.edu.service;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import poly.edu.dao.UserDAO;
import poly.edu.entity.User;
import java.util.List;


@Service
@RequiredArgsConstructor
public class AuthService implements UserDetailsService {	

    final UserDAO userDAO;

    public User login(String email, String password){
        return userDAO.findByEmailAndPassword(email, password);
    }

    public User register(User user){
        return userDAO.save(user);
    }


    @Override
    public UserDetails loadUserByUsername(String identifier) throws UsernameNotFoundException {
        // Use JOIN FETCH queries to load user + roles in one SQL (safe with LAZY fetch)
        User user = userDAO.findByEmailWithRoles(identifier);
        if (user == null) {
            user = userDAO.findByUsernameWithRoles(identifier);
        }
        if (user == null) {
            throw new UsernameNotFoundException("User not found: " + identifier);
        }

        List<String> roles = user.getUserRoles().stream()
                .map(ur -> ur.getRole().getName())
                .toList();

        if (roles.isEmpty()) roles = List.of("USER");

        boolean isLocked = !Boolean.TRUE.equals(user.getStatus());

        return org.springframework.security.core.userdetails.User.builder()
                .username(user.getEmail())
                .password(user.getPassword())
                .disabled(isLocked)
                .roles(roles.toArray(new String[0]))
                .build();
    }

}

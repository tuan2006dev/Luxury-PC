package poly.edu.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import poly.edu.dao.UserDAO;
import poly.edu.entity.User;
<<<<<<< Updated upstream
=======
import poly.edu.repository.UserRepository;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
>>>>>>> Stashed changes

@Service
public class AuthService {	

    @Autowired
    UserDAO userDAO;

    public User login(String email,String password){
        return userDAO.findByEmailAndPassword(email,password);
    }

    public User register(User user){
        return userDAO.save(user);
    }

<<<<<<< Updated upstream
=======
    @Override
    public UserDetails loadUserByUsername(String identifier) throws UsernameNotFoundException {
        User user = userDAO.findByEmail(identifier);
        if (user == null) {
            user = userDAO.findByUsername(identifier);
        }
        if (user == null) {
            throw new UsernameNotFoundException("User not found: " + identifier);
        }

        List<String> roles = user.getUserRoles().stream()
                .map(ur -> ur.getRole().getName())
                .toList();

        if (roles.isEmpty()) roles = List.of("USER");

        return org.springframework.security.core.userdetails.User.builder()
                .username(user.getEmail())
                .password(user.getPassword())
                .roles(roles.toArray(new String[0]))
                .build();
    }
>>>>>>> Stashed changes
}
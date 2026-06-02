package poly.edu.dao;

import org.springframework.data.jpa.repository.JpaRepository;

import poly.edu.entity.User;

public interface UserDAO extends JpaRepository<User, Integer>{

    User findByEmail(String email);
// Updated upstream

    User findByEmailAndPassword(String email,String password);

    User findByUsername(String username);
//Stashed changes
}
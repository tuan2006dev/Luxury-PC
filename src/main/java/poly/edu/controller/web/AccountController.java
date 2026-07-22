package poly.edu.controller.web;


import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import poly.edu.entity.User;
import poly.edu.repository.UserRepository;
import poly.edu.dao.RoleDAO;
import poly.edu.dao.UserRoleDAO;
import poly.edu.entity.Role;
import poly.edu.entity.UserRole;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Optional;

@Controller
@RequestMapping("/admin/account")
@SuppressWarnings("null")
@RequiredArgsConstructor
public class AccountController {

    private final UserRepository userRepository;

    private final RoleDAO roleDAO;

    private final UserRoleDAO userRoleDAO;


    // ===============================
    // hiển thị form + danh sách user
    // ===============================
    @GetMapping
    public String users(Model model){

        model.addAttribute("user", new User());

        model.addAttribute(
                "users",
                userRepository.findAllUserNotAdmin()
        );

        return "admin/account";
    }



    // ===============================
    // lưu user (thêm hoặc update)
    // ===============================
    @PostMapping("/save")
    @Transactional
    public String saveUser(
            @ModelAttribute User user,
            @RequestParam(value = "roleName", defaultValue = "USER") String roleName
    ){

        // nếu không nhập password thì giữ nguyên password cũ
        if(user.getId() != null){

            Optional<User> oldUser =
                    userRepository.findById(
                            user.getId()
                    );

            if(oldUser.isPresent()){

                if(user.getPassword() == null
                        || user.getPassword().isEmpty()){

                    user.setPassword(
                            oldUser.get()
                                    .getPassword()
                    );
                }
            }
        }

        user = userRepository.save(user);
        
        Role role = roleDAO.findByName(roleName);
        if (role != null) {
            userRoleDAO.deleteByUserId(user.getId());
            UserRole userRole = new UserRole();
            userRole.setUser(user);
            userRole.setRole(role);
            userRoleDAO.save(userRole);
        }

        return "redirect:/admin/account";
    }



    // ===============================
    // load user lên form để sửa
    // ===============================
    @GetMapping("/edit/{id}")
    public String editUser(
            @PathVariable Integer id,
            Model model
    ){

        Optional<User> userOptional =
                userRepository.findById(id);

        if(userOptional.isPresent()){
            User u = userOptional.get();
            model.addAttribute("user", u);
            String currentRole = "USER";
            if(u.getUserRoles() != null && !u.getUserRoles().isEmpty()) {
                currentRole = u.getUserRoles().get(0).getRole().getName();
            }
            model.addAttribute("currentRole", currentRole);
        }else{
            model.addAttribute("currentRole", "USER");

            model.addAttribute(
                    "user",
                    new User()
            );
        }

        model.addAttribute(
                "users",
                userRepository.findAll()
        );

        return "admin/account";
    }



    // ===============================
    // khóa user
    // ===============================
    @PostMapping("/lock/{id}")
    public String lockUser(
            @PathVariable Integer id
    ){

        Optional<User> userOptional =
                userRepository.findById(id);

        if(userOptional.isPresent()){

            User user =
                    userOptional.get();

            user.setStatus(false);

            userRepository.save(user);
        }

        return "redirect:/admin/account";
    }



    // ===============================
    // mở khóa user
    // ===============================
    @PostMapping("/unlock/{id}")
    public String unlockUser(
            @PathVariable Integer id
    ){

        Optional<User> userOptional =
                userRepository.findById(id);

        if(userOptional.isPresent()){

            User user =
                    userOptional.get();

            user.setStatus(true);

            userRepository.save(user);
        }

        return "redirect:/admin/account";
    }



    // ===============================
    // xóa user
    // ===============================
    @PostMapping("/delete/{id}")
    public String deleteUser(
            @PathVariable Integer id
    ){

        userRepository.deleteById(id);

        return "redirect:/admin/account";
    }

}

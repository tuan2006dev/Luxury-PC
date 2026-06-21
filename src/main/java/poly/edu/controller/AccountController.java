package poly.edu.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import poly.edu.entity.User;
import poly.edu.repository.UserRepository;

import java.util.Optional;

@Controller
@RequestMapping("/admin/account")
public class AccountController {

    @Autowired
    private UserRepository userRepository;


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
    public String saveUser(
            @ModelAttribute User user
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

        userRepository.save(user);

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

            model.addAttribute(
                    "user",
                    userOptional.get()
            );

        }else{

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
    @GetMapping("/lock/{id}")
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
    @GetMapping("/unlock/{id}")
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

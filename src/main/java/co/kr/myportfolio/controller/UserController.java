package co.kr.myportfolio.controller;

import co.kr.myportfolio.vo.User;
import co.kr.myportfolio.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/user")
public class UserController {
    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    @Autowired
    private UserService userService;

    // 페이지 이동 - 유저 디테일
    @GetMapping("/{id}")
    public String getUser(@PathVariable int id, Model model) {
        User user = userService.getUserById(id);
        model.addAttribute("user", user);
        return "userDetail"; // userDetail.jsp로 연결
    }
    
    // 페이지 이동 - 회원가입
    @GetMapping("/register")
    public String signup() {
        return "register";
    }
    
    // API - 회원가입
    @PostMapping("/register")
    @ResponseBody
    public Map<String, Object> registerUser(@RequestBody User user) {
        Map<String, Object> result = new HashMap<>();
        user.setPassword(passwordEncoder.encode(user.getPassword()));

        System.out.println("user = " + user);

        String message = userService.registerUser(user);

        result.put("status", "success");
        result.put("message", message);
        result.put("id", user.getUserId());

        return result;
    }

    // API - 닉네임 중복확인
    @PostMapping("/nickname/exist")
    @ResponseBody
    public boolean checkNickname(@RequestBody Map<String, String> request) {
        String nickname = request.get("nickname");
        return userService.isNicknameExists(nickname);
    }

    // API - 아이디 중복확인
    @PostMapping("/userId/exist")
    @ResponseBody
    public boolean checkUserId(@RequestBody Map<String, String> request) {
        String nickname = request.get("userId");
        return userService.isUserIdExists(nickname);
    }

    @PostMapping("/update")
    public String updateUser(@ModelAttribute User user) {
        userService.updateUser(user);
        return "redirect:/user/" + user.getUserId();
    }

    @GetMapping("/delete/{id}")
    public String deleteUser(@PathVariable int id) {
        userService.deleteUser(id);
        return "redirect:/";
    }
}

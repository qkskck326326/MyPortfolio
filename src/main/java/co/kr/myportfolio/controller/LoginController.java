package co.kr.myportfolio.controller;

import co.kr.myportfolio.service.UserService;
import co.kr.myportfolio.vo.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
public class LoginController {
    @Autowired
    private UserService userService;

    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    @GetMapping("login")
    public String login() {
        return "login";
    }

    @PostMapping("/login")
    @ResponseBody
    public Map<String, Object> login(@RequestBody Map<String, String> payload,
                                     HttpSession session) {
        String userId = payload.get("userId");
        String password = payload.get("password");

        Map<String, Object> result = new HashMap<>();

        User user = userService.getUserByUserId(userId);
        System.out.println("user = " + user);
        
        if (user != null && passwordEncoder.matches(password, user.getPassword())) {
            result.put("status", "success");
            session.setAttribute("user_pid", user.getUserPid());
            session.setAttribute("user_id", user.getUserId());
            session.setAttribute("user_nickname", user.getNickname());
            session.setAttribute("user_thumbnail", user.getUserThumbnail());
        } else {
            result.put("status", "fail");
            result.put("message", "아이디 또는 비밀번호를 확인해주세요.");
        }

        return result;
    }

    @PostMapping("/logout")
    @ResponseBody
    public Map<String, Object> logout(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        session.invalidate(); // 세션 삭제 (로그아웃)

        result.put("status", "success");
        return result;
    }

}

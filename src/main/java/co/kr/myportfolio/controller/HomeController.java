package co.kr.myportfolio.controller;

import co.kr.myportfolio.vo.User;
import co.kr.myportfolio.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {
    @Autowired
    UserService userService;

    @GetMapping("/")
    public String home() {
        return "index";
    }
}

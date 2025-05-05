package co.kr.myportfolio.controller;

import co.kr.myportfolio.service.PortfolioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/personal")
public class PersonalController {
    @Autowired
    private PortfolioService portfolioService;

    // 특정개인 페이지로
    @GetMapping("/{userPid}")
    public String goPersonalPage(@PathVariable int userPid, Model model) {
        model.addAttribute("userPid", userPid);
        return "personalPage";
    }

    // 하트 누른 글 보기
    @GetMapping("/liked")
    public String goLikePostPage(HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        // 세션에서 유저 정보 가져오기
        Integer userPid = (Integer) session.getAttribute("user_pid");

        if (userPid == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "로그인이 필요합니다.");
            return "redirect:/login";
        }

        return "likedPostPage";
    }

}

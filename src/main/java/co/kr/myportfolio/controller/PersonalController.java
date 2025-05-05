package co.kr.myportfolio.controller;

import co.kr.myportfolio.dto.PersonalPortfolioDTO;
import co.kr.myportfolio.dto.PortfolioCardDTO;
import co.kr.myportfolio.dto.UserInfoAndTagsDTO;
import co.kr.myportfolio.service.PersonalService;
import co.kr.myportfolio.service.PortfolioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/personal")
public class PersonalController {
    @Autowired
    private PersonalService personalService;

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

    // API - 특정 유저 포트폴리오 모든 테그 및 유저 정보 반환
    @PostMapping("/userAndTags/info")
    @ResponseBody
    public UserInfoAndTagsDTO goUserInfoAndTags(@RequestParam int userPid){
        return personalService.goUserInfoAndTags(userPid);
    }

    // API - 특정 유저 작성 포트폴리오 반환
    @PostMapping("/portfolio/cards")
    public ResponseEntity<?> getPersonalPortfolio(
                                                  @RequestParam int userPid,
                                                  @RequestParam(defaultValue = "0") int page,
                                                  @RequestParam(defaultValue = "20") int size,
                                                  @RequestParam(required = false) String keyword,
                                                  @RequestParam(required = false) List<String> tags){
        System.out.println("들어온 테그 = " + tags);
        Map<String, Object> params = new HashMap<>();
        params.put("offset", page * size);
        params.put("limit", size);
        params.put("userPid", userPid);
        if (keyword != null && !keyword.isBlank()) {
            params.put("keyword", keyword);
        }
        if (tags!= null && !tags.isEmpty()) {
            params.put("tags", tags);
        }

        List<PersonalPortfolioDTO> portfolioCardList = personalService.getPersonalPortfolio(params);

        Map<String, Object> response = new HashMap<>();
        response.put("portfolioCardList", portfolioCardList);
        response.put("message", "프로젝트 카드 리스트 불러옴");

        // 첫 번째 요청일 경우에만 totalCount 포함
        if (page == 0) {
            int totalCount = personalService.getPersonalPortfolioTotalCount(params);
            System.out.println("Controller totalCount = " + totalCount);
            response.put("totalCount", totalCount);
        }

        return ResponseEntity.ok(response);
    }

}//

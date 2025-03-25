package co.kr.myportfolio.controller;

import co.kr.myportfolio.dto.PortfolioRequestDTO;
import co.kr.myportfolio.dto.PortfolioResponseDTO;
import co.kr.myportfolio.service.PortfolioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/portfolio")
public class PortfolioController {
    @Autowired
    private PortfolioService portfolioService;
    
    // 포트폴리오 등록 페이지 이동
    @GetMapping("/new")
    public String newPortfolio() {
        return "portfolioForm";
    }
    
    
    // 포트폴리오 등록
    @PostMapping("/post")
    public ResponseEntity<?> postPortfolio(@RequestBody PortfolioRequestDTO portfolioRequestDTO,
                                                             HttpSession session) {
        System.out.println("등록 실행됨");

        // 세션에서 유저 정보 가져오기
        int userPid = (int) session.getAttribute("user_pid");
        String userNickname = (String) session.getAttribute("user_nickname");


        System.out.println("userPid = " + userPid);
        System.out.println("userNickName = " + userNickname);

        if (userPid == 0 || userNickname == null) {
            return ResponseEntity.badRequest().body("로그인이 필요합니다.");
        }

        // 세션에서 가져온 userPid & nickname 를 DTO에 설정
        portfolioRequestDTO.setUserPid(userPid);
        portfolioRequestDTO.setUserNickname(userNickname);

        System.out.println("portfolioRequestDTO = " + portfolioRequestDTO);

        int portfolioId = portfolioService.postPortfolio(portfolioRequestDTO);

        Map<String, Object> response = new HashMap<>();
        response.put("portfolioId", portfolioId);
        response.put("message", "프로젝트가 성공적으로 등록되었습니다!");

        System.out.println("반환 직전");
        return ResponseEntity.ok(response); // JSON 형태로 응답
    }
    
    // 포트폴리오 보기 페이지 이동
    @GetMapping("/{portfolioId}")
    public String portfolioDetail(@PathVariable int portfolioId, Model model) {
        PortfolioResponseDTO portfolioResponseDTO = portfolioService.getPortfolio(portfolioId);

        model.addAttribute("portfolio", portfolioResponseDTO.getPortfolio());
        model.addAttribute("portfolioTags", portfolioResponseDTO.getTags());

        return "portfolioDetail";
    }



}

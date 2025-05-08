package co.kr.myportfolio.controller;

import co.kr.myportfolio.dto.PortfolioCardDTO;
import co.kr.myportfolio.dto.PortfolioRequestDTO;
import co.kr.myportfolio.dto.PortfolioResponseDTO;
import co.kr.myportfolio.dto.SearchWithoutIndexDTO;
import co.kr.myportfolio.service.PortfolioService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
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
@RequestMapping("/portfolio")
public class PortfolioController {
    @Autowired
    private PortfolioService portfolioService;
    
    // 포트폴리오 등록 페이지 이동
    @GetMapping("/new")
    public String newPortfolio(HttpSession session , Model model) {
        // 세션에서 유저 정보 가져오기
        int userPid = (int) session.getAttribute("user_pid");
        String userNickname = (String) session.getAttribute("user_nickname");

        if (userPid == 0 || userNickname == null) {
            // 세션 정보 없을시 로그인 페이지로
            model.addAttribute("errorMessage", "로그인이 필요합니다!");
            return "redirect:/login";
        }

        return "portfolioForm";
    }
    
    // 포트폴리오 수정 페이지 이동
    @GetMapping("/update/{portfolioId}")
    public String updatePortfolio(@PathVariable Integer portfolioId, Model model, HttpSession session) throws JsonProcessingException {
        PortfolioResponseDTO portfolioDTO = portfolioService.getPortfolio(portfolioId, 0);

        // 세션에서 유저 정보 가져오기
        int userPid = (int) session.getAttribute("user_pid");

        if (userPid != portfolioDTO.getPortfolio().getUserPid()) {
            model.addAttribute("message", "권한이 없습니다.");
            return "redirect:/portfolio/" + portfolioId;
        }

        // JSON으로 변환해서 넘김
        ObjectMapper mapper = new ObjectMapper();
        String portfolioJson = mapper.writeValueAsString(portfolioDTO);

        model.addAttribute("portfolioJson", portfolioJson);
        return "portfolioForm";
    }
    
    
    // 포트폴리오 등록
    @PostMapping("/post")
    public ResponseEntity<?> postPortfolio(@RequestBody PortfolioRequestDTO portfolioRequestDTO,
                                                             HttpSession session) {
        // 세션에서 유저 정보 가져오기
        int userPid = (int) session.getAttribute("user_pid");
        String userNickname = (String) session.getAttribute("user_nickname");

        if (userPid == 0 || userNickname == null) {
            return ResponseEntity.badRequest().body("로그인이 필요합니다.");
        }

        // 세션에서 가져온 userPid & nickname 를 DTO에 설정
        portfolioRequestDTO.setUserPid(userPid);
        portfolioRequestDTO.setUserNickname(userNickname);

        int portfolioId = portfolioService.postPortfolio(portfolioRequestDTO);

        Map<String, Object> response = new HashMap<>();
        response.put("portfolioId", portfolioId);
        response.put("message", "프로젝트가 성공적으로 등록되었습니다!");

        return ResponseEntity.ok(response); // JSON 형태로 응답
    }

    // 포트폴리오 수정
    @PostMapping("/update")
    public ResponseEntity<?> updatePortfolio(@RequestBody PortfolioRequestDTO portfolioRequestDTO,
                                             HttpSession session) {
        // 세션에서 유저 정보 가져오기
        int userPid = (int) session.getAttribute("user_pid");
        String userNickname = (String) session.getAttribute("user_nickname");

        if (userPid == 0 || userNickname == null) {
            return ResponseEntity.badRequest().body("로그인이 필요합니다.");
        }

        // 세션에서 가져온 userPid & nickname 를 DTO에 설정
        portfolioRequestDTO.setUserPid(userPid);
        portfolioRequestDTO.setUserNickname(userNickname);

        portfolioService.updatePortfolio(portfolioRequestDTO);

        Map<String, Object> response = new HashMap<>();
        response.put("portfolioId", portfolioRequestDTO.getPortfolioId());
        response.put("message", "프로젝트가 성공적으로 수정되었습니다!");
        return ResponseEntity.ok(response);
    }

    // 포트폴리오 카드 리스트 조회 -- 수정이나 주석처리 필요
    @GetMapping("/get")
    public ResponseEntity<?> getPortfolioList(){
        List<PortfolioCardDTO> portfolioCardList = portfolioService.getPortfolioCardList();

        Map<String, Object> response = new HashMap<>();
        response.put("portfolioCardList", portfolioCardList);
        response.put("message", "프로젝트 카드 리스트 불러옴");

        return ResponseEntity.ok(response);
    }

    @GetMapping("/list")
    @ResponseBody
    public ResponseEntity<?> getPortfoliosWithPaging(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(defaultValue = "latest") String orderBy,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) List<String> tags
    )
    {
        int offset = page * size;
        Map<String, Object> params = new HashMap<>();
        params.put("offset", offset);
        params.put("limit", size);
        params.put("orderBy", orderBy);
        if (keyword != null && !keyword.isBlank()) {
            params.put("keyword", keyword);
        }
        if (tags!= null && !tags.isEmpty()) {
            params.put("tags", tags);
        }

        List<PortfolioCardDTO> portfolioCardList = portfolioService.getPortfolioCardListWithSortBy(params);

        Map<String, Object> response = new HashMap<>();
        response.put("portfolioCardList", portfolioCardList);
        response.put("message", "프로젝트 카드 리스트 불러옴");

        // 첫 번째 요청일 경우에만 totalCount 포함
        if (page == 0) {
            int totalCount = portfolioService.getPortfolioTotalCount(params);
            response.put("totalCount", totalCount);
        }

        return ResponseEntity.ok(response);
    }
    
    // 좋아요 표시한 게시글 보기
    @GetMapping("/liked/list")
    @ResponseBody
    public ResponseEntity<?> getLikedPortfoliosWithPaging(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(defaultValue = "latest") String orderBy,
            @RequestParam int userPid
    )
    {
        int offset = page * size;
        Map<String, Object> params = new HashMap<>();
        params.put("offset", offset);
        params.put("limit", size);
        params.put("orderBy", orderBy);
        params.put("userPid", userPid);

        List<PortfolioCardDTO> portfolioCardList = portfolioService.getLikedPortfolioCardListWithSortBy(params);///

        Map<String, Object> response = new HashMap<>();
        response.put("portfolioCardList", portfolioCardList);
        response.put("message", "프로젝트 카드 리스트 불러옴");

        // 첫 번째 요청일 경우에만 totalCount 포함
        if (page == 0) {
            int totalCount = portfolioService.getLikedPortfolioTotalCount(params);
            response.put("totalCount", totalCount);
        }

        return ResponseEntity.ok(response);
    }

    // 포트폴리오 보기 페이지 이동 ( 상세 )
    @GetMapping("/{portfolioId}")
    public String portfolioDetail(@PathVariable int portfolioId, Model model, HttpSession session) {
        Integer userPidObj = (Integer) session.getAttribute("user_pid");
        int userPid = (userPidObj != null) ? userPidObj : 0; // 기본값 0 (비회원)

        PortfolioResponseDTO portfolioResponseDTO = portfolioService.getPortfolio(portfolioId, userPid);

        model.addAttribute("portfolio", portfolioResponseDTO.getPortfolio());
        model.addAttribute("portfolioTags", portfolioResponseDTO.getTags());
        if(userPid != 0) { // 회원이라면
            model.addAttribute("is_like", portfolioResponseDTO.is_like());
        }else {
            model.addAttribute("is_like", false);
        }

        return "portfolioDetail";
    }

    // 포트폴리오 좋아요 표시
    @PostMapping("/{portfolioId}/like")
    @ResponseBody
    public ResponseEntity<?> likePortfolio(@PathVariable int portfolioId, HttpSession session) {
        // 세션에서 로그인된 사용자 ID 가져오기
        Integer userPidObj = (Integer) session.getAttribute("user_pid");

        // 로그인 안 되어 있으면 401 반환
        if (userPidObj == null) {
            return ResponseEntity
                    .status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("message", "로그인이 필요합니다."));
        }

        int userPid = userPidObj;

        // 좋아요 상태 토글
        boolean liked = portfolioService.togglePortfolioLike(userPid, portfolioId);

        return ResponseEntity.ok(Map.of(
                "liked", liked,
                "message", liked ? "좋아요 완료" : "좋아요 취소"
        ));
    }
    
    // 메인페이지 외의 다른 페이지에서의 검색 버튼 클릭 - 검색설정 가지고 메인으로 이동
    @PostMapping("/search/withoutIndexPage")
    public String searchWithoutIndex(RedirectAttributes redirectAttributes,
                                     @ModelAttribute SearchWithoutIndexDTO searchOption){
        System.out.println("searchOption = " + searchOption);
        redirectAttributes.addFlashAttribute("takenSearchOption", searchOption);
        return "redirect:/";
    }

}

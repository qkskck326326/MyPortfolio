package co.kr.myportfolio.controller;

import co.kr.myportfolio.dto.UserRequestDTO;
import co.kr.myportfolio.dto.UserResponseDTO;
import co.kr.myportfolio.vo.User;
import co.kr.myportfolio.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
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
    @GetMapping("/{pid}")
    public String getUser(@PathVariable int pid, Model model) {
        User user = userService.getUserByPid(pid);
        model.addAttribute("user", user);
        return "userDetail"; // userDetail.jsp로 연결
    }
    
    // 페이지 이동 - 회원가입
    @GetMapping("/register")
    public String goSignup() {
        return "register";
    }

    // 페이지 이동 - 회원정보 페이지
    @GetMapping("/info")
    public String goUserInfo(Model model, HttpSession session) {
        // 세션에서 유저 정보 가져오기
        Integer userPid = (Integer) session.getAttribute("user_pid");

        if (userPid == null) {
            model.addAttribute("errorMessage", "로그인이 필요합니다.");
            return "redirect:/login";
        }else {
            model.addAttribute("user_pid", userPid);

            return "userInfo";
        }
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
    
    // API - 유저 정보 수정
    @PostMapping("/update/info")
    @ResponseBody
    public ResponseEntity<String> updateUserInfo(@RequestBody UserRequestDTO requestDTO, HttpSession session) {
        Integer userPid = (Integer) session.getAttribute("user_pid");
        if (userPid == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인 필요");
        }

        userService.updateUserInfo(userPid, requestDTO);
        return ResponseEntity.ok("정보 수정 완료");
    }

    // API - 유저 썸네일 업데이트
    @PostMapping("/update/thumbnail")
    public ResponseEntity<?> updateUserThumbnail(@RequestBody Map<String, String> request, HttpSession session) {
        String thumbnail = request.get("thumbnail");
        Integer userPid = (Integer) session.getAttribute("user_pid");

        if (userPid == null) {
            // 401 Unauthorized 반환
            return ResponseEntity.status(401).body("로그인이 필요합니다.");
        }

        Map<String, Object> param = new HashMap<>();
        param.put("userPid", userPid);
        param.put("thumbnail", thumbnail);
        userService.updateUserThumbnail(param);

        // 200 OK + 성공 메시지
        return ResponseEntity.ok("썸네일이 성공적으로 수정되었습니다.");
    }
    
    // API - 유저정보 삭제 - 확인필요
    @GetMapping("/delete/{id}")
    @ResponseBody
    public String deleteUser(@PathVariable int id) {
        userService.deleteUser(id);
        return "redirect:/";
    }

    // API - 자신의 정보 불러오기
    @PostMapping("/get/myInfo")
    @ResponseBody
    public UserResponseDTO getMyInfo(HttpSession session, Model model) {
        // 세션에서 유저 정보 가져오기
        Integer userPid = (Integer) session.getAttribute("user_pid");

        if (userPid == null) {
            model.addAttribute("errorMessage", "로그인이 필요합니다.");
            return new UserResponseDTO();
        }else {
            User user = userService.getUserByPid(userPid);
            return UserResponseDTO.from(user);
        }
    }
}

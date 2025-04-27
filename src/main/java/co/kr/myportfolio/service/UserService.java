package co.kr.myportfolio.service;


import co.kr.myportfolio.dto.UserRequestDTO;
import co.kr.myportfolio.mapper.UserMapper;
import co.kr.myportfolio.vo.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class UserService {

    @Autowired
    private UserMapper userMapper;

    // 회원가입
    public String registerUser(User user) {
        try{
            userMapper.insertUser(user);
        }catch(Exception e){
            System.out.println("e.getMessage() = " + e.getMessage());
            return e.getMessage();
        }
        return "회원가입이 완료되었습니다.";
    }

    public User getUserById(int id) {
        return userMapper.getUserById(id);
    }

    public User getUserByUserId(String userId) {
        return userMapper.getUserByUserId(userId);
    }

    public boolean isNicknameExists(String nickname) {
        return userMapper.checkNicknameExists(nickname);
    }

    public boolean isUserIdExists(String nickname) {
        return userMapper.checkUserIdExists(nickname);
    }

    public void deleteUser(int id) {
        userMapper.deleteUser(id);
    }

    public void updateUserThumbnail(Map<String, Object> param) {
        userMapper.updateUserThumbnail(param);
    }

    public void updateUserInfo(Integer userPid, UserRequestDTO requestDTO) {
        Map<String, Object> param = new HashMap<>();
        param.put("userPid", userPid);
        param.put("nickname", requestDTO.getNickname());
        param.put("email", requestDTO.getEmail());
        param.put("github", requestDTO.getGithub());
        param.put("introduce", requestDTO.getIntroduce());

        userMapper.updateUserInfo(param);
    }
}

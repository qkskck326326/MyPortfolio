package co.kr.myportfolio.service;


import co.kr.myportfolio.mapper.UserMapper;
import co.kr.myportfolio.vo.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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

    public void updateUser(User user) {
        userMapper.updateUser(user);
    }

    public void deleteUser(int id) {
        userMapper.deleteUser(id);
    }
}

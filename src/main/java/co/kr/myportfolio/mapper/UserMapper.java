package co.kr.myportfolio.dao;


import co.kr.myportfolio.model.User;
import org.apache.ibatis.annotations.*;

@Mapper
public interface UserMapper {
    
    // 회원가입
    void insertUser(User user);
    
    // id로 유저 찾기
    User getUserById(int id);
    
    // UserId로 유저 찾기
    User getUserByUserId(String userId);
    
    // 닉네임 체크
    boolean checkNicknameExists(String nickname);
    
    // 유저 정보 업데이트
    void updateUser(User user);
    
    // 유저 삭제
    void deleteUser(int id);
}

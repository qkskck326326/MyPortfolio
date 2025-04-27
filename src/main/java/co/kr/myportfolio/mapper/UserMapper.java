package co.kr.myportfolio.mapper;


import co.kr.myportfolio.vo.User;
import org.apache.ibatis.annotations.*;

import java.util.Map;

@Mapper
public interface UserMapper {
    
    // 회원가입
    void insertUser(User user);
    
    // id로 유저 찾기
    User getUserById(int id);
    
    // UserId로 유저 찾기
    User getUserByUserId(String userId);
    
    // 닉네임 중복 체크
    boolean checkNicknameExists(String nickname);
    
    // 유저 정보 업데이트
    void updateUser(User user);
    
    // 유저 삭제
    void deleteUser(int id);
    
    // 아이디 중복 체크
    boolean checkUserIdExists(String nickname);
    
    // 썸네일 변경
    void updateUserThumbnail(Map<String, Object> param);

    void updateUserInfo(Map<String, Object> param);
}

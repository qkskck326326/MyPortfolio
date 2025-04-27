package co.kr.myportfolio.dto;

import co.kr.myportfolio.vo.User;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@NoArgsConstructor
public class UserResponseDTO {
    private String userThumbnail;
    private String nickname;
    private Date birth;
    private String introduce;
    private String email;
    private String github;

    private UserResponseDTO(String userThumbnail, String nickname, Date birth, String introduce, String email, String github) {
        this.userThumbnail = userThumbnail;
        this.nickname = nickname;
        this.birth = birth;
        this.introduce = introduce;
        this.email = email;
        this.github = github;
    }

    public static UserResponseDTO from(User user) {
        return new UserResponseDTO(user.getUserThumbnail(), user.getNickname(), user.getBirth(), user.getIntroduce(), user.getEmail(), user.getGithub());
    }
}

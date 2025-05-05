package co.kr.myportfolio.dto;

import co.kr.myportfolio.vo.User;
import lombok.Data;

import java.util.List;

@Data
public class UserInfoAndTagsDTO {
    private String userThumbnail;
    private String userNickname;
    private String email;
    private String github;
    private String introduce;
    private List<TagDTO> tags;

    private UserInfoAndTagsDTO(String userThumbnail, String userNickname, String email, String github, String introduce, List<TagDTO> tags) {
        this.userThumbnail = userThumbnail;
        this.userNickname = userNickname;
        this.email = email;
        this.github = github;
        this.introduce = introduce;
        this.tags = tags;
    }

    public static UserInfoAndTagsDTO from(User user, List<TagDTO> tags){
        return new UserInfoAndTagsDTO(user.getUserThumbnail(), user.getNickname(), user.getEmail(), user.getGithub(), user.getIntroduce(), tags);
    }
}

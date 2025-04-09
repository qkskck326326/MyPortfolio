package co.kr.myportfolio.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Portfolio {
    private int id;
    private int userPid;
    private int likeCount;
    private String userNickname;
    private String thumbnail;
    private String title;
    private String content;
    private Date createdAt;
    private Date updatedAt;
}

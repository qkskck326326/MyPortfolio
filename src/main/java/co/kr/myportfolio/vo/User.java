package co.kr.myportfolio.vo;


import lombok.*;

import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class User {
    private int userPid;
    private String userId;
    private String password;
    private String nickname;
    private Date birth;
    private String introduce;
}

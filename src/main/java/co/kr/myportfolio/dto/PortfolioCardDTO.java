package co.kr.myportfolio.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class PortfolioCardDTO {
    private int portfolioId;
    private int userPid;
    private int likeCount;
    private String thumbnail;
    private String portfolioTitle;
    private String userNickname;
    private LocalDateTime createdAt;
}

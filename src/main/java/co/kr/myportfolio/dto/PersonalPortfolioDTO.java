package co.kr.myportfolio.dto;

import lombok.Data;

import java.util.Date;
import java.util.List;

@Data
public class PersonalPortfolioDTO {
    private int portfolioId;
    private String portfolioTitle;
    private String portfolioThumbnail;
    private int likeCount;
    private Date createAt;
    private List<String> tags;
}

package co.kr.myportfolio.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class PortfolioTag {
    private int id;
    private int portfolioId;
    private String tag;
}

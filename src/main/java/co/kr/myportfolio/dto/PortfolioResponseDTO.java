package co.kr.myportfolio.dto;

import co.kr.myportfolio.vo.Portfolio;
import co.kr.myportfolio.vo.PortfolioTag;
import lombok.Data;

import java.util.List;

@Data
public class PortfolioResponseDTO {
    private int id;
    private Portfolio portfolio;
    private List<String> tags;
}

package co.kr.myportfolio.dto;

import co.kr.myportfolio.vo.Portfolio;
import lombok.Data;

import java.util.List;

@Data
public class PortfolioResponseDTO {
    private int id;
    private Portfolio portfolio;
    private boolean is_like;
    private List<String> tags;
}

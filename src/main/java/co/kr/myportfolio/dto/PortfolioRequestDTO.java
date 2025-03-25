package co.kr.myportfolio.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.List;

@Getter
@ToString
@AllArgsConstructor
public class PortfolioDTO {
    private final String title;
    private final String content;
    private final List<String> tags;

}

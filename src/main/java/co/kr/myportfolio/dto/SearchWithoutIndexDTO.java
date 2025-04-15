package co.kr.myportfolio.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SearchWithoutIndexDTO {
    private String searchOption;
    private String orderBy;
    private String keyword;
    private List<String> tags;
}

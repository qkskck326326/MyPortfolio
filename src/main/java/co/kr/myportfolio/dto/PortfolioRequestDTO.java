package co.kr.myportfolio.dto;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;

import java.util.List;

@Getter
@ToString
@NoArgsConstructor(force = true)
public class PortfolioRequestDTO {
    @Setter
    private int userPid;
    @Setter
    private String userNickname;
    private final int portfolioId;
    private final String title;
    private final String content;
    private final List<String> tags;
    private final String thumbnail;

    /*@JsonCreator 방식은 DTO를 불변 객체로 유지하면서 JSON 역직렬화를 가능. 즉, 
    DTO를 수정 불가능 한 구조를 보장하면서도 Jackson과 호환*/
    @JsonCreator
    public PortfolioRequestDTO(
            @JsonProperty("portfolioId") int portfolioId,
            @JsonProperty("title") String title,
            @JsonProperty("content") String content,
            @JsonProperty("tags") List<String> tags,
            @JsonProperty("thumbnail") String thumbnail
    ) {
        this.portfolioId = portfolioId;
        this.title = title;
        this.content = content;
        this.tags = tags;
        this.thumbnail = thumbnail;
    }
}

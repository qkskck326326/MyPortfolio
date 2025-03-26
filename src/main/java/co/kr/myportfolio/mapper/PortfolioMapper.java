package co.kr.myportfolio.mapper;

import co.kr.myportfolio.dto.PortfolioCardDTO;
import co.kr.myportfolio.dto.PortfolioResponseDTO;
import co.kr.myportfolio.vo.Portfolio;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface PortfolioMapper {
    void insertPortfolio(Portfolio portfolio);
    void insertTags(Map<String, Object> param);

    List<PortfolioResponseDTO> getPortfolioAndTag(@Param("portfolioId") int portfolioId);

    List<PortfolioCardDTO> getPortfolioCardList();
}

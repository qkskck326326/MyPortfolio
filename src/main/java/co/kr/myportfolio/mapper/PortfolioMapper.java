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

    PortfolioResponseDTO getPortfolioAndTag(@Param("portfolioId") int portfolioId, @Param("userPid") int userPid);

    List<PortfolioCardDTO> getPortfolioCardList();

    boolean checkUserLike(@Param("userPid") int userPid, @Param("portfolioId") int portfolioId);

    void insertLike(@Param("userPid") int userPid, @Param("portfolioId") int portfolioId);

    void incrementLikeCount(@Param("portfolioId") int portfolioId);


    void deleteLike(@Param("userPid") int userPid, @Param("portfolioId") int portfolioId);

    void decrementLikeCount(@Param("portfolioId") int portfolioId);
}

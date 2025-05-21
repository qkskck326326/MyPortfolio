package co.kr.myportfolio.mapper;

import co.kr.myportfolio.dto.PersonalPortfolioDTO;
import co.kr.myportfolio.dto.PortfolioCardDTO;
import co.kr.myportfolio.dto.PortfolioResponseDTO;
import co.kr.myportfolio.dto.TagDTO;
import co.kr.myportfolio.vo.Portfolio;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface PortfolioMapper {
    void insertPortfolio(Portfolio portfolio);
    void updatePortfolio(Portfolio portfolio);
    void insertTags(Map<String, Object> param);
    void deleteTags(int portfolioId);

    PortfolioResponseDTO getPortfolioAndTag(@Param("portfolioId") int portfolioId, @Param("userPid") int userPid);

    List<PortfolioCardDTO> getPortfolioCardList();

    boolean checkUserLike(@Param("userPid") int userPid, @Param("portfolioId") int portfolioId);

    void insertLike(@Param("userPid") int userPid, @Param("portfolioId") int portfolioId);

    void incrementLikeCount(@Param("portfolioId") int portfolioId);


    void deleteLike(@Param("userPid") int userPid, @Param("portfolioId") int portfolioId);

    void decrementLikeCount(@Param("portfolioId") int portfolioId);

    List<PortfolioCardDTO> getPortfolioCardListWithSortBy(Map<String, Object> params);

    List<PortfolioCardDTO> getLikedPortfolioCardListWithSortBy(Map<String, Object> params);

    int getPortfolioTotalCount(Map<String, Object> params);

    int getLikedPortfolioTotalCount(Map<String, Object> params);

    List<TagDTO> getUsersTags(int userPid);

    List<PersonalPortfolioDTO> getPersonalPortfolio(Map<String, Object> params);

    int getPersonalPortfolioTotalCount(Map<String, Object> params);

    void deletePortfolio(Integer portfolioId);

    int getPortfolioWriterPid(int portfolioId);
}

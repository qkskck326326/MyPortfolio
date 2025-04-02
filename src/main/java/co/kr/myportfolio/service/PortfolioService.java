package co.kr.myportfolio.service;

import co.kr.myportfolio.dto.PortfolioCardDTO;
import co.kr.myportfolio.dto.PortfolioRequestDTO;
import co.kr.myportfolio.dto.PortfolioResponseDTO;
import co.kr.myportfolio.mapper.PortfolioMapper;
import co.kr.myportfolio.vo.Portfolio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class PortfolioService {
    @Autowired
    private PortfolioMapper portfolioMapper;
    
    // 포트폴리오 등록
    public int postPortfolio(PortfolioRequestDTO portfolioRequestDTO) {
        // Portfolio 객체 생성 후 값 대입
        Portfolio portfolio = new Portfolio();
        portfolio.setUserPid(portfolioRequestDTO.getUserPid());
        portfolio.setThumbnail(portfolioRequestDTO.getThumbnail());
        portfolio.setUserNickname(portfolioRequestDTO.getUserNickname());
        portfolio.setContent(portfolioRequestDTO.getContent());
        portfolio.setTitle(portfolioRequestDTO.getTitle());

        // MyBatis에서 자동 생성된 ID를 반환 객체에 설정
        portfolioMapper.insertPortfolio(portfolio);
        int portfolioId = portfolio.getId();

        // tags 리스트 저장
        List<String> tags = portfolioRequestDTO.getTags();
        if (tags != null && !tags.isEmpty()) {
            Map<String, Object> param = new HashMap<>();
            param.put("portfolioId", portfolioId);
            param.put("tags", tags);
            portfolioMapper.insertTags(param);
        }

        return portfolioId;
    }
    
    // 특정 포트폴리오 정보 불러오기
    public PortfolioResponseDTO getPortfolio(int portfolioId, int userPid) {
        return portfolioMapper.getPortfolioAndTag(portfolioId, userPid);
    }

    public List<PortfolioCardDTO> getPortfolioCardList() {
        return portfolioMapper.getPortfolioCardList();
    }


    @Transactional
    public boolean togglePortfolioLike(int userPid, int portfolioId) {
        boolean alreadyLiked = portfolioMapper.checkUserLike(userPid, portfolioId);

        if (alreadyLiked) {
            // 상태가 true → 취소 로직
            portfolioMapper.deleteLike(userPid, portfolioId);
            portfolioMapper.decrementLikeCount(portfolioId);
            return false; // 좋아요 취소됨
        } else {
            // 상태가 false → 좋아요 등록
            portfolioMapper.insertLike(userPid, portfolioId);
            portfolioMapper.incrementLikeCount(portfolioId);
            return true; // 좋아요 완료됨
        }
    }

    public List<PortfolioCardDTO> getPortfolioCardListWithSortBy(Map<String, Object> params) {
        return portfolioMapper.getPortfolioCardListWithSortBy(params);
    }

    public int getPortfolioTotalCount(Map<String, Object> params) { return portfolioMapper.getPortfolioTotalCount(params);}
}

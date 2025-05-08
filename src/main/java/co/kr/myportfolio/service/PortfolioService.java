package co.kr.myportfolio.service;

import co.kr.myportfolio.dto.*;
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
    @Transactional
    public int postPortfolio(PortfolioRequestDTO portfolioRequestDTO) {
        // Portfolio 객체 생성 후 값 대입
        Portfolio portfolio = new Portfolio();
        portfolio.setUserPid(portfolioRequestDTO.getUserPid());
        portfolio.setThumbnail(portfolioRequestDTO.getThumbnail());
        portfolio.setUserNickname(portfolioRequestDTO.getUserNickname());
        portfolio.setContent(portfolioRequestDTO.getContent());
        portfolio.setTitle(portfolioRequestDTO.getTitle());

        // tags 리스트 저장
        List<String> tags = portfolioRequestDTO.getTags();

        // MyBatis에서 자동 생성된 ID를 반환 객체에 설정
        portfolioMapper.insertPortfolio(portfolio);
        int portfolioId = portfolio.getId();

        if (tags != null && !tags.isEmpty()) {
            Map<String, Object> param = new HashMap<>();
            param.put("portfolioId", portfolioId);
            param.put("tags", tags);
            portfolioMapper.insertTags(param);
        }

        return portfolioId;
    }
    
    // 포트폴리오 수정
    @Transactional
    public void updatePortfolio(PortfolioRequestDTO portfolioRequestDTO) {
        // Portfolio 객체 생성 후 값 대입
        Portfolio portfolio = new Portfolio();
        portfolio.setId(portfolioRequestDTO.getPortfolioId());
        portfolio.setUserPid(portfolioRequestDTO.getUserPid());
        portfolio.setThumbnail(portfolioRequestDTO.getThumbnail());
        portfolio.setUserNickname(portfolioRequestDTO.getUserNickname());
        portfolio.setContent(portfolioRequestDTO.getContent());
        portfolio.setTitle(portfolioRequestDTO.getTitle());

        // 포트폴리오 수정
        portfolioMapper.updatePortfolio(portfolio);
        
        // 기존 테그 삭제
        portfolioMapper.deleteTags(portfolioRequestDTO.getPortfolioId());
        
        // tags 리스트 저장
        List<String> tags = portfolioRequestDTO.getTags();
        if (tags != null && !tags.isEmpty()) {
            Map<String, Object> param = new HashMap<>();
            param.put("portfolioId", portfolioRequestDTO.getPortfolioId());
            param.put("tags", tags);
            portfolioMapper.insertTags(param);
        }
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

    public List<PortfolioCardDTO> getLikedPortfolioCardListWithSortBy(Map<String, Object> params) {
        return portfolioMapper.getLikedPortfolioCardListWithSortBy(params);
    }

    public int getPortfolioTotalCount(Map<String, Object> params) { return portfolioMapper.getPortfolioTotalCount(params);}

    public int getLikedPortfolioTotalCount(Map<String, Object> params) { return portfolioMapper.getLikedPortfolioTotalCount(params);}

    public List<TagDTO> getUsersTags(int userPid) {
        return portfolioMapper.getUsersTags(userPid);
    }

    public List<PersonalPortfolioDTO> getPersonalPortfolio(Map<String, Object> params) {
        return portfolioMapper.getPersonalPortfolio(params);
    }

    public int getPersonalPortfolioTotalCount(Map<String, Object> params) {
        return portfolioMapper.getPersonalPortfolioTotalCount(params);
    }

    public void deletePortfolio(Integer portfolioId) {
        portfolioMapper.deletePortfolio(portfolioId);
    }
}

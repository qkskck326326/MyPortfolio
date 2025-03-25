package co.kr.myportfolio.service;

import co.kr.myportfolio.dto.PortfolioRequestDTO;
import co.kr.myportfolio.dto.PortfolioResponseDTO;
import co.kr.myportfolio.mapper.PortfolioMapper;
import co.kr.myportfolio.vo.Portfolio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
    public PortfolioResponseDTO getPortfolio(int portfolioId) {
        List<PortfolioResponseDTO> list = portfolioMapper.getPortfolioAndTag(portfolioId);
        System.out.println("결과 개수: " + list.size());
        for (PortfolioResponseDTO dto : list) {
            System.out.println("userNickname = " + dto.getPortfolio().getUserNickname());
            System.out.println("태그들: " + dto.getTags());
        }
        return list.isEmpty() ? null : list.get(0);
    }
}

package co.kr.myportfolio.service;

import co.kr.myportfolio.dto.PersonalPortfolioDTO;
import co.kr.myportfolio.dto.TagDTO;
import co.kr.myportfolio.dto.UserInfoAndTagsDTO;
import co.kr.myportfolio.vo.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
public class PersonalService {
    @Autowired
    private PortfolioService portfolioService;

    @Autowired
    private UserService userService;

    // API - 특정 유저 포트폴리오 모든 테그 및 소개 반환
    @Transactional
    public UserInfoAndTagsDTO goUserInfoAndTags(int userPid) {
        User user = userService.getUserByPid(userPid);
        List<TagDTO> tags = portfolioService.getUsersTags(userPid);
        return  UserInfoAndTagsDTO.from(user, tags);
    }

    public List<PersonalPortfolioDTO> getPersonalPortfolio(Map<String, Object> params) {
        List<PersonalPortfolioDTO> testValue = portfolioService.getPersonalPortfolio(params);
        System.out.println("testValue = " + testValue);
        return testValue;
    }

    public int getPersonalPortfolioTotalCount(Map<String, Object> params) {
        int totalCount = portfolioService.getPersonalPortfolioTotalCount(params);
        System.out.println("Service totalCount = " + totalCount);
        return totalCount;
    }

    // API - 특정 유저 작성 포트폴리오 반환
}

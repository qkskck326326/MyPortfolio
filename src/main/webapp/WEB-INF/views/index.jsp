<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>MyPortfolio</title>
    <script src="${pageContext.request.contextPath}/resources/js/jquery-3.6.0.js"></script>
    <style>
        .card-container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: center;
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
            box-sizing: border-box;
        }

        .card {
            width: calc((100% - 60px) / 4); /* gap 20px * (4 - 1) */
            border: 1px solid #ddd;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            font-family: sans-serif;
            background: #fff;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
            transition: all 0.5s ease;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .thumbnail {
            width: 100%;
            aspect-ratio: 4 / 3;
            overflow: hidden;
        }

        .thumbnail img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        .content {
            flex: 1;
            padding: 12px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }


        .title {
            font-size: 1.1rem;
            font-weight: bold;
            margin-bottom: 4px;
            text-align: left;
        }

        .date {
            font-size: 0.85rem;
            color: gray;
            text-align: left;
        }

        .bottom {
            display: flex;
            justify-content: space-between;
            margin-top: 10px;
            font-size: 0.9rem;
        }

        .nickname {
            font-weight: 500;
        }

        .like {
            color: #e74c3c;
        }
        .hidden {
            display: none;
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<c:if test="${not empty errorMessage}">
    <script>
        alert("${errorMessage}");
    </script>
</c:if>
<p id="search-info" style="text-align: center; font-weight: bold; margin: 20px 0;"></p>
<div id="cardContainer" class="card-container"></div>

<p id="end-message" class="hidden" style="text-align:center; color:gray; margin: 40px 0;">
    🔚 더 이상 불러올 포트폴리오가 없습니다.
</p>

</body>

<script>

    document.addEventListener('DOMContentLoaded', () => {
        let page;
        let orderBy;
        let searchBy;
        let isLoading = false;
        let totalPages = null;
        let pageSize = 20;
        let keyword = '';
        let tags;
        let searchSelect = document.querySelector("#search-select")

        page = 0;
        orderBy = document.querySelector("#sort-select").value;
        searchSelect = document.querySelector("#search-select")

        // 한 자리 숫자를 두 자리 문자열로 변환하는 보조 함수
        function pad(n) {
            return n < 10 ? '0' + n : n;
        }

        // 날짜 배열을 'yyyy-mm-dd hh:mm' 문자열로 변환
        function formatDate(arr) {
            const [year, month, day, hour, min] = arr;
            return year + '-' + pad(month) + '-' + pad(day) + ' ' + pad(hour) + ':' + pad(min);
        }

        // 포트폴리오 카드 HTML을 생성해서 목록에 추가
        function renderPortfolioCards(data) {
            const cardList = data.portfolioCardList;
            const $container = $('#cardContainer');
            const defaultThumbnail = '${pageContext.request.contextPath}/resources/images/logo.webp';

            cardList.forEach(card => {
                const createdAt = formatDate(card.createdAt);
                const thumbnail = card.thumbnail ? card.thumbnail : defaultThumbnail;

                const html = `
                    <a href="${pageContext.request.contextPath}/portfolio/\${card.portfolioId}" class="card" style="text-decoration: none; color: inherit;">
                        <div class="thumbnail">
                            <img src="\${thumbnail}" alt="썸네일">
                        </div>
                        <div class="content">
                            <div class="title">\${card.portfolioTitle}</div>
                            <div class="date">\${createdAt}</div>
                            <hr>
                            <div class="bottom">
                                <span class="nickname" data-user="\${card.userNickname}">by. \${card.userNickname}</span>
                                <span class="like">❤️ \${card.likeCount}</span>
                            </div>
                        </div>
                    </a>
                `;
                $container.append(html);
            });
        }

        // 포트폴리오 목록을 서버에서 가져와 렌더링
        function loadPortfolios() {
            if (totalPages !== null && page >= totalPages) return;
            if (isLoading) return;
            isLoading = true;

            let url = '${pageContext.request.contextPath}/portfolio/list?page=' + page +
                '&size=' + pageSize +
                '&orderBy=' + orderBy +
                '&keyword=' + encodeURIComponent(keyword);

            // tags 배열이 있을 때 추가
            if (tags != null){
                tags.forEach(tag => {
                    url += `&tags=\${encodeURIComponent(tag)}`;
                });
            }

            fetch(url)
                .then(res => res.json())
                .then(data => {
                    // 첫 요청일 경우 총 페이지 수 계산 및 검색어 결과 표시
                    if (data.totalCount !== undefined && totalPages === null) {
                        totalPages = Math.ceil(data.totalCount / pageSize);
                        if (keyword) {
                            document.querySelector("#search-info").textContent = `"\${keyword}" 검색 결과 총 \${data.totalCount}건`;
                        } else {
                            document.querySelector("#search-info").textContent = "";
                        }
                    }
                    console.log("orderBy : " + orderBy)
                    renderPortfolioCards(data);
                    page++;
                    isLoading = false;

                    // 마지막 페이지 도달 시 메시지 표시
                    if (totalPages !== null && page >= totalPages) {
                        document.querySelector("#end-message")?.classList.remove("hidden");
                    }
                })
                .catch(err => {
                    console.error("포트폴리오 로딩 중 오류:", err);
                    isLoading = false;
                });
        }

        // 스크롤이 바닥 근처일 때 자동 로딩
        window.addEventListener('scroll', () => {
            if (window.innerHeight + window.scrollY >= document.body.offsetHeight - 300) {
                loadPortfolios();
            }
        });

        // 정렬 기준 변경 시 다시 로딩
        document.querySelector("#sort-select").addEventListener("change", function () {
            orderBy = this.value;
            page = 0;
            totalPages = null;
            document.querySelector("#cardContainer").innerHTML = "";
            document.querySelector("#end-message")?.classList.add("hidden");
            loadPortfolios();
        });

        // 검색 기준 변경시
        searchSelect.addEventListener("change", function () {
            searchBy = this.value;
            tags = null;
            keyword = null;
        });

        const searchBtn = document.querySelector("#search-btn");

        // 검색 버튼 클릭 시 검색 실행
        searchBtn.addEventListener("click", function () {
            keyword = document.querySelector("#search-box").value.trim();
            page = 0;
            totalPages = null;
            if (searchSelect.value === "tag"){
                tags = Array.from(document.querySelectorAll('#tag-list .tag-chip i'))
                    .map(el => el.getAttribute("data-tag"));
            }
            document.querySelector("#cardContainer").innerHTML = "";
            document.querySelector("#end-message")?.classList.add("hidden");
            loadPortfolios();
        });

        // 검색창 입력 시 keyword 업데이트
        const searchInput = document.querySelector(".search-box");
        if (searchInput) {
            searchInput.addEventListener("input", function () {
                keyword = this.value.trim();
            });

            // 엔터키로 검색
            searchInput.addEventListener("keyup", function (e) {
                if (e.key === "Enter" && searchSelect.value === "title") {
                    e.preventDefault();
                    searchBtn.click();
                }
            });
        }

        // 닉네임 클릭 시 해당 사용자 페이지 이동
        $(document).on('click', '.nickname', function (e) {
            e.preventDefault();
            e.stopPropagation();
            const userPid = $(this).data('user_pid');
            console.log(`작성자 아이디 클릭:` + userPid);
            location.href = "${pageContext.request.contextPath}/personal/" + userPid;
        });

        // 첫 페이지 로딩
        if (!window.hasTakenSearchOption) {
            console.log("기본로딩");
            loadPortfolios();
        }else{
            console.log("검색전달 로딩");
            searchBtn.click();
        }
    });
</script>

</html>

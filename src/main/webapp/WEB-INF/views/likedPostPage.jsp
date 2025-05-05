<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script src="${pageContext.request.contextPath}/resources/js/jquery-3.6.0.js"></script>
<html>
<head>
    <style>
        /* 카드 전체 컨테이너 */
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

        /* 개별 카드 */
        .card {
            width: calc((100% - 60px) / 4);  /* 4열 기준 */
            border: 1px solid #ddd;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            background: #fff;
            display: flex;
            flex-direction: column;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
            cursor: pointer;
        }

        /* 썸네일 영역 */
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

        /* 카드 내용 */
        .content {
            padding: 12px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        /* 제목 */
        .title {
            font-size: 1.1rem;
            font-weight: bold;
            margin-bottom: 4px;
            text-align: left;
        }

        .hidden {
            display: none;
        }
    </style>
    <title>좋아요 누른 글</title>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    <p id="liked-info" style="text-align: center; font-weight: bold; margin: 20px 0;"></p>
    <div id="cardContainer" class="card-container"></div>
    <p id="end-message" class="hidden" style="text-align:center; color:gray; margin: 40px 0;">
        🔚 더 이상 불러올 포트폴리오가 없습니다.
    </p>
</body>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        let page = 0;
        let pageSize = 20;
        let isLoading = false;
        let totalPages = null;

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
                                <span class="nickname" data-user="\${card.userNickname}">작성자. \${card.userNickname}</span>
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

            let url = '${pageContext.request.contextPath}/portfolio/liked/list?page=' + page +
                '&size=' + pageSize +
                `&userPid=` + "${sessionScope.user_pid}";

            fetch(url)
                .then(res => res.json())
                .then(data => {
                    // 첫 요청일 경우 총 페이지 수 계산 및 총 갯수 표시
                    if (data.totalCount !== undefined && totalPages === null) {
                        totalPages = Math.ceil(data.totalCount / pageSize);
                        document.querySelector("#liked-info").textContent = `좋아요 표시한 게시글 총 \${data.totalCount}건`;
                    }
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

        let isScrollHandling = false;

        window.addEventListener('scroll', () => {
            if (isScrollHandling) return;  // 중복 방지
            isScrollHandling = true;

            setTimeout(() => {
                if (window.innerHeight + window.scrollY >= document.body.offsetHeight - 100) {
                    loadPortfolios();
                }
                isScrollHandling = false;
            }, 200);  // 200ms 딜레이로 throttle 효과
        });

        // 닉네임 클릭 시 해당 사용자 페이지 이동
        $(document).on('click', '.nickname', function (e) {
            e.preventDefault();
            e.stopPropagation();
            const userPid = $(this).data('user_pid');
            console.log(`작성자 아이디 클릭:` + userPid);
            location.href = "${pageContext.request.contextPath}/personal/" + userPid;
        });

        // 최초 호출
        loadPortfolios();
    });
</script>
</html>

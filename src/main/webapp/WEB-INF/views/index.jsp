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
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div id="cardContainer" class="card-container"></div>

</body>

<%--<script>
    // 수정 - 닉네임 클릭시
    $(document).on('click', '.nickname', function (e) {
        e.preventDefault();     // 링크 이동 방지
        e.stopPropagation();    // 부모 <a> 클릭 방지
        const nickname = $(this).data('user');

        console.log(`작성자 클릭: \${nickname}`);
        // 예시: location.href = `${pageContext.request.contextPath}/user/\${nickname}`;
    });

    // 수정 - 데이터 로딩 갯수 및 조건
    $(document).ready(function () {
        $.ajax({
            url: '${pageContext.request.contextPath}/portfolio/get',
            method: 'GET',
            dataType: 'json',
            success: function (res) {
                const cardList = res.portfolioCardList;
                const $container = $('#cardContainer');
                $container.empty();

                cardList.forEach(card => {
                    const createdAt = formatDate(card.createdAt);
                    const defaultThumbnail = '${pageContext.request.contextPath}/resources/images/logo.webp';
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
            },
            error: function (xhr, status, error) {
                console.error("카드 리스트 불러오기 실패:", error);
            }
        });

        function formatDate(arr) {
            const [year, month, day, hour, min] = arr;
            return `\${year}-\${pad(month)}-\${pad(day)} \${pad(hour)}:\${pad(min)}`;
        }

        function pad(n) {
            return n < 10 ? '0' + n : n;
        }

    });
</script>--%>
<script>
    let page;
    let orderBy;
    let isLoading = false;

    document.addEventListener('DOMContentLoaded', () => {
        page = 0;
        orderBy = document.querySelector(".form-select").value; // DOM이 로드된 후에 접근

        // 수정 - 닉네임 클릭시
        $(document).on('click', '.nickname', function (e) {
            e.preventDefault();     // 링크 이동 방지
            e.stopPropagation();    // 부모 <a> 클릭 방지
            const nickname = $(this).data('user');

            console.log(`작성자 클릭: \${nickname}`);
            // 예시: location.href = `${pageContext.request.contextPath}/user/\${nickname}`;
        });

        function pad(n) {
            return n < 10 ? '0' + n : n;
        }

        function formatDate(arr) {
            const [year, month, day, hour, min] = arr;
            return year + '-' + pad(month) + '-' + pad(day) + ' ' + pad(hour) + ':' + pad(min);
        }

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

        function loadPortfolios() {
            if (isLoading) return;
            isLoading = true;

            fetch(`${pageContext.request.contextPath}/portfolio/list?page=\${page}&size=20&orderBy=\${orderBy}`)
                .then(res => res.json())
                .then(data => {
                    renderPortfolioCards(data);
                    page++;
                    isLoading = false;
                })
                .catch(err => {
                    console.error("포트폴리오 로딩 중 오류:", err);
                    isLoading = false;
                });
        }

        window.addEventListener('scroll', () => {
            if (window.innerHeight + window.scrollY >= document.body.offsetHeight - 300) {
                loadPortfolios();
            }
        });

        document.querySelector(".form-select").addEventListener("change", function () {
            orderBy = this.value;
            page = 0;
            document.querySelector("#portfolio-list").innerHTML = "";
            loadPortfolios();
        });

        // 최초 호출
        loadPortfolios();
    });
</script>

</html>

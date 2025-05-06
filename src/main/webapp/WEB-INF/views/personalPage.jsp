<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>개인 포트폴리오 페이지</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="${pageContext.request.contextPath}/resources/js/jquery-3.6.0.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        .id-card {
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 20px;
            margin-top: 20px;
            background-color: #ffffff;
        }

        .card{
            transition: all 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
            cursor: pointer;
        }
        .id-title { font-size: 20px; font-weight: bold; margin-bottom: 15px; }
        .id-header { display: flex; gap: 20px; }
        .id-photo img { width: 100px; height: 100px; object-fit: cover; border-radius: 50%; }
        .id-introduce { margin-top: 20px; }
        .list-group-item.tag-selected { background-color: #0d6efd !important; color: white !important; }
        .card-img-top { height: 200px; object-fit: cover; }
    </style>
</head>
<body class="bg-light">
<div class="container">
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>
    <div class="id-card">
        <div class="id-title">MyPortfolio 신분증</div>
        <div class="id-header">
            <div class="id-photo" id="userThumbnail"><p>Loading...</p></div>
            <div class="id-info">
                <p><strong>닉네임:</strong> <span id="userNicknameView"></span></p>
                <p><strong>Email:</strong> <span id="userEmailView"></span></p>
                <p><strong>GitHub:</strong>
                    <span id="userGithubView"></span>
                    <button id="goGithubBtn" class="btn btn-sm btn-outline-primary ms-2">이동</button>
                </p>
            </div>
        </div>
        <div class="id-introduce">
            <strong>소개:</strong>
            <p id="userIntroduceView"></p>
        </div>
    </div>

    <div class="col-md-6 offset-md-3 mt-3">
        <div class="d-flex justify-content-between align-items-center">
            <div class="input-group me-2">
                <input type="text" id="searchKeyword" class="form-control" placeholder="포트폴리오 제목 검색">
                <button id="searchBtn" class="btn btn-outline-primary">검색</button>
            </div>
            <small id="totalCountText" class="text-muted flex-shrink-0" style="white-space: nowrap;"></small>
        </div>
    </div>

    <div class="row mt-4">
        <div class="col-md-3">
            <div class="card">
                <div class="card-header"><strong>사용 태그 목록</strong></div>
                <ul class="list-group list-group-flush" id="userTagsList">
                    <li class="list-group-item">Loading...</li>
                </ul>
            </div>
        </div>
        <div class="col-md-9">
            <div id="portfolioContainer" class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4"></div>
        </div>
    </div>
</div>
<script>
    const userPid = "<c:out value='${userPid}'/>";
    let userTags = [];
    let page = 0;
    const size = 12;
    let isLoading = false;
    let isEnd = false;
    let keyword = "";

    $(document).ready(function () {
        $.post("${pageContext.request.contextPath}/personal/userAndTags/info", {userPid: userPid}, function (res) {
            $('#userThumbnail').html(res.userThumbnail ?
                `<img src="\${res.userThumbnail}" alt="프로필 이미지">` :
                `<p>썸네일이 없습니다.</p>`);
            $('#userNicknameView').text(res.userNickname);
            $('#userEmailView').text(res.email);
            $('#userGithubView').text(res.github);
            $('#userIntroduceView').text(res.introduce);
            $('#goGithubBtn').click(() => window.open(res.github, '_blank'));

            const tagListContainer = $('#userTagsList');
            tagListContainer.empty();
            tagListContainer.append(`<li class="list-group-item d-flex justify-content-between align-items-center tag-selected"><span>전체</span><span id="allTag" class="badge bg-primary rounded-pill"></span></li>`);
            let allCount = 0;
            (res.tags || []).forEach(tag => {
                const name = tag.tagName || '(이름 없음)';
                const amount = tag.amount || 0;
                allCount += amount;
                tagListContainer.append(`<li class="list-group-item d-flex justify-content-between align-items-center"><span>\${name}</span><span class="badge bg-primary rounded-pill">\${amount}</span></li>`);
            });
            $('#allTag').text(allCount);
            loadPortfolios();
        });

        $('#userTagsList').on('click', 'li.list-group-item', function () {
            const name = $(this).find('span').first().text();
            if (name === '전체') {
                $('#userTagsList li').removeClass('tag-selected');
                userTags = [];
                keyword = "";
                document.getElementById("searchKeyword").value = "";
                $(this).addClass('tag-selected');
            } else {
                $('#userTagsList li:first').removeClass('tag-selected');
                $(this).toggleClass('tag-selected');
                if ($(this).hasClass('tag-selected')) userTags.push(name);
                else userTags = userTags.filter(t => t !== name);
                if (userTags.length === 0) $('#userTagsList li:first').addClass('tag-selected');
            }
            page = 0;
            isEnd = false;
            $('#portfolioContainer').empty();
            console.log("현재 테그 : " + userTags);
            loadPortfolios();
        });

        $(window).on('scroll', function () {
            if (!isEnd && !isLoading && $(window).scrollTop() + $(window).height() >= $(document).height() - 100) {
                loadPortfolios();
            }
        });
    });

    function loadPortfolios() {
        isLoading = true;

        $.ajax({
            url: "${pageContext.request.contextPath}/personal/portfolio/cards",
            method: "POST",
            data: {
                userPid: userPid,
                page: page,
                size: size,
                tags: userTags,
                keyword: keyword
            },
            traditional: true, // ✅ 배열을 정상적으로 전송하도록 설정
            success: function (res) {
                const list = res.portfolioCardList;
                const container = $('#portfolioContainer');

                if (page === 0 && res.totalCount !== undefined) {
                    $('#totalCountText').text(`총 \${res.totalCount}개 결과`);
                }

                if (!list || list.length === 0) {
                    isEnd = true;
                    $('#endMessage').remove();
                    container.after(`<div id="endMessage" class="text-center text-muted mt-3">🔚 더 이상 불러올 포트폴리오가 없습니다.</div>`);
                    return;
                }

                page++;

                list.forEach(item => {
                    console.log("로딩됨");
                    const tagsHtml = (item.tags || []).map(tag => `<span class="badge bg-secondary me-1">\${tag}</span>`).join('');
                    const thumbnail = item.portfolioThumbnail || 'https://i.ibb.co/M5BxwRxS/My-Portfolio-icon.webp';
                    const dateStr = item.createAt ? new Date(item.createAt).toLocaleDateString('ko-KR') : '';

                    const card = `
<div class="col">
  <div class="card h-100 shadow-sm portfolio-card" data-id="\${item.portfolioId}">
    <img src="\${thumbnail}" class="card-img-top" alt="\${item.portfolioTitle}">
    <div class="card-body d-flex flex-column justify-content-between">
      <div>
        <h5 class="card-title">\${item.portfolioTitle}</h5>
        <div class="mb-2">\${tagsHtml}</div>
      </div>
      <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
        <small class="text-muted">작성일: \${dateStr}</small>
        <small class="text-muted">❤️ \${item.likeCount}</small>
      </div>
    </div>
  </div>
</div>`;
                    container.append(card);
                });

                isLoading = false;
            },
            error: function () {
                alert("포트폴리오를 불러오는 중 오류 발생");
                isLoading = false;
            }
        });
    }

    // 포트폴리오 클릭시 이동
    $('#portfolioContainer').on('click', '.portfolio-card', function () {
        const portfolioId = $(this).data('id');
        window.location.href = "${pageContext.request.contextPath}/portfolio/" + portfolioId;
    });

    // 검색버튼 클릭시
    $('#searchBtn').on('click', function () {
        keyword = $('#searchKeyword').val().trim();
        page = 0;
        isEnd = false;
        $('#portfolioContainer').empty();
        $('#endMessage').remove();
        loadPortfolios();
    });

    // 엔터로 검색
    $('#searchKeyword').on('keypress', function (e) {
        if (e.key === 'Enter') {
            $('#searchBtn').click();
        }
    });
</script>
</body>
</html>
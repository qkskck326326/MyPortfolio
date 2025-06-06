<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <%--아이콘 라이브러리--%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

    <title>프로젝트 상세</title>

    <!-- Toast UI Editor Viewer CSS & JS -->
    <link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
    <script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>

    <style>
        body {
            font-family: 'Pretendard', sans-serif;
            background-color: #f9fafb;
            color: #1f2937;
            margin: 0;
            padding: 0;
            min-width: 1280px; /* 최소 너비 제한 */
        }

        .portfolio-container {
            width: 100%;
            max-width: 1200px; /* 기존 960px → 1200px 로 확장 */
            margin: 40px auto;
            background: #fff;
            padding: 40px 60px; /* 좌우 여백도 조금 넉넉하게 */
            border-radius: 16px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.05);
        }

        .markdown-viewer {
            border: 1px solid #ccc;
            padding: 20px;
            margin-top: 20px;
        }
        .tag-badge {
            display: inline-block;
            background-color: #f0f0f5;
            color: #333;
            font-size: 13px;
            font-weight: 500;
            padding: 6px 12px;
            margin: 4px 6px 4px 0;
            border-radius: 20px;
            border: 1px solid #d1d1e0;
            transition: all 0.3s ease;
        }
        .tag-badge:hover {
            background-color: #dbeafe;
            color: #1d4ed8;
            cursor: pointer;
        }

        .selected-tag {
            background-color: #dbeafe !important;
            color: #1d4ed8 !important;
            border-color: #93c5fd;
        }

        .floating-nav {
            position: fixed;
            top: 40%;
            right: 40px;
            display: flex;
            flex-direction: column;
            align-items: center;
            z-index: 999;

            background-color: #e5e7eb;
            border-radius: 32px;
            padding: 15px 10px;
        }
        .floating-nav button {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            border: none;
            background-color: #1d4ed8;
            color: white;
            font-size: 20px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .floating-nav button:hover {
            background-color: #2563eb;
        }

        .info-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .actions {
            display: flex;
            gap: 10px;
            margin-left: auto;
        }
        .actions p {
            cursor: pointer;
            color: #007bff;
            margin: 0;
            transition: color 0.3s ease;
        }
        .actions p:hover {
            color: gray;
        }
        .nickname {
            cursor: pointer;
            color: black; /* 파란색 계열 */
        }

        .nickname:hover {
            text-decoration: underline;
            color: #007bff; /* hover 시 더 진한 파란색 */
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<div class="portfolio-container">
    <h1>${portfolio.title}</h1>
    <p class="nickname">작성자 : ${portfolio.userNickname}</p>

    <div class="info-container">
        <p>작성일: <fmt:formatDate value="${portfolio.createdAt}" pattern="yyyy년 MM월 dd일" /></p>
        <c:if test="${portfolio.userPid == sessionScope.user_pid}">
            <div class="actions">
                <p id="update-portfolio">수정</p>
                <p id="delete-portfolio">삭제</p>
            </div>
        </c:if>
    </div>
    <c:forEach var="tag" items="${portfolioTags}">
        <c:if test="${not empty tag}">
            <span class="tag-badge">${tag}</span>
        </c:if>
    </c:forEach>

    <div id="viewer" class="markdown-viewer"></div>
    <textarea id="markdown-content" style="display:none;"><c:out value="${portfolio.content}" /></textarea>


    <div class="floating-nav">
        <c:choose>
            <c:when test="${is_like}">
                <button id="likeBtn" title="좋아요" style="background-color: #ef4444;">
                    <i class="fas fa-heart"></i></i>
                </button>
            </c:when>
            <c:otherwise>
                <button id="likeBtn" title="좋아요" style="background-color: #1d4ed8;">
                    <i class="far fa-heart"></i>
                </button>
            </c:otherwise>
        </c:choose>
        <p id="likeCount">${portfolio.likeCount}</p>
        <button id="copyBtn" title="복사">
            <i class="fas fa-copy"></i>
        </button>
    </div>

    <script>
        const userPid = "${sessionScope.user_pid}";
        const portfolioId = "${portfolio.id}";
        const markdownContent = document.getElementById("markdown-content").value;

        const updateText = document.getElementById("update-portfolio");
        const deleteText = document.getElementById("delete-portfolio");

        // 닉네임 클릭 시 사용자 페이지 이동
        $(document).on('click', '.nickname', function (e) {
            e.preventDefault();
            e.stopPropagation();
            const userPid = ${portfolio.userPid};
            console.log(`작성자 아이디 클릭:` + userPid);
            location.href = "${pageContext.request.contextPath}/personal/" + userPid;
        });

        if (updateText) {
            updateText.addEventListener("click", function () {
                location.href = `${pageContext.request.contextPath}/portfolio/update/${portfolioId}`;
            });
        }

        if (deleteText) {
            deleteText.addEventListener("click", function () {
                if (!confirm("정말 삭제하시겠습니까?")) return;

                fetch(`${pageContext.request.contextPath}/portfolio/delete/${portfolioId}`, {
                    method: "DELETE",
                    headers: {
                        "Content-Type": "application/json"
                    }
                })
                    .then(response => {
                        if (!response.ok) {
                            throw new Error("삭제 실패");
                        }
                        return response.text();
                    })
                    .then(result => {
                        alert("삭제되었습니다.");
                        window.location.href = `${pageContext.request.contextPath}/portfolio/list`;
                    })
                    .catch(error => {
                        console.error(error);
                        alert("삭제 중 오류가 발생했습니다.");
                    });
            });
        }

        const viewer = new toastui.Editor.factory({
            el: document.querySelector('#viewer'),
            viewer: true,
            initialValue: markdownContent
        });

        // 초기 좋아요 상태 저장
        let isLiked = ${is_like ? 'true' : 'false'};

        document.getElementById("likeBtn").addEventListener("click", function () {
            if (!userPid) {
                alert("로그인이 필요합니다.");
                return;
            }

            fetch(`${pageContext.request.contextPath}/portfolio/${portfolioId}/like`, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ userId: parseInt(userPid) })
            })
                .then(res => res.json())
                .then(data => {
                    const btn = document.getElementById("likeBtn");
                    const icon = btn.querySelector("i");
                    const likeCountEl = document.getElementById("likeCount");
                    let currentLikeCount = parseInt(likeCountEl.textContent);

                    if (data.liked) {
                        // 좋아요 상태로 UI 변경
                        btn.style.backgroundColor = "#ef4444";
                        icon.className = "fas fa-heart";
                        currentLikeCount += 1;
                    } else {
                        // 좋아요 취소 상태로 UI 변경
                        btn.style.backgroundColor = "#1d4ed8";
                        icon.className = "far fa-heart";
                        currentLikeCount -= 1;
                    }

                    // 상태 갱신
                    likeCountEl.textContent = currentLikeCount;
                    isLiked = data.liked;
                })
                .catch(err => {
                    console.error("좋아요 처리 중 오류 발생:", err);
                    alert("좋아요 처리 중 오류가 발생했습니다.");
                });
        });

        let searchSelect = document.querySelector("#search-select");
        const searchBox = document.getElementById("search-box");
        const tagUI = document.getElementById("tag-ui");
        document.querySelectorAll(".tag-badge").forEach(tag => {
            tag.addEventListener("click", function () {
                // 테그로 검색으로 변환
                if (!(searchSelect.value === "tag")){
                    searchSelect.value = "tag";
                    searchBox.classList.add("hidden");
                    tagUI.classList.remove("hidden");
                }
                const tagValue = this.textContent.trim(); // 클릭한 태그의 텍스트

                addTag(tagValue); // 검색창에 테그 더하기
            });
        });

        window.addEventListener("tagsUpdated", function (e) {
            const activeTags = e.detail.tags;

            document.querySelectorAll(".tag-badge").forEach(tagEl => {
                const tagValue = tagEl.textContent.trim();

                if (activeTags.includes(tagValue)) {
                    tagEl.classList.add("selected-tag");
                } else {
                    tagEl.classList.remove("selected-tag");
                }
            });
        });

        document.getElementById("copyBtn").addEventListener("click", function () {
            const currentUrl = window.location.href;

            navigator.clipboard.writeText(currentUrl)
                .then(() => {
                    alert("링크가 복사되었습니다.");
                })
                .catch(err => {
                    alert("복사에 실패했습니다.");
                    console.error("복사 실패: ", err);
                });
        });
    </script>
</div>
</body>
</html>
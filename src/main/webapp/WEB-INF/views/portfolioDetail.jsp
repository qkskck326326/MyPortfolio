<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
        .floating-nav {
            position: fixed;
            top: 40%;
            right: 40px;
            display: flex;
            flex-direction: column;
            gap: 16px;
            z-index: 999;
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
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<div class="portfolio-container">
    <h1>${portfolio.title}</h1>
    <p>작성자 : ${portfolio.userNickname}</p>
    <p>작성일: ${portfolio.createdAt}</p>
    <p>[ 기술테그 ]</p>
    <c:forEach var="tag" items="${portfolioTags}">
        <span class="tag-badge">${tag}</span>
    </c:forEach>

    <div id="viewer" class="markdown-viewer"></div>
    <textarea id="markdown-content" style="display:none;"><c:out value="${portfolio.content}" /></textarea>


    <div class="floating-nav">
        <c:choose>
            <c:when test="${is_like}">
                <button id="likeBtn" title="좋아요" style="background-color: #ef4444;">
                    <i class="fas fa-thumbs-up"></i>
                </button>
            </c:when>
            <c:otherwise>
                <button id="likeBtn" title="좋아요" style="background-color: #1d4ed8;">
                    <i class="far fa-thumbs-up"></i>
                </button>
            </c:otherwise>
        </c:choose>
        <button title="복사">
            <i class="fas fa-copy"></i>
        </button>
    </div>

    <script>
        const userPid = "${sessionScope.user_pid}";
        const portfolioId = "${portfolio.id}";
        <%--const markdownContent = `<c:out value='${portfolio.content}' escapeXml="true"/>`;--%>
        const markdownContent = document.getElementById("markdown-content").value;

        const viewer = new toastui.Editor.factory({
            el: document.querySelector('#viewer'),
            viewer: true,
            initialValue: markdownContent
        });

        // 초기 좋아요 상태를 저장 (JSP에서 Boolean -> JS Boolean)
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

                    if (data.liked) {
                        // 좋아요 상태로 UI 변경
                        btn.style.backgroundColor = "#ef4444";
                        icon.className = "fas fa-thumbs-up";
                    } else {
                        // 좋아요 취소 상태로 UI 변경
                        btn.style.backgroundColor = "#1d4ed8";
                        icon.className = "far fa-thumbs-up";
                    }

                    // 상태 갱신
                    isLiked = data.liked;
                })
                .catch(err => {
                    console.error("좋아요 처리 중 오류 발생:", err);
                    alert("좋아요 처리 중 오류가 발생했습니다.");
                });
        });
    </script>
</div>
</body>
</html>
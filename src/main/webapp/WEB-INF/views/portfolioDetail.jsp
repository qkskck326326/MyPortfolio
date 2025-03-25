<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>포트폴리오 상세</title>

    <!-- Toast UI Editor Viewer CSS & JS -->
    <link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
    <script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>

    <style>
        .portfolio-container {
            width: 80%;
            margin: 0 auto;
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
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<div class="portfolio-container">
    <h1>${portfolio.title}</h1>
    <p>작성자 : ${portfolio.userNickname}</p>
    <p>작성일: ${portfolio.createdAt}</p>

    <c:forEach var="tag" items="${portfolioTags}">
        <span class="tag-badge">${tag}</span>
    </c:forEach>

    <div id="viewer" class="markdown-viewer"></div>

    <script>
        const markdownContent = `<c:out value='${portfolio.content}' escapeXml="true"/>`;

        const viewer = new toastui.Editor.factory({
            el: document.querySelector('#viewer'),
            viewer: true,
            initialValue: markdownContent
        });
    </script>
</div>
</body>
</html>
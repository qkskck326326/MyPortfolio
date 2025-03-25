<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<script src="${pageContext.request.contextPath}/resources/js/jquery-3.6.0.js"></script>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>MyPortfolio</title>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<h1>${message}</h1>
<c:choose>
    <c:when test="${not empty sessionScope.user_nickname}">
        <p>안녕하세요, <strong>${sessionScope.user_nickname}</strong>님!</p>
        <button id="logoutBtn">로그아웃</button>
    </c:when>
    <c:otherwise>
        <p><a href="${pageContext.request.contextPath}/login">로그인</a>이 필요합니다.</p>
    </c:otherwise>
</c:choose>
<p><a href="${pageContext.request.contextPath}/user/register">회원가입</a>이 필요합니다.</p>
<a href="portfolio/new">포트폴리오 작성</a>
</body>
</html>

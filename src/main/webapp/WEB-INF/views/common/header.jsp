<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- Bootstrap Icons -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">

<style>
    /* 기본 레이아웃 설정 */
    body {
        padding-top: 100px; /* 헤더 높이만큼 콘텐츠 밀어내기 */
        background-color: #f5f5f5; /* 부드러운 배경 */
    }

    /* 헤더 스타일 */
    .header-bar {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 80px;
        background-color: #f8f9fa;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 30px;
        border-bottom: 2px solid #e0e0e0;
        box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
        z-index: 1000;
    }

    /* 로고 스타일 */
    .logo img {
        width: 60px;
        height: auto;
    }

    /* 우측 메뉴 스타일 */
    .menu-right {
        display: flex;
        align-items: center;
        gap: 15px;
    }

    /* 검색 입력창 */
    .search-box {
        padding: 8px 15px;
        border: 1px solid #ccc;
        border-radius: 20px;
        font-size: 16px;
        width: 220px;
        transition: 0.3s;
    }

    .search-box:focus {
        border-color: #007bff;
        outline: none;
        box-shadow: 0px 0px 5px rgba(0, 123, 255, 0.5);
    }

    /* 검색 버튼 */
    .search-btn {
        width: 100px;
        height: 45px;
        background-color: mediumseagreen;
        color: white;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 20px;
        font-size: 18px;
        font-weight: bold;
        cursor: pointer;
        transition: 0.3s;
    }

    .search-btn:hover {
        background-color: #0056b3;
    }

    /* 로그인 버튼 */
    .login-btn {
        width: 120px;
        height: 45px;
        padding: 10px 20px;
        font-size: 16px;
        font-weight: bold;
        color: white;
        background-color: black;
        border: none;
        border-radius: 25px;
        cursor: pointer;
        transition: 0.3s;
    }

    .login-btn:hover {
        background-color: gray;
    }

    /* 드롭다운 스타일 */
    .form-select {
        width: 120px;
        border-radius: 10px;
        font-size: 14px;
        padding: 8px;
    }
</style>

<!-- 헤더바 -->
<div class="header-bar">
    <!-- 좌측 로고 -->
    <div class="logo">
        <a href="${pageContext.request.contextPath}/">
            <img src="${pageContext.request.contextPath}/resources/images/logo.webp" alt="Home" class="img-fluid">
        </a>
    </div>

    <!-- 우측 메뉴 -->
    <div class="menu-right">
        <!-- 드롭다운 -->
        <select class="form-select">
            <option value="popular">인기순</option>
            <option value="latest" selected>최신순</option>
        </select>

        <!-- 검색 입력창 -->
        <input type="text" class="search-box" placeholder="검색어 입력">

        <!-- 검색 버튼 -->
        <div class="search-btn">검색</div>

        <!-- 로그인 버튼 -->


        <c:choose>
            <c:when test="${not empty sessionScope.user_nickname}">
                <!-- 사용자 정보 및 로그아웃 버튼 -->
                <div class="user-info d-flex align-items-center bg-light p-2 rounded">
                    <i class="bi bi-person-circle fs-4 text-primary me-2"></i>
                    <span class="fw-bold text-primary me-3">${sessionScope.user_nickname} 님</span>
                    <button id="logoutBtn" class="btn btn-danger px-3 py-2 d-flex align-items-center">
                        <i class="bi bi-box-arrow-right me-1"></i> 로그아웃
                    </button>
                </div>

                <!-- Bootstrap Icons 추가 -->
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">

            </c:when>
            <c:otherwise>
                <button class="login-btn" onclick="location.href='${pageContext.request.contextPath}/login'">로그인</button>
            </c:otherwise>
        </c:choose>
    </div>
</div>
<!-- 로그아웃 모달 -->
<div class="modal fade" id="logoutModal" tabindex="-1" aria-labelledby="logoutModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title" id="logoutModalLabel">
                    <i class="bi bi-box-arrow-right"></i> 로그아웃
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body text-center">
                <p class="fs-5 fw-bold text-danger">❗ 로그아웃 하시겠습니까?</p>
            </div>
            <div class="modal-footer justify-content-center">
                <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-danger px-4" id="logoutConfirmBtn">확인</button>
            </div>
        </div>
    </div>
</div>


<script>
    document.addEventListener("DOMContentLoaded", function() {
        // 로그아웃 버튼 클릭 시 로그아웃 모달 띄우기
        document.getElementById("logoutBtn").addEventListener("click", function() {
            showLogoutModal();
        });

        // 확인 버튼 클릭 시 메인 페이지로 이동
        document.getElementById("logoutConfirmBtn").addEventListener("click", function() {
            $.post("${pageContext.request.contextPath}/logout", function (res) {
                if (res.status === "success") {
                    location.reload(); // 페이지 새로고침
                }
            });
        });

        // 로그아웃 이벤트 발생 시 모달 열기
        function showLogoutModal() {
            var logoutModal = new bootstrap.Modal(document.getElementById("logoutModal"));
            logoutModal.show();
        }
    });
</script>

<script>
    $(document).ready(function () {
        $("#logoutBtn").click(function () {

        });
    });
</script>
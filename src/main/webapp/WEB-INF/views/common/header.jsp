<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script src="${pageContext.request.contextPath}/resources/js/jquery-3.6.0.js"></script>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
        width: 140px;
        border-radius: 10px;
        font-size: 14px;
        padding: 8px;
    }

    .hidden {
        display: none !important;
    }

    .tag-chip {
        background-color: #e0f7fa;
        border: 1px solid #00bcd4;
        border-radius: 20px;
        padding: 6px 12px;
        font-size: 14px;
        color: #007baf;
        display: flex;
        align-items: center;
        gap: 5px;
    }

    .tag-chip i {
        cursor: pointer;
    }

    .tag-box {
        position: absolute;
        top: calc(100% + 8px); /* 입력창 바로 아래 (8px 간격) */
        left: 0;
        width: 300px; /* 고정 가로 크기 */
        background-color: white;
        border: 1px solid #ccc;
        border-radius: 12px;
        padding: 10px;
        z-index: 999;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);

        max-height: 200px; /* 태그 많아질 경우 대비 */
        overflow-y: auto;
    }

</style>

<%-- 옵션 전달받았을 경우 --%>
<c:if test="${not empty takenSearchOption}">
    <script>
        window.hasTakenSearchOption = true;
        window.takenSearchOption = {
            searchOption: "${takenSearchOption.searchOption}",
            orderBy: "${takenSearchOption.orderBy}",
            keyword: "${takenSearchOption.keyword}",
            tags: [
                <c:forEach var="tag" items="${takenSearchOption.tags}" varStatus="status">
                "${tag}"<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            ]
        };
        console.log(takenSearchOption);
    </script>
</c:if>

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

        <%--검색 기준 드롭다운--%>
        <select id="search-select" class="form-select">
            <option value="tag">테그로 검색</option>
            <option value="title" selected>제목으로 검색</option>
        </select>

        <!-- 정렬 기준 드롭다운 -->
        <select id="sort-select" class="form-select">
            <option value="popular">인기순</option>
            <option value="latest" selected>최신순</option>
        </select>

        <!-- 태그 입력 UI -->
        <div id="tag-ui" class="hidden d-flex flex-column align-items-start position-relative">
            <input type="text" id="tag-input-header" class="search-box" placeholder="태그 입력 후 , (쉼표)" style="margin-top: 8px;">

            <!-- 태그 리스트 영역 -->
            <div class="tag-box">
                <div id="tag-list" class="d-flex flex-wrap" style="gap: 8px;">
                    <span id="tag-placeholder" class="text-muted">테그를 입력해 주세요</span>
                </div>
            </div>
        </div>

        <!-- 검색 입력창 -->
        <input type="text" id="search-box" class="search-box" placeholder="검색어 입력">

        <!-- 검색 버튼 -->
        <div id="search-btn" class="search-btn">검색</div>


        <!-- 로그인 버튼 -->
        <c:choose>
            <c:when test="${not empty sessionScope.user_nickname}">
                <!-- 사용자 정보 및 로그아웃 버튼 -->
                <div class="user-info d-flex align-items-center bg-light p-2 rounded">
                    <i class="bi bi-person-circle fs-4 text-primary me-2"></i>
                    <span class="fw-bold text-primary me-3">${sessionScope.user_nickname} 님</span>

                    <!-- 작성 버튼 -->
                    <button class="btn btn-success fw-bold px-3 py-2"
                            onclick="location.href='${pageContext.request.contextPath}/portfolio/new'">
                        <i class="bi bi-pencil-square me-1"></i> 프로젝트 작성
                    </button>
                    &nbsp;
                    <button id="logoutBtn" class="btn btn-danger px-3 py-2 d-flex align-items-center">
                        <i class="bi bi-box-arrow-right me-1"></i> 로그아웃
                    </button>
                </div>

                <!-- Bootstrap Icons 추가 -->
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">

            </c:when>
            <c:otherwise>
                <button class="login-btn" onclick="location.href='${pageContext.request.contextPath}/login'">로그인
                </button>
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
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                        aria-label="Close"></button>
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
    const tags = [];
    const tagList = document.getElementById("tag-list");

    document.addEventListener("DOMContentLoaded", function () {
        const searchSelect = document.getElementById("search-select");
        const searchBox = document.getElementById("search-box");
        const tagUI = document.getElementById("tag-ui");
        const tagInput = document.getElementById("tag-input-header");


        // 로그아웃 버튼 클릭 시 로그아웃 모달 띄우기
        const logoutBtn = document.getElementById("logoutBtn");
        if (logoutBtn) {
            logoutBtn.addEventListener("click", function () {
                showLogoutModal();
            });
        }

        // 확인 버튼 클릭 시 메인 페이지로 이동
        const logoutConfirmBtn = document.getElementById("logoutConfirmBtn");
        if (logoutConfirmBtn) {
            logoutConfirmBtn.addEventListener("click", function () {
                $.post("${pageContext.request.contextPath}/logout", function (res) {
                    if (res.status === "success") {
                        location.reload();
                    }
                });
            });
        }

        // 검색 기준 변경 시 UI 전환
        searchSelect.addEventListener("change", function () {
            if (this.value === "tag") {
                searchBox.value = null;
                searchBox.classList.add("hidden");
                tagUI.classList.remove("hidden");
            } else {
                searchBox.classList.remove("hidden");
                tagUI.classList.add("hidden");
            }
        });

        <c:if test="${not empty takenSearchOption}">
            console.log("JSP에서 받은 옵션:", "${takenSearchOption.searchOption}");
        </c:if>

        // 태그 입력 후 , (쉼표) 입력 시 추가
        tagInput.addEventListener("keydown", function (e) {
            if (e.key === "," && this.value.trim() !== "") {
                e.preventDefault();
                const tag = this.value.trim().toLowerCase();

                addTag(tag);
                this.value = "";
            }
        });

        // 엔터로 검색 트리거
        const searchBtn = document.getElementById("search-btn");
        tagInput.addEventListener("keypress", function (e) {
            if (e.key === "Enter" && tags.length > 0) {
                e.preventDefault();
                searchBtn.click(); // 검색 버튼 클릭 트리거
            }
        });
        searchBox.addEventListener("keyup", function (e) {
            if (e.key === "Enter" && searchSelect.value === "title") {
                e.preventDefault();
                searchBtn.click(); // 검색 버튼 클릭 트리거
            }
        });

        // 메인 페이지 밖에서 클릭 되었을 경우, 설정을 가지고 메인으로 이동
        const isMainPage = ${fn:contains(pageContext.request.requestURI, '/index.jsp') ? 'true' : 'false'};
        searchBtn.addEventListener("click", function (e){
            if (!isMainPage){
                e.preventDefault();
                const form = document.createElement("form");
                form.method = "POST";
                form.action = `${pageContext.request.contextPath}/portfolio/search/withoutIndexPage`;
                form.style.display = "none";

                form.appendChild(createHiddenInput("searchOption", searchSelect.value));
                form.appendChild(createHiddenInput("orderBy", document.getElementById("sort-select").value));
                form.appendChild(createHiddenInput("keyword", searchBox.value));
                form.appendChild(createHiddenInput("tags", tags.join(",")));

                document.body.appendChild(form);
                form.submit();

                function createHiddenInput(name, value) {
                    const input = document.createElement("input");
                    input.type = "hidden";
                    input.name = name;
                    input.value = value;
                    return input;
                }
            }
        });

        if (window.hasTakenSearchOption) {
            console.log("옵션 전달됨.")
            const option = window.takenSearchOption;

            // 검색 옵션
            document.getElementById("search-select").value = option.searchOption || "title";
            document.getElementById("sort-select").value = option.orderBy || "latest";

            if (option.searchOption === "title") {
                document.getElementById("search-box").value = option.keyword || "";
            } else if (option.searchOption === "tag" && option.tags.length > 0) {
                // 태그를 하나씩 입력 UI에 적용
                option.tags.forEach(tag => {
                    // tags 배열 재구성 등 기존 동작 로직 활용
                    console.log("불러온 태그:", tag);
                    addTag(tag);
                });
                searchBox.classList.add("hidden");
                tagUI.classList.remove("hidden");
            }


        }

    });

    // 테그 추가 함수
    function addTag(tag){
        if (tags.includes(tag)) {
            alert("이미 존재하는 태그입니다.");
            return;
        }

        tags.push(tag);

        const tagEl = document.createElement("span");
        tagEl.className = "tag-chip";
        tagEl.innerHTML = `\${tag} <i class="bi bi-x-lg" data-tag="\${tag}"></i>`;

        // 삭제 이벤트
        tagEl.querySelector("i").addEventListener("click", function () {
            const value = this.getAttribute("data-tag");
            tags.splice(tags.indexOf(value), 1);
            tagEl.remove();
            updateTagPlaceholder()
            triggerTagUpdate()
        });

        tagList.appendChild(tagEl);
        updateTagPlaceholder();
        triggerTagUpdate()
    }

    function updateTagPlaceholder() {
        const placeholder = document.getElementById("tag-placeholder");
        if (tags.length === 0) {
            placeholder.style.display = "inline";
        } else {
            placeholder.style.display = "none";
        }
    }

    // 로그아웃 이벤트 발생 시 모달 열기
    function showLogoutModal() {
        var logoutModal = new bootstrap.Modal(document.getElementById("logoutModal"));
        logoutModal.show();
    }

    // 테그 수정 이벤트
    function triggerTagUpdate() {
        const event = new CustomEvent("tagsUpdated", { detail: { tags } });
        window.dispatchEvent(event); // 전역으로 이벤트 발행
    }

</script>
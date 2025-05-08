<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>포트폴리오 작성</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Toast UI Editor CSS -->
    <link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css">
    <%--jQuery--%>
    <script src="${pageContext.request.contextPath}/resources/js/jquery-3.6.0.js"></script>

    <style>
        .tag-item {
            background-color: #0dcaf0;
            color: #fff;
            padding: 4px 10px;
            border-radius: 20px;
            margin: 3px;
            display: inline-block;
        }

        .tag-item button {
            color: #fff;
            margin-left: 8px;
            background: transparent;
            border: none;
            cursor: pointer;
        }

        .toastui-editor-defaultUI {
            background-color: #ffffff !important;
            width: 100% !important;
            max-width: 100%;
            overflow: hidden;
        }

        .editor-container {
            width: calc(100% - 40px);
            height: 80vh;
            margin: 0 auto;
        }

        #editor {
            width: 100%;
            height: 100%;
        }

        .content-wrapper {
            width: calc(100% - 40px);
            margin: 0 auto;
            padding: 0 20px;
        }

        .tag-container {
            display: flex;
            flex-direction: column;
            width: 100%;
            gap: 10px;
        }

        #tag-input {
            width: 100%;
        }

        #tag-box {
            width: 100%;
            min-height: 40px;
            border: 1px solid #ced4da;
            border-radius: 5px;
            padding: 5px;
        }

        .button-container {
            display: flex;
            margin-right: 20px;
            justify-content: flex-end;
            align-items: flex-end;
            height: 100%;
            margin-top: 10px;
        }
    </style>
</head>
<body>
<div class="container-fluid py-4 content-wrapper">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <form id="portfolioForm">
        <div class="mb-3">
            <label>포트폴리오 명</label>
            <input type="text" class="form-control" id="title">
            <label for="tag-input" class="form-label">태그 입력</label>
            <div class="tag-container">
                <input type="text" class="form-control" id="tag-input" placeholder="태그 입력 후 엔터 또는 쉼표(,)를 눌러 등록">
                <div id="tag-box" class="border rounded p-2"></div>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label">내용 작성</label>
            <div class="editor-container">
                <div id="editor"></div>
            </div>
            <div class="button-container">
                <button type="button" class="btn btn-primary btn-lg">글 등록</button>
            </div>
        </div>
    </form>

</div>

<script id="portfolio-data" type="application/json">
    <c:out value="${portfolioJson}" escapeXml="false" />
</script>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<!-- Toast UI Editor JS -->
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>

<script>
    let thumbnail = null;
    let portfolioDTO = null;
    let portfolio = null;

    const portfolioDataElement = document.getElementById("portfolio-data");
    if (portfolioDataElement) {
        try {
            portfolioDTO = JSON.parse(portfolioDataElement.textContent);
        } catch (e) {
            console.error("JSON 파싱 실패:", e);
        }
    }

    document.addEventListener("DOMContentLoaded", function () {
        const button = document.querySelector('.button-container button');
        const tagInput = document.getElementById('tag-input');
        const tagBox = document.getElementById('tag-box');

        button.removeEventListener('click', handleButtonClick);
        button.addEventListener('click', handleButtonClick);

        // 전역 변수로 선언 (undefined 방지)
        window.tags = [];

        // portfolio 존재시 대입
        if (portfolioDTO) {
            portfolio = portfolioDTO.portfolio;
            console.log("포트폴리오 id : " + portfolio.id)
            document.getElementById('title').value = portfolio.title;
            editor.setMarkdown(portfolio.content);

            window.tags = portfolioDTO.tags || [];
            renderTags();
        }

        // 태그 입력 이벤트 리스너
        tagInput.addEventListener('keydown', function (e) {
            if (e.key === 'Enter' || e.key === ',') {
                e.preventDefault();
                addTag(tagInput.value);
                tagInput.value = '';
            }
        });

        function addTag(tag) {
            tag = tag.trim().toLowerCase();
            if (tag && !window.tags.includes(tag)) {
                window.tags.push(tag);
                renderTags();
            }
        }

        function removeTag(tag) {
            window.tags = window.tags.filter(t => t !== tag);
            renderTags();
        }

        function renderTags() {
            tagBox.innerHTML = '';
            window.tags.forEach(tag => {
                const tagEl = document.createElement('span');
                tagEl.className = 'tag-item';
                tagEl.textContent = tag;

                const removeBtn = document.createElement('button');
                removeBtn.type = 'button';
                removeBtn.innerHTML = '&times;';
                removeBtn.onclick = () => removeTag(tag);

                tagEl.appendChild(removeBtn);
                tagBox.appendChild(tagEl);
            });
        }

        // AJAX 요청 (프로젝트 등록)
        // 버튼 클릭 이벤트 함수
        function handleButtonClick(e) {
            e.preventDefault();

            const title = document.getElementById('title').value;
            const content = editor.getMarkdown();
            const tags = window.tags ? window.tags.join(',') : "";

            if (!title.trim()) {
                alert("프로젝트 명을 입력해주세요.");
                return;
            }

            if (!content.trim()) {
                alert("내용을 입력해주세요.");
                return;
            }

            const rawTags = window.tags ? window.tags.join(',') : "";
            const tagList = rawTags
                .split(",")
                .map(t => t.trim())
                .filter(t => t.length > 0); // 공백 테그 제거

            if (portfolioDTO){
                $.ajax({
                    type: "POST",
                    url: "${pageContext.request.contextPath}/portfolio/update",
                    contentType: "application/json",
                    data: JSON.stringify({
                        portfolioId : portfolio.id,
                        title: title,
                        content: content,
                        thumbnail : thumbnail,
                        tags: tagList
                    }),
                    success: function (response) {
                        alert(response.message); // 서버에서 보낸 메시지 출력
                        window.location.href = "${pageContext.request.contextPath}/portfolio/" + response.portfolioId; // 포트폴리오 상세 페이지로 이동
                    },
                    error: function (xhr, status, error) {
                        console.log(xhr.responseText)
                        alert("등록 중 오류가 발생했습니다");
                    }
                });
            }else{
                $.ajax({
                    type: "POST",
                    url: "${pageContext.request.contextPath}/portfolio/post",
                    contentType: "application/json",
                    data: JSON.stringify({
                        title: title,
                        content: content,
                        thumbnail : thumbnail,
                        tags: tagList
                    }),
                    success: function (response) {
                        alert(response.message); // 서버에서 보낸 메시지 출력
                        window.location.href = "${pageContext.request.contextPath}/portfolio/" + response.portfolioId; // 포트폴리오 상세 페이지로 이동
                    },
                    error: function (xhr, status, error) {
                        console.log(xhr.responseText)
                        alert("등록 중 오류가 발생했습니다");
                    }
                });
            }

        }
    });

    // Toast UI Editor 초기화
    const editor = new toastui.Editor({
        el: document.querySelector('#editor'),
        height: "100%",
        initialEditType: 'markdown',
        previewStyle: 'vertical',
        language: 'ko',
        hooks: {
            addImageBlobHook: async (blob, callback) => {
                const formData = new FormData();
                formData.append("image", blob);

                try {
                    const res = await fetch("https://api.imgbb.com/1/upload?key=a714e7f73bc8a242a9218c35c7b75e9e", {
                        method: "POST",
                        body: formData
                    });

                    const result = await res.json();

                    if (result.success) {
                        const imageUrl = result.data.url;
                        if (!thumbnail) {
                            thumbnail = imageUrl;
                        }
                        callback(imageUrl, 'image');
                    } else {
                        alert("이미지 업로드 실패: " + result.error.message);
                    }
                } catch (err) {
                    alert("이미지 업로드 중 오류 발생: " + err.message);
                }
            }
        }
    });
</script>
</body>
</html>
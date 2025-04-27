<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
    <title>유저 정보 페이지</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #e9ecef; padding: 40px; }
        .id-card { width: 600px; margin: auto; background: #fff; border: 2px solid #dee2e6; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); padding: 20px; }
        .id-header { display: flex; align-items: center; }
        .id-photo img { width: 140px; height: 180px; object-fit: cover; border-radius: 8px; border: 1px solid #adb5bd; }
        .id-info { margin-left: 25px; font-family: 'Arial', sans-serif; }
        .id-info p { margin: 6px 0; font-size: 16px; }
        .id-title { text-align: center; font-weight: bold; margin-bottom: 20px; font-size: 20px; }
        .id-introduce { margin-top: 20px; padding-top: 10px; border-top: 1px solid #ced4da; font-size: 15px; }
        .edit-actions { margin-top: 15px; text-align: center; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="id-card">
    <div class="id-title">MyPortfolio 신분증</div>
    <div class="id-header">
        <div class="id-photo" id="userThumbnail">
            <p>Loading...</p>
        </div>
        <div class="id-info">
            <p><strong>닉네임:</strong>
                <span id="userNicknameView"></span>
                <input type="text" id="userNicknameInput" class="form-control d-none">
            </p>
            <p><strong>Email:</strong>
                <span id="userEmailView"></span>
                <input type="email" id="userEmailInput" class="form-control d-none">
            </p>
            <p><strong>GitHub:</strong>
                <span id="userGithubView"></span>
                <button id="goGithubBtn" class="btn btn-sm btn-outline-primary ms-2">이동</button>
                <input type="text" id="userGithubInput" class="form-control d-none mt-1">
            </p>
            <p><strong>생년월일:</strong> <span id="userBirth"></span></p>
        </div>
    </div>
    <div class="id-introduce">
        <strong>소개:</strong>
        <p id="userIntroduceView"></p>
        <textarea id="userIntroduceInput" class="form-control d-none" maxlength="1000"></textarea>
        <small id="introduceCount" class="d-none">0 / 1000</small>
    </div>
</div>

<div class="text-center mt-3 edit-actions">
    <button id="startEditThumbnailBtn" class="btn btn-primary me-2">📸 썸네일 수정</button>
    <button id="startEditInfoBtn" class="btn btn-warning">✏️ 정보 수정</button>
    <button id="confirmInfoEditBtn" class="btn btn-success d-none">저장</button>
    <button id="cancelInfoEditBtn" class="btn btn-secondary d-none">취소</button>
</div>

<!-- 썸네일 수정 UI -->
<div id="editThumbnailSection" style="display:none; margin-top:20px;" class="text-center">
    <p><strong>새 썸네일 업로드</strong></p>
    <input type="file" id="thumbnailUpload" accept="image/*" class="form-control mb-3" style="max-width:300px; margin:auto;">
    <div id="uploadPreview" class="mb-3"></div>
    <button id="confirmThumbnailBtn" class="btn btn-success me-2">썸네일 저장</button>
    <button id="cancelThumbnailBtn" class="btn btn-secondary">취소</button>
</div>

<script src="${pageContext.request.contextPath}/resources/js/jquery-3.6.0.js"></script>
<script>
    let userInfo = {};
    let uploadedThumbnailUrl = "";
    const imgbbApiKey = "a714e7f73bc8a242a9218c35c7b75e9e";

    // 날짜 포맷팅 함수
    function formatDate(dateInput) {
        const date = new Date(dateInput);
        const year = date.getFullYear();
        const month = ('0' + (date.getMonth() + 1)).slice(-2);
        const day = ('0' + date.getDate()).slice(-2);
        return year + "년 " + month + "월 " + day + "일"
    }

    $(document).ready(function() {
        // 유저 정보 불러오기
        $.ajax({
            url: "${pageContext.request.contextPath}/user/get/myInfo",
            type: "POST",
            success: function(data) {
                userInfo = data;
                $("#userNicknameView").text(data.nickname);
                $("#userEmailView").text(data.email || "-");
                $("#userGithubView").text(data.github || "-");
                // 생년월일 포맷 적용
                if (data.birth) {
                    $("#userBirth").text(formatDate(data.birth));
                } else {
                    $("#userBirth").text("-");
                }
                $("#userIntroduceView").text(data.introduce || "없음");

                if (data.userThumbnail) {
                    $("#userThumbnail").html('<img src="' + data.userThumbnail + '" alt="썸네일">');
                } else {
                    $("#userThumbnail").html('<img src="https://via.placeholder.com/140x180?text=No+Image">');
                }

                // 깃허브 버튼 기능
                if (data.github && data.github.trim() !== "") {
                    $("#goGithubBtn").click(function() {
                        window.open(data.github, "_blank");
                    });
                } else {
                    $("#goGithubBtn").prop("disabled", true);
                }
            }
        });

        // 정보 수정 모드
        $("#startEditInfoBtn").click(function() {
            $("#userNicknameView, #userEmailView, #userGithubView, #userIntroduceView").hide();
            $("#userNicknameInput, #userEmailInput, #userGithubInput, #userIntroduceInput, #introduceCount").removeClass("d-none");

            $("#userNicknameInput").val(userInfo.nickname);
            $("#userEmailInput").val(userInfo.email);
            $("#userGithubInput").val(userInfo.github);
            $("#userIntroduceInput").val(userInfo.introduce);

            $("#introduceCount").text(`${userInfo.introduce.length} / 1000`);

            $("#startEditInfoBtn").hide();
            $("#confirmInfoEditBtn, #cancelInfoEditBtn").removeClass("d-none");
        });

        $("#userIntroduceInput").on("input", function() {
            $("#introduceCount").text($(this).val().length + " / 1000");
        });

        $("#confirmInfoEditBtn").click(function() {
            const updatedData = {
                nickname: $("#userNicknameInput").val(),
                email: $("#userEmailInput").val(),
                github: $("#userGithubInput").val(),
                introduce: $("#userIntroduceInput").val()
            };

            $.ajax({
                url: "${pageContext.request.contextPath}/user/update/info",
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify(updatedData),
                success: function() {
                    alert("정보 수정 완료!");
                    location.reload();
                },
                error: function() {
                    alert("정보 수정 실패!");
                }
            });
        });

        $("#cancelInfoEditBtn").click(() => location.reload());

        // 썸네일 수정 로직
        $("#startEditThumbnailBtn").click(() => $("#editThumbnailSection").slideDown());

        $("#thumbnailUpload").on("change", function(event) {
            const file = event.target.files[0];
            if (!file) return;

            const formData = new FormData();
            formData.append('image', file);

            $.ajax({
                url: "https://api.imgbb.com/1/upload?key=" + imgbbApiKey,
                type: "POST",
                processData: false,
                contentType: false,
                data: formData,
                success: function(response) {
                    uploadedThumbnailUrl = response.data.url;
                    $("#uploadPreview").html('<img src="' + uploadedThumbnailUrl + '" style="max-width:150px;">');
                },
                error: function() {
                    alert("이미지 업로드 실패!");
                }
            });
        });

        $("#confirmThumbnailBtn").click(function() {
            if (!uploadedThumbnailUrl) {
                alert("이미지를 업로드하세요.");
                return;
            }

            $.ajax({
                url: "${pageContext.request.contextPath}/user/update/thumbnail",
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify({ thumbnail: uploadedThumbnailUrl }),
                success: function() {
                    alert("썸네일 수정 완료!");
                    location.reload();
                },
                error: function() {
                    alert("썸네일 수정 실패!");
                }
            });
        });

        $("#cancelThumbnailBtn").click(() => {
            $("#editThumbnailSection").slideUp();
            $("#uploadPreview").empty();
            $("#thumbnailUpload").val("");
            uploadedThumbnailUrl = "";
        });
    });
</script>
</body>
</html>

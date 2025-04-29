<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>회원가입</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="<c:url value='/resources/js/jquery-3.6.0.js'/>"></script>

  <style>
    body {
      background-color: #f8f9fa;
    }
    .container {
      max-width: 500px;
      margin-top: 40px;
    }
    .card {
      padding: 20px 25px;
      border-radius: 10px;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }
    .form-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 15px;
    }
    .form-grid-full {
      grid-column: 1 / 3;
    }
    .thumbnail-section {
      margin-bottom: 30px;
    }
    .thumbnail-preview img {
      width: 150px;
      height: 150px;
      object-fit: cover;
      border-radius: 8px;
      border: 1px solid #dee2e6;
    }
    .form-label {
      font-weight: bold;
    }
    .form-text {
      margin-top: 5px;
    }
    .error-msg {
      color: red;
      font-size: 14px;
      margin-top: 10px;
    }
  </style>

</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<div class="container">
  <div class="card">
    <h2 class="text-center mb-4">회원가입</h2>

    <div class="thumbnail-section d-flex align-items-center justify-content-center gap-3">
      <label class="form-label">썸네일</label><br>
      <input type="file" id="thumbnailUpload" accept="image/*" class="form-control" style="max-width:200px;">
      <div id="uploadPreview" class="thumbnail-preview"></div>
    </div>

    <form id="registerForm" class="form-grid">
      <div>
        <label class="form-label">아이디</label>
        <div class="input-group">
          <input type="text" class="form-control" id="userId" required isValid="false">
          <button type="button" id="checkUserIdBtn" class="btn btn-outline-secondary btn-sm">중복 확인</button>
        </div>
        <p id="userIdMessage" class="form-text text-danger"></p>
      </div>

      <div>
        <label class="form-label">닉네임</label>
        <div class="input-group">
          <input type="text" class="form-control" id="nickname" required isValid="false">
          <button type="button" id="checkNicknameBtn" class="btn btn-outline-secondary btn-sm">중복 확인</button>
        </div>
        <p id="nicknameMessage" class="form-text text-danger"></p>
      </div>

      <div>
        <label class="form-label">비밀번호</label>
        <input type="password" class="form-control" id="password" required>
        <p id="passwordMessage" class="form-text"></p>
      </div>

      <div>
        <label class="form-label">비밀번호 확인</label>
        <input type="password" class="form-control" id="passwordCheck" required>
      </div>

      <div>
        <label class="form-label">이메일</label>
        <input type="email" class="form-control" id="email">
      </div>

      <div>
        <label class="form-label">GitHub 링크</label>
        <input type="url" class="form-control" id="github">
      </div>

      <div class="form-grid-full">
        <label class="form-label">생년월일</label>
        <input type="date" class="form-control" id="birth" required>
      </div>

      <div class="form-grid-full">
        <label class="form-label">자기소개</label>
        <textarea class="form-control" id="introduce" rows="3"></textarea>
      </div>

      <div class="form-grid-full">
        <button type="submit" class="btn btn-primary w-100 mt-3">회원가입</button>
      </div>

      <p id="errorMsg" class="error-msg text-center form-grid-full"></p>
    </form>
  </div>
</div>

<script>
  let uploadedThumbnailUrl = "";

  $(document).ready(function() {
    $("#thumbnailUpload").on("change", function(event) {
      const file = event.target.files[0];
      if (!file) return;

      const formData = new FormData();
      formData.append('image', file);

      $.ajax({
        url: "https://api.imgbb.com/1/upload?key=a714e7f73bc8a242a9218c35c7b75e9e",
        type: "POST",
        processData: false,
        contentType: false,
        data: formData,
        success: function(response) {
          if (response && response.data && response.data.url) {
            uploadedThumbnailUrl = response.data.url;
            $("#uploadPreview").html('<img src="' + uploadedThumbnailUrl + '">');
          } else {
            alert("썸네일 업로드는 되었지만 URL을 찾을 수 없습니다.");
          }
        },
        error: function() {
          alert("썸네일 업로드 실패!");
        }
      });
    });

    $("#registerForm").submit(function(event) {
      event.preventDefault();

      if (!$("#userId").attr("isValid") || $("#userId").attr("isValid") !== "true") {
        alert("아이디 중복 확인을 해주세요.");
        return;
      }
      if (!$("#nickname").attr("isValid") || $("#nickname").attr("isValid") !== "true") {
        alert("닉네임 중복 확인을 해주세요.");
        return;
      }
      if ($("#password").val() !== $("#passwordCheck").val()) {
        alert("비밀번호가 일치하지 않습니다.");
        return;
      }

      $.ajax({
        type: "POST",
        url: "${pageContext.request.contextPath}/user/register",
        contentType: "application/json",
        data: JSON.stringify({
          userId: $("#userId").val(),
          password: $("#password").val(),
          nickname: $("#nickname").val(),
          email: $("#email").val(),
          github: $("#github").val(),
          birth: $("#birth").val(),
          introduce: $("#introduce").val(),
          userThumbnail: uploadedThumbnailUrl
        }),
        success: function(res) {
          if (res.status === "success") {
            alert(res.message);
            location.href = "${pageContext.request.contextPath}/login";
          } else {
            $("#errorMsg").text(res.message);
          }
        },
        error: function() {
          alert("서버 통신 오류가 발생했습니다.");
        }
      });
    });

    $("#nickname").on("input", function() {
      $("#nickname").attr("isValid", "false");
      $("#nicknameMessage").text("");
    });

    $("#checkNicknameBtn").click(function() {
      let nickname = $("#nickname").val().trim();
      if (nickname === "") {
        $("#nicknameMessage").text("닉네임을 입력하세요.");
        return;
      }
      $.ajax({
        type: "POST",
        url: `${pageContext.request.contextPath}/user/nickname/exist`,
        contentType: "application/json",
        data: JSON.stringify({ nickname: nickname }),
        success: function(response) {
          if (response) {
            $("#nicknameMessage").text("이미 사용 중인 닉네임입니다.").css("color", "red");
            $("#nickname").attr("isValid", "false");
          } else {
            $("#nicknameMessage").text("사용 가능한 닉네임입니다.").css("color", "green");
            $("#nickname").attr("isValid", "true");
          }
        },
        error: function() {
          $("#nicknameMessage").text("서버 오류가 발생했습니다.");
        }
      });
    });

    $("#userId").on("input", function() {
      $("#userId").attr("isValid", "false");
      $("#userIdMessage").text("");
    });

    $("#checkUserIdBtn").click(function() {
      let userId = $("#userId").val().trim();
      if (userId === "") {
        $("#userIdMessage").text("아이디를 입력하세요.");
        return;
      }
      $.ajax({
        type: "POST",
        url: `${pageContext.request.contextPath}/user/userId/exist`,
        contentType: "application/json",
        data: JSON.stringify({ userId: userId }),
        success: function(response) {
          if (response) {
            $("#userIdMessage").text("이미 사용 중인 아이디입니다.").css("color", "red");
            $("#userId").attr("isValid", "false");
          } else {
            $("#userIdMessage").text("사용 가능한 아이디입니다.").css("color", "green");
            $("#userId").attr("isValid", "true");
          }
        },
        error: function() {
          $("#userIdMessage").text("서버 오류가 발생했습니다.");
        }
      });
    });

    $("#password, #passwordCheck").on("input", function() {
      let password = $("#password").val();
      let passwordCheck = $("#passwordCheck").val();
      let messageElement = $("#passwordMessage");

      if (password !== passwordCheck) {
        messageElement.text("비밀번호가 일치하지 않습니다.").css("color", "red");
      } else {
        messageElement.text("비밀번호가 일치합니다!").css("color", "green");
      }
    });
  });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
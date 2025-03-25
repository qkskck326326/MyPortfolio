<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>회원가입</title>

  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

  <!-- jQuery -->
  <script src="<c:url value='/resources/js/jquery-3.6.0.js'/>"></script>

  <style>
    body {
      background-color: #f8f9fa;
    }
    .container {
      max-width: 500px !important;
      margin-top: 50px;
    }
    .card {
      padding: 20px;
      border-radius: 10px;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
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
    <h2 class="text-center">회원가입</h2>

    <form id="registerForm">
      <div class="mb-3">
        <label class="form-label">아이디</label>
        <div class="input-group">
          <input type="text" class="form-control" id="userId" name="userId" isValid="false" required>
          <button type="button" id="checkUserIdBtn" class="btn btn-outline-secondary focus-ring">중복 확인</button>
        </div>
        <p id="userIdMessage"></p>
      </div>

      <div class="mb-3">
        <label class="form-label">비밀번호</label>
        <input type="password" class="form-control" id="password" name="password" isValid="false" required>
      </div>

      <div class="mb-3">
        <label class="form-label">비밀번호 확인</label>
        <input type="password" class="form-control" id="passwordCheck" name="passwordCheck" required>
        <p id="passwordMessage"></p>
      </div>

      <div class="mb-3">
        <label class="form-label">닉네임</label>
        <div class="input-group">
          <input type="text" class="form-control" id="nickname" name="nickname" isValid="false">
          <button type="button" id="checkNicknameBtn" class="btn btn-outline-secondary focus-ring">중복 확인</button>
        </div>
        <p id="nicknameMessage"></p>
      </div>

      <div class="mb-3">
        <label class="form-label">생년월일</label>
        <input type="date" class="form-control" id="birth" name="birth" required>
      </div>

      <div class="mb-3">
        <label class="form-label">자기소개</label>
        <textarea class="form-control" id="introduce" name="introduce" rows="3"></textarea>
      </div>

      <button type="submit" id="registerBtn" class="btn btn-primary w-100">회원가입</button>

      <p id="errorMsg" class="error-msg text-center"></p>
    </form>
  </div>
</div>

<script>
  $("#registerForm").submit(function(event) {
    event.preventDefault(); // 기본 제출 동작 방지

    let isValid = true;
    let nicknameInput = $("#nickname");
    let checkNicknameBtn = $("#checkNicknameBtn");
    let nicknameIsValid = nicknameInput.attr("isValid") === "true";
    let userIdInput = $("#userId");
    let checkUserIdBtn = $("#checkUserIdBtn");
    let userIdIsValid = userIdInput.attr("isValid") === "true";
    let passwordInput = $("#password");
    let passwordIsValid = passwordInput.attr("isValid") === "true";

    // 아이디 중복 확인 체크
    if (!userIdIsValid) {
      console.log("아이디 중복확인 안됨을 확인")
      alert("아이디 중복을 확인 해주세요.");
      checkUserIdBtn.focus();
      isValid = false;
      return;
    }

    // 비밀번호 일치 확인
    if (passwordInput.val() !== $("#passwordCheck").val()) {
      $("#passwordMessage").text("비밀번호가 일치하지 않습니다.").css("color", "red");
      passwordInput.attr("isValid", "false");
    } else {
      $("#passwordMessage").text("비밀번호가 일치합니다!").css("color", "green");
      passwordInput.attr("isValid", "true");
    }

    // 닉네임 중복 확인 체크
    if (!nicknameIsValid) {
      console.log("닉네임 중복확인 안됨을 확인")
      alert("닉네임 중복을 확인 해주세요.");
      checkNicknameBtn.blur(); // 기존 포커스 해제
      setTimeout(() => {
        checkNicknameBtn.focus();
      }, 10); // 아주 짧은 시간 후 포커스 적용
      isValid = false;
      return;
    }

    // 모든 입력 필드에서 required 체크
    $("#registerForm input, #registerForm textarea").each(function() {
      if ($(this).prop("required") && $(this).val().trim() === "") {
        alert($(this).prev("label").text() + "을(를) 입력하세요.");
        $(this).focus();
        isValid = false;
        return false; // 반복문 중단
      }
    });

    if (!isValid) return;

    // 유효성 검사 통과 후 Ajax 요청 실행
    $.ajax({
      type: "POST",
      url: "${pageContext.request.contextPath}/user/register",
      contentType: "application/json",
      data: JSON.stringify({
        userId: $("#userId").val(),
        password: $("#password").val(),
        nickname: $("#nickname").val(),
        birth: $("#birth").val(),
        introduce: $("#introduce").val()
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
        alert("서버 통신 중 오류가 발생했습니다.");
      }
    });
  });
</script>
<script>
  $(document).ready(function() {
    // 닉네임 입력값이 변경되면 메시지 초기화
    $("#nickname").on("input", function() {
      $("#nicknameMessage").text(""); // 메시지 비우기
      $("#nickname").attr("isValid", "false"); // 유효성 초기화
    });

    $("#checkNicknameBtn").click(function() {
      let nickname = $("#nickname").val().trim();

      if (nickname === "") {
        $("#nicknameMessage").text("닉네임을 입력하세요.").css("color", "red");
        return;
      }

      // 닉네임 검증 Ajax 요청 (예제)
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
          $("#nicknameMessage").text("서버 오류가 발생했습니다.").css("color", "red");
        }
      });
    });
  });
</script>
<script>
  $(document).ready(function() {
    // 아이디 입력값이 변경되면 메시지 초기화
    $("#userId").on("input", function() {
      $("#userIdMessage").text(""); // 메시지 비우기
      $("#userId").attr("isValid", "false"); // 유효성 초기화
    });

    $("#checkUserIdBtn").click(function() {
      let userId = $("#userId").val().trim();

      if (userId === "") {
        $("#userIdMessage").text("아이디를 입력하세요.").css("color", "red");
        return;
      }

      // 닉네임 검증 Ajax 요청 (예제)
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
          $("#nicknameMessage").text("서버 오류가 발생했습니다.").css("color", "red");
        }
      });
    });
  });
</script>
<script>
  $(document).ready(function() {
    $("#password, #passwordCheck").on("input", function() {
      let password = $("#password").val();
      let passwordCheck = $("#passwordCheck").val();
      let messageElement = $("#passwordMessage");

      if (password !== passwordCheck) {
        messageElement.text("비밀번호가 일치하지 않습니다.").css("color", "red");
      } else {
        messageElement.text("비밀번호가 일치합니다!").css("color", "green");
        password.attr("isValid", "true")
      }
    });
  });
</script>
<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>

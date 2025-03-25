<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인 페이지</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- jQuery -->
    <script src="${pageContext.request.contextPath}/resources/js/jquery-3.6.0.js"></script>

    <style>
        body {
            background-color: #f8f9fa;
        }
        .container {
            max-width: 600px !important;
            width: 100%;
            margin: 100px auto !important;
        }
        .card {
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
    </style>

</head>
<body>
<div>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
</div>
<div class="container">
    <div class="card">
        <h2 class="text-center mb-4">로그인</h2>

        <form id="loginForm">
            <div class="mb-3">
                <label for="userId" class="form-label">아이디</label>
                <input type="text" class="form-control" id="userId" name="userId" required>
            </div>

            <div class="mb-3">
                <label for="password" class="form-label">비밀번호</label>
                <input type="password" class="form-control" id="password" name="password" required>
            </div>

            <div class="text-danger text-center mb-3" id="errorMsg"></div>

            <button type="button" id="loginBtn" class="btn btn-primary w-100">로그인</button>
        </form>

        <p class="text-center mt-3">
            <a href="${pageContext.request.contextPath}/user/register" class="text-decoration-none">회원가입</a>
        </p>
    </div>
</div>

<!-- jQuery AJAX 처리 -->
<script>
    $(document).ready(function(){
        $("#loginBtn").click(function(){
            $.ajax({
                type: "POST",
                url: "${pageContext.request.contextPath}/login",
                contentType: "application/json",
                dataType: "json",
                data: JSON.stringify({
                    userId: $("#userId").val(),
                    password: $("#password").val()
                }),
                success: function(res){
                    if(res.status === "success"){
                        location.href = "${pageContext.request.contextPath}/";
                    } else {
                        $("#errorMsg").text(res.message);
                    }
                },
                error: function(){
                    $("#errorMsg").text("서버 통신 중 오류가 발생했습니다.");
                }
            });
        });

        // Enter 키로 로그인 가능하게
        $("#userId, #password").keyup(function(event) {
            if(event.keyCode === 13){
                $("#loginBtn").click();
            }
        });
    });
</script>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>

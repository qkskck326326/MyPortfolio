<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>회원가입</title>
  <script src="<c:url value='/resources/js/jquery-3.6.0.js'/>"></script>
</head>
<body>

<h2>회원가입</h2>

<form id="registerForm">

  <label>아이디:</label>
  <input type="text" id="userId" name="userId" required/><br/>

  <label>비밀번호:</label>
  <input type="password" id="password" name="password" required/><br/>

  <label>닉네임:</label>
  <input type="text" id="nickname" name="nickname" required/><br/>

  <label>생년월일:</label>
  <input type="date" id="birth" name="birth" required/><br/>

  <label>자기소개:</label>
  <textarea id="introduce" name="introduce"></textarea><br/>

  <button type="button" id="registerBtn">회원가입</button>

</form>

<script src="${pageContext.request.contextPath}/resources/js/jquery-3.6.0.js"></script>
<script>
  $(document).ready(function(){
    $("#registerBtn").click(function(){
      $.ajax({
        type: "POST",
        url: "${pageContext.request.contextPath}/register",
        contentType: "application/json",
        data: JSON.stringify({
          userId: $("#userId").val(),
          password: $("#password").val(),
          nickname: $("#nickname").val(),
          birth: $("#birth").val(),
          introduce: $("#introduce").val()
        }),
        success: function(res){
          if(res.status === "success"){
            location.href = "${pageContext.request.contextPath}/user/" + res.id;
          } else {
            alert(res.message);
          }
        },
        error: function(){
          alert("서버 통신 중 오류가 발생했습니다.");
        }
      });
    });

    // Enter 키로 회원가입 가능하게
    $("#registerForm input, #introduce").keyup(function(event) {
      if(event.keyCode === 13){
        $("#registerBtn").click();
      }
    });
  });
</script>

  </form>

  </body>
  </html>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>헤더바</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background-color: #f8f9fa;
        }
        .header-bar {
            background-color: #fff;
            padding: 10px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 2px solid #e0e0e0;
        }
        .logo {
            width: 60px;
            height: 60px;
            background-color: #ccc;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
            font-size: 14px;
            font-weight: bold;
        }
        .menu-right {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .search-box {
            padding: 5px 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .image-btn {
            width: 60px;
            height: 40px;
            background-color: #ccc;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
            font-size: 14px;
            font-weight: bold;
        }
        .login-btn {
            padding: 8px 20px;
            background-color: #ddd;
            border: none;
            border-radius: 20px;
        }
    </style>
</head>
<body>

<div class="container-fluid">
    <div class="header-bar">
        <!-- 좌측 로고 -->
        <div class="logo">
            image<br>로고
        </div>

        <!-- 우측 메뉴 -->
        <div class="menu-right">
            <!-- 드롭다운 -->
            <div class="dropdown">
                <button class="btn btn-light dropdown-toggle" type="button" data-bs-toggle="dropdown">
                    드롭박스 ▼
                </button>
                <ul class="dropdown-menu">
                    <li><a class="dropdown-item" href="#">인기순</a></li>
                    <li><a class="dropdown-item" href="#">최신순</a></li>
                </ul>
            </div>

            <!-- 검색 입력창 -->
            <input type="text" class="search-box" placeholder="검색어 입력">

            <!-- 이미지 업로드 버튼 -->
            <div class="image-btn">image<br>업로드</div>

            <!-- 로그인 버튼 -->
            <button class="login-btn">로그인</button>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>

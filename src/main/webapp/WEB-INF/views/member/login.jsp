<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 - Instagram</title>
<c:import url="/WEB-INF/views/temp/head_css.jsp"></c:import>
<style>
    /* 로그인 전용 독립 페이지 스타일 */
    body {
        background-color: #fafafa !important;
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
        margin: 0;
    }
    
    /* 기존 레이아웃 숨김 (로그인 화면만 돋보이게) */
    #wrapper, #content-wrapper, #content {
        width: 100%;
        height: 100%;
        background-color: transparent !important;
    }
    #accordionSidebar, nav.topbar, footer.sticky-footer {
        display: none !important; /* 로그인 창에서는 사이드바, 탑바 숨김 */
    }
    .container-fluid {
        padding: 0;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        height: 100vh;
    }

    /* 인스타그램 로그인 박스 스타일 */
    .login-container {
        width: 350px;
        display: flex;
        flex-direction: column;
        align-items: center;
        margin-top: -50px; /* 약간 위로 올려서 중앙 정렬 비율 맞춤 */
    }
    
    .login-box {
        width: 100%;
        background-color: #fff;
        border: 1px solid #dbdbdb;
        border-radius: 1px;
        padding: 40px;
        margin-bottom: 10px;
        text-align: center;
    }
    
    .login-logo {
        font-family: 'cursive', sans-serif;
        font-size: 40px;
        font-weight: bold;
        color: #262626;
        margin-bottom: 35px;
    }
    
    .login-form {
        width: 100%;
        display: flex;
        flex-direction: column;
    }
    
    .login-input {
        background-color: #fafafa;
        border: 1px solid #dbdbdb;
        border-radius: 3px;
        padding: 9px 8px;
        font-size: 12px;
        width: 100%;
        margin-bottom: 6px;
        outline: none;
    }
    .login-input:focus {
        border-color: #a8a8a8;
    }
    
    .login-btn {
        background-color: #0095f6;
        color: #fff;
        border: none;
        border-radius: 4px;
        padding: 7px 16px;
        font-size: 14px;
        font-weight: 600;
        margin-top: 8px;
        cursor: pointer;
    }
    .login-btn:hover {
        background-color: #1877f2;
    }
    
    .divider {
        display: flex;
        align-items: center;
        margin: 18px 0;
    }
    .divider-line {
        flex-grow: 1;
        height: 1px;
        background-color: #dbdbdb;
    }
    .divider-text {
        margin: 0 18px;
        color: #8e8e8e;
        font-size: 13px;
        font-weight: 600;
    }
    
    .checkbox-group {
        display: flex;
        justify-content: space-between;
        margin-top: 15px;
        font-size: 12px;
        color: #262626;
    }
    .checkbox-group label {
        margin: 0;
        cursor: pointer;
        display: flex;
        align-items: center;
    }
    .checkbox-group input {
        margin-right: 4px;
    }
    
    /* 오류 메시지 */
    .error-msg {
        color: #ed4956;
        font-size: 14px;
        margin-bottom: 15px;
    }
    
    /* 하단 가입 박스 */
    .signup-box {
        width: 100%;
        background-color: #fff;
        border: 1px solid #dbdbdb;
        border-radius: 1px;
        padding: 20px;
        text-align: center;
        font-size: 14px;
        color: #262626;
    }
    .signup-box a {
        color: #0095f6;
        font-weight: 600;
        text-decoration: none;
    }
</style>
</head>

<body id="page-top">
	<div id="wrapper">
		<c:import url="/WEB-INF/views/temp/sidebar.jsp"></c:import>
		
		<div id="content-wrapper" class="d-flex flex-column">
		
			<div id="content">
			
				<c:import url="/WEB-INF/views/temp/topbar.jsp"></c:import>
					
				<!-- Begin Page Content -->
				<div class="container-fluid">

                    <div class="login-container">
                        <div class="login-box">
                            <div class="login-logo">Instagram</div>
                            
                            <c:if test="${not empty param.message}">
                                <div class="error-msg">${param.message}</div>
                            </c:if>
                            
                            <form action="./login" method="post" enctype="multipart/form-data" class="login-form">
                                <input type="text" name="username" value="${cookie.rememberId.value}" class="login-input" placeholder="전화번호, 사용자 이름 또는 이메일" required />
                                <input type="password" name="password" class="login-input" placeholder="비밀번호" required />
                                
                                <button type="submit" class="login-btn">로그인</button>
                                
                                <div class="divider">
                                    <div class="divider-line"></div>
                                    <div class="divider-text">또는</div>
                                    <div class="divider-line"></div>
                                </div>
                                
                                <div class="checkbox-group">
                                    <label>
                                        <input type="checkbox" name="rememberId" value="1" ${not empty cookie.rememberId.value ? 'checked' : ''}> ID 저장
                                    </label>
                                    <label>
                                        <input type="checkbox" name="rememberMe" value="true"> 자동 로그인
                                    </label>
                                </div>
                            </form>
                        </div>
                        
                        <div class="signup-box">
                            계정이 없으신가요? <a href="/member/join">가입하기</a>
                        </div>
                    </div>

                </div>
                <!-- End Page container-fluid -->
			</div>
			<!-- End page Content -->
			<c:import url="/WEB-INF/views/temp/footer.jsp"></c:import>
		</div>
		<!-- End content-wrapper -->
	</div>
	<!-- End wrapper -->
	<c:import url="/WEB-INF/views/temp/footer_script.jsp"></c:import>
</body>
</html>
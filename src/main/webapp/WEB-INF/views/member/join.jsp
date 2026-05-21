<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>가입하기 - Instagram</title>
<c:import url="/WEB-INF/views/temp/head_css.jsp"></c:import>
<style>
    /* 가입 전용 독립 페이지 스타일 */
    body {
        background-color: #fafafa !important;
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
        margin: 0;
    }
    
    /* 기존 레이아웃 숨김 (로그인/가입 화면만 돋보이게) */
    #wrapper, #content-wrapper, #content {
        width: 100%;
        height: 100%;
        background-color: transparent !important;
    }
    #accordionSidebar, nav.topbar, footer.sticky-footer {
        display: none !important;
    }
    .container-fluid {
        padding: 0;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
        padding-top: 30px;
        padding-bottom: 30px;
    }

    /* 인스타그램 가입 박스 스타일 */
    .join-container {
        width: 350px;
        display: flex;
        flex-direction: column;
        align-items: center;
    }
    
    .join-box {
        width: 100%;
        background-color: #fff;
        border: 1px solid #dbdbdb;
        border-radius: 1px;
        padding: 40px;
        margin-bottom: 10px;
        text-align: center;
    }
    
    .join-logo {
        font-family: 'cursive', sans-serif;
        font-size: 40px;
        font-weight: bold;
        color: #262626;
        margin-bottom: 15px;
    }
    
    .join-subtitle {
        color: #8e8e8e;
        font-size: 16px;
        font-weight: 600;
        line-height: 20px;
        margin-bottom: 20px;
    }
    
    .join-form {
        width: 100%;
        display: flex;
        flex-direction: column;
    }
    
    .join-input {
        background-color: #fafafa;
        border: 1px solid #dbdbdb;
        border-radius: 3px;
        padding: 9px 8px;
        font-size: 12px;
        width: 100%;
        margin-bottom: 6px;
        outline: none;
        box-sizing: border-box;
    }
    .join-input:focus {
        border-color: #a8a8a8;
    }
    
    /* Spring form:errors 스타일용 */
    span[id$=".errors"] {
        color: #ed4956;
        font-size: 11px;
        margin-bottom: 8px;
        display: block;
        text-align: left;
    }
    
    .join-btn {
        background-color: #0095f6;
        color: #fff;
        border: none;
        border-radius: 4px;
        padding: 7px 16px;
        font-size: 14px;
        font-weight: 600;
        margin-top: 15px;
        cursor: pointer;
    }
    .join-btn:hover {
        background-color: #1877f2;
    }
    
    .terms-box {
        text-align: left;
        font-size: 12px;
        color: #8e8e8e;
        margin-top: 10px;
        margin-bottom: 5px;
        border: 1px solid #efefef;
        padding: 10px;
        border-radius: 4px;
        background-color: #fafafa;
    }
    .terms-box label {
        display: flex;
        align-items: center;
        margin-bottom: 5px;
        cursor: pointer;
    }
    .terms-box label:last-child {
        margin-bottom: 0;
    }
    .terms-box input[type="checkbox"] {
        margin-right: 6px;
    }
    .terms-main {
        font-weight: bold;
        color: #262626;
        margin-bottom: 8px !important;
        border-bottom: 1px solid #dbdbdb;
        padding-bottom: 5px;
    }
    
    .file-input-wrapper {
        text-align: left;
        margin-top: 5px;
        margin-bottom: 5px;
    }
    .file-input-wrapper label {
        font-size: 12px;
        color: #8e8e8e;
        margin-bottom: 4px;
        display: block;
    }
    .file-input-wrapper input[type="file"] {
        font-size: 11px;
        padding: 6px;
        background: #fff;
    }
    
    /* 하단 로그인 박스 */
    .login-link-box {
        width: 100%;
        background-color: #fff;
        border: 1px solid #dbdbdb;
        border-radius: 1px;
        padding: 20px;
        text-align: center;
        font-size: 14px;
        color: #262626;
    }
    .login-link-box a {
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

                    <div class="join-container">
                        <div class="join-box">
                            <div class="join-logo">Instagram</div>
                            <div class="join-subtitle">친구들의 사진과 동영상을 보려면 가입하세요.</div>
                            
                            <form:form method="post" modelAttribute="memberDTO" enctype="multipart/form-data" cssClass="join-form">
                                
                                <form:input path="userId" cssClass="join-input" id="userId" placeholder="아이디"/>
                                <form:errors path="userId"></form:errors>
                                
                                <form:password path="userPw" cssClass="join-input" id="userPw" placeholder="비밀번호"/>
                                <form:errors path="userPw"></form:errors>
                                
                                <form:password path="userPwCheck" cssClass="join-input" id="userPwCheck" placeholder="비밀번호 확인"/>
                                <form:errors path="userPwCheck"></form:errors>
                                
                                <form:input path="userNickname" cssClass="join-input" id="userNickname" placeholder="성명 (닉네임)"/>
                                <form:errors path="userNickname"></form:errors>
                                
                                <form:input path="userEmail" cssClass="join-input" id="userEmail" placeholder="이메일 주소"/>
                                <form:errors path="userEmail"></form:errors>
                                
                                <input type="date" name="userBirth" class="join-input" id="userBirth" title="생년월일">
                                <form:errors path="userBirth"></form:errors>
                                
                                <div class="file-input-wrapper">
                                    <label>프로필 사진 첨부</label>
                                    <input type="file" name="attach" class="join-input">
                                </div>
                                
                                <div class="terms-box">
                                    <label class="terms-main">
                                        <input type="checkbox" id="userAgr"> 전체 이용동의
                                    </label>
                                    <form:errors path="userAgr"></form:errors>
                                    
                                    <label> 
                                        <input type="checkbox" class="ch" name="agreement1"> 이용약관 동의
                                    </label>
                                    <label> 
                                        <input type="checkbox" class="ch" name="agreement2"> 개인정보 수집 동의
                                    </label>
                                    <label> 
                                        <input type="checkbox" class="ch" name="agreement3"> 마케팅 정보 수신 동의
                                    </label>
                                </div>
                                
                                <button type="submit" class="join-btn" id="btn">가입</button>
                                
                            </form:form>
                        </div>
                        
                        <div class="login-link-box">
                            계정이 있으신가요? <a href="/member/login">로그인</a>
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
	<script src="/js/member/join.js"></script>
</body>
</html>
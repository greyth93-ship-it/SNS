<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Chat Room</title>
<c:import url="/WEB-INF/views/temp/head_css.jsp"></c:import>
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<style>
	/* 인스타그램 DM 상세 (채팅방) 스타일 커스텀 */
	body {
		background-color: #fafafa !important;
	}
	.container-fluid.dm-fluid {
		padding: 20px !important;
		display: flex;
		justify-content: center;
		align-items: center;
		height: calc(100vh - 0px);
		background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
	}
	
	.chat-container {
		width: 100%;
		max-width: 600px;
		background-color: #fff;
		border: 1px solid #dbdbdb;
		border-radius: 8px;
		display: flex;
		flex-direction: column;
		height: calc(100vh - 110px);
		max-height: 760px;
		gap: 0;
		overflow: hidden;
	}
	.chat-container:hover {
		box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
	}
	
	/* 헤더 */
	.chat-header {
		display: flex;
		align-items: center;
		padding: 20px;
		background-color: #fff;
		z-index: 10;
		border-radius: 8px 8px 0 0;
		box-sizing: border-box;
		width: 100%;
		border-bottom: 1px solid #dbdbdb;
	}
	.chat-header:hover {
		background-color: #fff;
	}
	.chat-header-back {
		font-size: 20px;
		color: #262626;
		margin-right: 15px;
		cursor: pointer;
		text-decoration: none;
		transition: color 0.2s ease;
	}
	.chat-header-back:hover {
		color: #0095f6;
	}
	.chat-header-profile {
		display: flex;
		align-items: center;
		flex-grow: 1;
		background: transparent;
		padding: 0;
		border-radius: 0;
		margin: 0 15px;
	}
	.chat-header-profile img {
		width: 40px;
		height: 40px;
		border-radius: 50%;
		object-fit: cover;
		margin-right: 12px;
		border: 3px solid #fff;
		box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
	}
	.chat-header-profile .user_nickname {
		font-weight: 600;
		font-size: 16px;
		color: #262626;
		text-shadow: none;
	}
	.chat-header-info {
		font-size: 22px;
		color: #262626;
		cursor: pointer;
		transition: color 0.2s ease;
	}
	.chat-header-info:hover {
		color: #0095f6;
	}
	
	/* 채팅 메시지 영역 */
	.chat-messages {
		flex-grow: 1;
		padding: 20px;
		overflow-y: auto;
		display: flex;
		flex-direction: column;
		background-color: #fff;
		width: 100%;
		min-height: 0;
		border-radius: 0;
		box-sizing: border-box;
		border-bottom: 1px solid #dbdbdb;
	}
	.message {
		display: flex;
		margin-bottom: 15px;
		align-items: flex-end;
		width: 100%;
		animation: slideIn 0.3s ease-out;
	}
	@keyframes slideIn {
		from {
			opacity: 0;
			transform: translateY(10px);
		}
		to {
			opacity: 1;
			transform: translateY(0);
		}
	}
	.other-msg {
		flex-direction: row;
	}
	.my-msg {
		flex-direction: row-reverse;
	}
	
	/* 상대방 프로필 */
	.other-msg .msg-profile-wrap {
		display: flex;
		flex-direction: column;
		align-items: center;
		margin-right: 10px;
	}
	.other-msg .msg-profile-wrap img {
		width: 28px;
		height: 28px;
		border-radius: 50%;
		border: 1px solid #efefef;
	}
	.other-msg .msg-nickname {
		display: none; /* DM은 1:1이므로 이름 생략 (인스타 스타일) */
	}
	
	/* 말풍선 */
	.msg-box {
		max-width: 70%;
		display: flex;
		flex-direction: column;
	}
	.my-msg .msg-box {
		align-items: flex-end;
	}
	.other-msg .msg-box {
		align-items: flex-start;
	}
	.msg-content {
		padding: 12px 16px;
		border-radius: 18px;
		font-size: 14px;
		line-height: 1.5;
		word-break: break-word;
		box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
		transition: transform 0.2s ease;
	}
	.msg-content:hover {
		transform: translateY(-2px);
	}
	.other-msg .msg-content {
		background: linear-gradient(135deg, #f0f0f0 0%, #e8e8e8 100%);
		color: #262626;
		border-bottom-left-radius: 4px;
	}
	.my-msg .msg-content {
		background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
		color: #fff;
		border-bottom-right-radius: 4px;
	}
	.msg-info {
		font-size: 11px;
		color: #999;
		margin-top: 6px;
		padding: 0 4px;
		font-weight: 500;
	}
	
	/* 입력 영역 */
	
	
	.input-group {
		display: flex;
		align-items: center;
		border: 1px solid #dbdbdb;
		border-radius: 22px;
		padding: 8px 14px;
		background-color: #fff;
		transition: all 0.3s ease;
	}
	.input-group:focus-within {
		border-color: #c8c8c8;
		background-color: #fff;
		box-shadow: 0 0 0 3px rgba(0, 0, 0, 0.04);
	}
	.input-icon {
		font-size: 24px;
		color: #8e8e8e;
		margin-right: 12px;
		cursor: pointer;
		transition: color 0.2s ease;
	}
	.input-icon:hover {
		color: #262626;
	}
	#messageContent {
		flex-grow: 1;
		border: none;
		outline: none;
		padding: 8px 0;
		font-size: 14px;
		background: transparent;
		color: #262626;
	}
	#messageContent::placeholder {
		color: #999;
	}
	.input-group button {
		background: none;
		border: none;
		color: #0095f6;
		font-weight: 600;
		font-size: 14px;
		cursor: pointer;
		padding: 0 10px;
		border-radius: 0;
		transition: color 0.2s ease;
	}
	.input-group button:hover {
		color: #00376b;
	}
	.input-group button:active {
		transform: none;
	}
</style>
</head>

<body id="page-top">
	<div id="wrapper">
		<c:import url="/WEB-INF/views/temp/sidebar.jsp"></c:import>
		
		<div id="content-wrapper" class="d-flex flex-column">
			<div id="content">
				<c:import url="/WEB-INF/views/temp/topbar.jsp"></c:import>
					
				<div class="container-fluid dm-fluid">
					<sec:authentication property="principal.userNo" var="loginUserNo" />
					
					<div class="chat-container">
						<!-- 헤더 -->
						<div class="chat-header">
							<a href="/chat/list" class="chat-header-back"><i class="fas fa-arrow-left"></i></a>
							<div class="chat-header-profile">
								<img src="${not empty targetProfile ? '/files/member/'.concat(targetProfile) : '/img/default_user.avif'}" 
									 onerror="this.src='/img/default_user.avif'" alt="profile">
								<span class="user_nickname">${you}</span>
							</div>
							<i class="fas fa-info-circle chat-header-info"></i>
						</div>
		     
						<!-- 채팅 내역 표시 -->
						<div class="chat-messages" id="messageArea"></div>

						<!-- 입력 창 -->
							<form action="/chat/create" method="post" id="chatForm" data-room-no="${room.roomNo}">
								<div class="input-group">
									<c:forEach var="m" items="${room.members}">
										<c:if test="${m.userNo != loginUserNo}">
											<input type="hidden" id="targetUserNo" name="targetUserNo" value="${m.userNo}">
										</c:if>
									</c:forEach>
									
									<i class="far fa-smile input-icon"></i> <!-- 인스타식 감정표현 아이콘 추가 -->
									<input type="text" id="messageContent" name="messageContent"
										placeholder="메시지 입력..." required autocomplete="off">
									<button type="submit">보내기</button>
								</div>
							</form>
						</div>
					</div>

				</div>
			</div>
		</div>
	</div>
	<c:import url="/WEB-INF/views/temp/footer_script.jsp"></c:import>
	
	<script>
		const MY_USER_NO = ${loginUserNo};
		const TARGET_NICKNAME = "${you}";
		// profileDTO가 존재할 때 파일명을 전달하기 위함 (에러 방지용 분기 처리 필요 시 보완)
		const TARGET_PROFILE = "${targetProfile}";
	</script>
	<script src="/js/chat/detail.js"></script> 
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<c:import url="/WEB-INF/views/temp/head_css.jsp"></c:import>
</head>

<body id="page-top">
	<div id="wrapper">
		<c:import url="/WEB-INF/views/temp/sidebar.jsp"></c:import>
		
		<div id="content-wrapper" class="d-flex flex-column">
		
			<div id="content">
			
				<c:import url="/WEB-INF/views/temp/topbar.jsp"></c:import>
					
				<!-- Begin Page Content -->
				<div class="container-fluid">

	                   <!-- Page Heading -->
	                 <sec:authentication property="principal.userNo" var="myUserNo" />
	                <div>
	                <span class="user_nickname">${you}</span>
	                </div>
	     

					<div class="chat-messages" id="messageArea">
						<c:forEach var="msg" items="${room.messages}">
							<c:set var="isMe" value="${msg.userNo eq myUserNo}"></c:set>
							<div class="message ${isMe ? 'my-msg' : 'other-msg'}">
				
							<c:if test="${!isMe}">
								<div class="msg-profile-wrap">
									<img class="img-profile rounded-circle" src="/files/member/${member.profileDTO.fileName}">
									<span class="msg-nickname">${you}</span>
								</div>
							
							</c:if>
							
								<div class="msg-box">
									<div class="msg-content">${msg.messageContent}</div>
									
									<div class="msg-info">
									<c:choose>
										<c:when test="${not empty msg.messageDate}">
										${fn:substring(msg.messageDate, 11, 16)}
										</c:when>
										<c:otherwise>
											
										</c:otherwise>
									</c:choose>
										
									</div>
								
								</div>
							</div>
						</c:forEach>
					</div>

					<!-- 메시지 입력 영역 -->
					<div class="chat-input-area">
						<!-- 컨트롤러 @PostMapping("chat")에 맞춘 action 설정 -->
						<!-- roomNo는 @PathVariable로 들어가므로 URL 끝에 붙여줌 -->
						<form action="/chat/create" method="post" id="chatForm" onsubmit="sendMessage(event)" data-room-no="${room.roomNo}" >
							<div class="input-group">
								<!-- 상대방 번호 전송 (@RequestParam("targetUserNo") 대응) -->
								<!-- room.members에서 나를 제외한 번호를 찾아 hidden으로 넣음 -->
								<c:forEach var="m" items="${room.members}">
									<c:if test="${m.userNo != myUserNo}">
										<input type="hidden" id="targetUserNo" name="targetUserNo" value="${m.userNo}">
									</c:if>
								</c:forEach>

								<input type="text" id="messageContent" name="messageContent"
									placeholder="메시지를 입력하세요..." required autocomplete="off">
								<button type="submit">전송</button>
							</div>
						</form>
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
	<script src="/js/chat/detail.js"></script> 
	
</body>
</html>
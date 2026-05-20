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
</head>

<body id="page-top">
	<div id="wrapper">
		<c:import url="/WEB-INF/views/temp/sidebar.jsp"></c:import>
		
		<div id="content-wrapper" class="d-flex flex-column">
			<div id="content">
				<c:import url="/WEB-INF/views/temp/topbar.jsp"></c:import>
					
				<div class="container-fluid">
	                 <sec:authentication property="principal.userNo" var="loginUserNo" />
	                <div>
	                    <span class="user_nickname">${you}와 대화</span>
	                </div>
	     
	                <div class="chat-messages" id="messageArea"></div>

					<div class="chat-input-area">
						<form action="/chat/create" method="post" id="chatForm" data-room-no="${room.roomNo}">
							<div class="input-group">
								<c:forEach var="m" items="${room.members}">
									<c:if test="${m.userNo != loginUserNo}">
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
			</div>
			<c:import url="/WEB-INF/views/temp/footer.jsp"></c:import>
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
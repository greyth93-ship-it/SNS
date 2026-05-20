<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
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
	                   <h1 class="h3 mb-4 text-gray-800">${member.userNickname}의 마이페이지</h1>
	                
	                <div class="mb-4">
	                	<!-- 프로필 이미지가 없을 때를 대비한 기본 이미지 처리 예시 -->
	                	<c:choose>
	                		<c:when test="${not empty member.profileDTO.fileName}">
								<img class="img-profile rounded-circle" src="/files/member/${member.profileDTO.fileName}" style="width: 80px; height: 80px; object-fit: cover;"> 
	                		</c:when>
	                		
	                	</c:choose>
						<h6 class="mt-2">게시물 <span class="badge bg-secondary">${pager.totalCount}</span></h6> 
						<h6>팔로워 <a href="../follow/follower">팔로 </a></h6> 
						<h6>팔로잉</h6>
					</div>
	                   
	                <!-- 2. 내 페이지인가? 상대방 페이지인가? 에 따른 버튼 분기 처리 -->
	                <c:choose>
	                	<c:when test="${isMine}">
	                		<!-- [내 마이페이지 일 때] -->
			                <div class="d-flex justify-content-between gap-2 mb-2">
								<button type="button" class="btn btn-outline-primary w-100 py-2 fw-bold"
									onclick="location.href='/member/profile'">
									프로필 편집
								</button>
							</div>
							
			               	<div class="d-flex justify-content-between gap-2 mb-4">
								<button type="button" class="btn btn-primary w-100 py-2 fw-bold"
									onclick="location.href='/post/create'">
									<i class="fas fa-plus-circle me-2"></i>포스트 만들기
								</button>
							</div>
	                	</c:when>
	                	<c:otherwise>
	                		<!-- [상대방 마이페이지 일 때] 로그인한 상태일 때만 팔로우 가능 -->
	                		<sec:authorize access="isAuthenticated()">
				                <div class="d-flex justify-content-between gap-2 mb-4">
	
									<c:if test="${!isMine}">
									    <button type="button"
									            class="btn btn-primary"
									            onclick="followUser('${targetUserNo}')">
									        팔로우
									    </button>
									</c:if>
									<button type="button" class="btn btn-outline-secondary w-50 py-2 fw-bold" onclick="startChat(${member.userNo})">
										메시지 보내기
									</button>
								</div>
	                		</sec:authorize>
	                	</c:otherwise>
	                </c:choose>
						
					<!-- 3. 게시물 리스트 영역 -->
					<div>
						<label class="fw-bold">올린 게시물</label>
						<!-- 상대방 글 목록 전체보기를 위해 userNo 파라미터 유지 -->
						<button class="btn btn-sm btn-light ms-2" onclick="location.href='/member/myposts?userNo=${member.userNo}'">모두보기</button>
						
						<div class="post-summary-list mt-3">
							<c:choose>
								<c:when test="${not empty myposts}">
									<ul class="list-group">
										<c:forEach var="post" items="${myposts}">
											<li class="list-group-item">
												<a href="/post/detail?feedNo=${post.feedNo}"> <!-- 일반적인 포스트 상세페이지 경로로 수정 추천 -->
														게시글 번호: ${post.feedNo}
												</a>
											</li>
										</c:forEach>
									</ul>
								</c:when>
								<c:otherwise>
									<p class="text-muted">작성한 게시물이 없습니다.</p>
								</c:otherwise>
							</c:choose>
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
	<script src="/js/member/follow.js"></script>
	
	
</body>
</html>












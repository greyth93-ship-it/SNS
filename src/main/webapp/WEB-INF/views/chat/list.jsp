<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>채팅 가능 목록</title>
<c:import url="/WEB-INF/views/temp/head_css.jsp"></c:import>
<link rel="stylesheet" type="text/css" href="/css/feed-search.css">
<style>
/* 아바타 원형 유지 및 버튼 스타일 조정 */
.user-avatar-wrapper {
	width: 64px;
	height: 64px;
	border-radius: 50%;
	overflow: hidden;
	flex: 0 0 64px
}

.user-avatar-wrapper img {
	width: 100%;
	height: 100%;
	object-fit: cover;
	display: block
}

.pagination {
	justify-content: center;
	margin-top: 18px
}

.user-actions {
	width: 100%;
}

.user-actions .btn-chat-trigger {
	width: 100%;
	display: block;
}
</style>
</head>

<body class="search-page">
	<div id="wrapper">
		<c:import url="/WEB-INF/views/temp/sidebar.jsp"></c:import>
		<div id="content-wrapper" class="d-flex flex-column">
			<div id="content">
				<c:import url="/WEB-INF/views/temp/topbar.jsp"></c:import>
				<div class="container-fluid search-shell">
					<div class="row justify-content-center">
						<div class="col-lg-10">
							<div class="search-hero">
								<div class="search-title">채팅 가능 목록</div>
								<div class="search-sub">서로 맞팔로우되어 채팅을 시작할 수 있는 유저입니다.</div>
							</div>

							<c:choose>
								<c:when test="${not empty matchedList}">
									<div class="user-grid">
										<c:forEach items="${matchedList}" var="u">
											<div class="user-card">
												<!-- 상대방 마이페이지 링크 -->
												<a href="/chat/create?targetUserNo=${u.memberDTO.userNo}" class="user-card-link">
													<div class="user-avatar-wrapper">
														<img src="${(not empty u.memberDTO.profileDTO and not empty u.memberDTO.profileDTO.fileName) ? '/files/member/'.concat(u.memberDTO.profileDTO.fileName) : '/img/default_user.avif'}" 
         onerror="this.src='/img/default_user.avif'" 
         alt="profile">
													</div>
													<div class="user-info">
														<div class="user_nickname">${u.memberDTO.userNickname}</div>
														<div class="user_no">@${u.memberDTO.userNo}</div>
													</div>
												</a>
												<!-- 맞팔이 검증된 사용자들이므로 무조건 채팅방 생성 버튼 노출 -->
												
											</div>
										</c:forEach>
									</div>
								</c:when>
								<c:otherwise>
									<div class="search-empty">채팅 가능한 사용자가 없습니다.</div>
								</c:otherwise>
							</c:choose>

							<!-- 💡 페이징 네비게이션을 col-lg-10 내부 그리드 안쪽으로 안전하게 재배치 -->
							<nav aria-label="Page navigation example">
								<ul class="pagination">
									<li class="page-item ${pager.pre ? '' : 'disabled'}"><a
										class="page-link"
										href="/chat/list?page=${pager.pre ? pager.start-1 : pager.start}"
										aria-label="Previous"> <span aria-hidden="true">&laquo;</span>
									</a></li>

									<c:forEach begin="${pager.start}" end="${pager.end}" var="i">
										<li class="page-item ${pager.page == i ? 'active' : ''}">
											<a class="page-link" href="/chat/list?page=${i}">${i}</a>
										</li>
									</c:forEach>

									<li class="page-item ${pager.next ? '' : 'disabled'}"><a
										class="page-link"
										href="/chat/list?page=${pager.next ? pager.end+1 : pager.end}"
										aria-label="Next"> <span aria-hidden="true">&raquo;</span>
									</a></li>
								</ul>
							</nav>

						</div>
						<!-- col-lg-10 닫기 -->
					</div>
					<!-- row 닫기 -->
				</div>
				<!-- container-fluid 닫기 -->
			</div>
			<!-- content 닫기 -->
		</div>
		<!-- content-wrapper 닫기 -->
	</div>
	<!-- wrapper 닫기 -->

	<c:import url="/WEB-INF/views/temp/footer_script.jsp"></c:import>
</body>
</html>
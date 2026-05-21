<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>채팅 가능 목록</title>
<c:import url="/WEB-INF/views/temp/head_css.jsp"></c:import>
<style>
	/* 인스타그램 DM 리스트 스타일 커스텀 */
	body {
		background-color: #fafafa !important;
	}
	.container-fluid.dm-fluid {
		padding: 0 !important;
		height: calc(100vh - 70px); /* Topbar 높이를 뺀 나머지 꽉 채우기 */
	}
	.dm-container {
		width: 350px;
		height: 100%;
		background-color: #fff;
		border-right: 1px solid #dbdbdb;
		margin: 0;
		padding: 0;
		border-radius: 0;
		overflow-y: auto;
	}
	.dm-header {
		display: flex;
		justify-content: center;
		align-items: center;
		padding: 15px 20px;
		border-bottom: 1px solid #dbdbdb;
		position: relative;
		position: sticky;
		top: 0;
		background: #fff;
		z-index: 10;
	}
	.dm-header-title {
		font-weight: 600;
		font-size: 16px;
		color: #262626;
	}
	.dm-header-icon {
		position: absolute;
		right: 20px;
		font-size: 20px;
		cursor: pointer;
		color: #262626;
	}
	
	.dm-list {
		display: flex;
		flex-direction: column;
	}
	.dm-item {
		display: flex;
		align-items: center;
		padding: 12px 20px;
		text-decoration: none !important;
		color: inherit;
		transition: background-color 0.2s;
	}
	.dm-item:hover {
		background-color: #fafafa;
	}
	.dm-avatar {
		width: 56px;
		height: 56px;
		border-radius: 50%;
		overflow: hidden;
		flex-shrink: 0;
	}
	.dm-avatar img {
		width: 100%;
		height: 100%;
		object-fit: cover;
	}
	.dm-info {
		margin-left: 15px;
		flex-grow: 1;
		display: flex;
		flex-direction: column;
		justify-content: center;
	}
	.dm-nickname {
		font-size: 14px;
		font-weight: 600;
		color: #262626;
	}
	.dm-camera {
		font-size: 20px;
		color: #262626;
		opacity: 0.3;
	}
	.dm-item:hover .dm-camera {
		opacity: 0.8;
	}
	.search-empty {
		text-align: center;
		padding: 40px;
		color: #8e8e8e;
		font-size: 14px;
	}
	.pagination {
		justify-content: center;
		padding: 20px 0;
		margin: 0;
	}
</style>
</head>

<body>
	<div id="wrapper">
		<c:import url="/WEB-INF/views/temp/sidebar.jsp"></c:import>
		<div id="content-wrapper" class="d-flex flex-column">
			<div id="content">
				<c:import url="/WEB-INF/views/temp/topbar.jsp"></c:import>
				
				<div class="container-fluid dm-fluid">
					<div class="dm-container">
						<!-- DM 헤더 영역 -->
						<div class="dm-header">
							<div class="dm-header-title">메시지 가능 사용자</div>
							<i class="far fa-edit dm-header-icon"></i>
						</div>

						<!-- 유저 리스트 영역 -->
						<c:choose>
							<c:when test="${not empty matchedList}">
								<div class="dm-list">
									<c:forEach items="${matchedList}" var="u">
										<a href="/chat/create?targetUserNo=${u.memberDTO.userNo}" class="dm-item">
											<div class="dm-avatar">
												<img src="${(not empty u.memberDTO.profileDTO and not empty u.memberDTO.profileDTO.fileName) ? '/files/member/'.concat(u.memberDTO.profileDTO.fileName) : '/img/default_user.avif'}" 
													 onerror="this.src='/img/default_user.avif'" 
													 alt="profile">
											</div>
											<div class="dm-info">
												<div class="dm-nickname">${u.memberDTO.userNickname}</div>
											</div>
											<!-- 인스타그램 DM 특유의 카메라 장식 아이콘 -->
											<i class="fas fa-camera dm-camera"></i>
										</a>
									</c:forEach>
								</div>
							</c:when>
							<c:otherwise>
								<div class="search-empty">채팅 가능한 사용자가 없습니다.</div>
							</c:otherwise>
						</c:choose>

						<!-- 페이징 네비게이션 -->
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
					<!-- dm-container 닫기 -->
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
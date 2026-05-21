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
	body {
		background-color: #fafafa !important;
		color: #262626;
	}
	.container-fluid.dm-fluid {
		padding: 0 !important;
		min-height: calc(100vh - 70px);
		background: #fafafa;
	}
	.dm-shell {
		width: 100%;
		min-height: calc(100vh - 70px);
		box-sizing: border-box;
		padding-left: 6.5rem;
		padding-right: 1rem;
		padding-top: 0.75rem;
		padding-bottom: 0.75rem;
		max-width: 1400px;
		margin: 0 auto;
	}
	.dm-panel {
		width: 100%;
		max-width: 420px;
		height: calc(100vh - 85px);
		background: #fff;
		border: 1px solid #ececec;
		border-radius: 14px;
		overflow: hidden;
		display: flex;
		flex-direction: column;
	}
	.dm-header {
		display: flex;
		justify-content: center;
		align-items: center;
		padding: 14px 18px;
		border-bottom: 1px solid #f0f0f0;
		position: relative;
		background: #fff;
		flex: 0 0 auto;
	}
	.dm-header-title {
		font-weight: 600;
		font-size: 15px;
		color: #3a3a3a;
		letter-spacing: -0.01em;
	}
	.dm-header-icon {
		position: absolute;
		right: 18px;
		font-size: 18px;
		cursor: pointer;
		color: #a3a3a3;
	}
	.dm-list-wrap {
		flex: 1 1 auto;
		overflow-y: auto;
	}
	.dm-list {
		display: flex;
		flex-direction: column;
	}
	.dm-item {
		display: flex;
		align-items: center;
		padding: 11px 18px;
		text-decoration: none !important;
		color: inherit;
		transition: background-color 0.15s ease;
	}
	.dm-item:hover {
		background-color: #fafafa;
	}
	.dm-avatar {
		width: 52px;
		height: 52px;
		border-radius: 50%;
		overflow: hidden;
		flex-shrink: 0;
		background: #f1f1f1;
	}
	.dm-avatar img {
		width: 100%;
		height: 100%;
		object-fit: cover;
		display: block;
	}
	.dm-info {
		margin-left: 12px;
		flex-grow: 1;
		display: flex;
		flex-direction: column;
		justify-content: center;
	}
	.dm-nickname {
		font-size: 14px;
		font-weight: 500;
		color: #2f2f2f;
	}
	.dm-camera {
		font-size: 18px;
		color: #b8b8b8;
		opacity: 0.22;
	}
	.dm-item:hover .dm-camera {
		opacity: 0.45;
	}
	.search-empty {
		text-align: center;
		padding: 36px 20px;
		color: #9a9a9a;
		font-size: 13px;
	}
	.dm-pagination {
		flex: 0 0 auto;
		position: sticky;
		bottom: 0;
		background: linear-gradient(to top, #fff 70%, rgba(255, 255, 255, 0.92));
		border-top: 1px solid #f0f0f0;
		padding: 10px 12px 12px;
	}
	.pagination {
		justify-content: center;
		margin: 0;
	}
	.sidebar.toggled ~ #content-wrapper .dm-shell {
		padding-left: 6.5rem;
	}
	.sidebar:not(.toggled) ~ #content-wrapper .dm-shell {
		padding-left: 14rem;
	}
	@media (max-width: 768px) {
		.dm-shell {
			padding-left: 0 !important;
			padding-right: 0.5rem !important;
		}
		.dm-panel {
			max-width: 100%;
			height: calc(100vh - 70px);
			border-radius: 10px;
		}
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
					<div class="dm-shell">
						<div class="dm-panel">
						<!-- DM 헤더 영역 -->
						<div class="dm-header">
							<div class="dm-header-title">메시지 가능 사용자</div>
							<i class="far fa-edit dm-header-icon"></i>
						</div>

						<!-- 유저 리스트 영역 -->
						<div class="dm-list-wrap">
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
												<i class="fas fa-camera dm-camera"></i>
											</a>
										</c:forEach>
									</div>
								</c:when>
								<c:otherwise>
									<div class="search-empty">채팅 가능한 사용자가 없습니다.</div>
								</c:otherwise>
							</c:choose>
						</div>

						<!-- 페이징 네비게이션 -->
						<nav aria-label="Page navigation example" class="dm-pagination">
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
						</div>
						<!-- dm-panel 닫기 -->
					</div>
					<!-- dm-shell 닫기 -->
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
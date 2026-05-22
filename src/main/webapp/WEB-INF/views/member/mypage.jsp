<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
<c:import url="/WEB-INF/views/temp/head_css.jsp"></c:import>
<link rel="stylesheet" type="text/css" href="/css/feed-search.css">
<style>
/* Custom Profile Styling based on mypage.png */
.profile-wrapper {
	background-color: #fff;
	color: #262626;
	font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
	padding: 0;
	width: 100%;
	margin: 0 auto;
	min-height: 100vh;
	box-sizing: border-box;
	/* 기본: 접힌 사이드바(toggled) 너비(6.5rem)를 고려한 왼쪽 여백 + 우측 여유 */
	padding-left: 6.5rem;
	padding-right: 1rem;
	/* 중앙 정렬 시 너무 넓어지지 않게 최대 너비 제한 */
	max-width: 1400px;
}
.profile-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 12px 16px;
    font-size: 1.1rem;
    font-weight: 600;
}
.profile-header i {
    font-size: 1.2rem;
}
.profile-info-section {
    display: flex;
    align-items: flex-start;
    padding: 24px 16px;
    gap: 24px;
	max-width: 980px;
	margin: 0 auto;
}
.profile-avatar-wrapper {
    flex-shrink: 0;
    width: 120px;
    height: 120px;
    border-radius: 50%;
    background: transparent;
    padding: 0;
    display: flex;
    align-items: center;
    justify-content: center;
}
.profile-avatar-wrapper img {
    width: 100%;
    height: 100%;
    border-radius: 50%;
    border: 1px solid #dbdbdb;
    object-fit: cover;
}
.profile-details {
    flex-grow: 1;
    display: flex;
    flex-direction: column;
    gap: 12px;
}
.profile-username-row {
    display: flex;
    align-items: center;
    gap: 8px;
}
.profile-username-row .username {
    font-size: 1.6rem;
    font-weight: 800;
    color: #262626;
}
.profile-username-row .settings-icon {
    font-size: 1.4rem;
    color: #262626;
    cursor: pointer;
    text-decoration: none;
}
.profile-bio-name {
    font-size: 1.05rem;
    color: #262626;
}
.profile-stats-inline {
    display: flex;
    gap: 16px;
    font-size: 0.95rem;
    color: #262626;
}
.profile-stats-inline a {
    color: inherit;
    text-decoration: none;
}
.profile-stats-inline a:hover {
    color: #000000;
}
.profile-stats-inline .stat-val {
    font-weight: 700;
}
.profile-link {
    font-size: 1rem;
    font-weight: 700;
    color: #262626;
    display: flex;
    align-items: center;
    gap: 6px;
}
.profile-actions {
    display: flex;
    padding: 0 16px;
    gap: 8px;
    margin-bottom: 16px;
}
.profile-action-btn {
    flex: 1;
    background-color: #efefef;
    color: #262626;
    border: none;
    border-radius: 8px;
    padding: 8px 16px;
    font-weight: 600;
    font-size: 0.9rem;
    cursor: pointer;
    text-align: center;
    text-decoration: none;
    display: inline-flex;
    justify-content: center;
    align-items: center;
}
.profile-action-btn:hover {
    background-color: #dbdbdb;
    color: #262626;
}
.profile-action-btn.btn-primary-custom {
    background-color: #0095f6;
    color: #ffffff;
}
.profile-action-btn.btn-primary-custom:hover {
    background-color: #1877f2;
}
.profile-action-btn i {
    margin-right: 6px;
}
.profile-action-icon-btn {
    background-color: #efefef;
    color: #262626;
    border: none;
    border-radius: 8px;
    padding: 8px 12px;
    cursor: pointer;
    display: inline-flex;
    justify-content: center;
    align-items: center;
}
.profile-tabs {
    display: flex;
    border-top: 1px solid #dbdbdb;
}
.profile-tab {
    flex: 1;
    text-align: center;
    padding: 12px 0;
    cursor: pointer;
    color: #8e8e8e;
}
.profile-tab.active {
    color: #262626;
    border-bottom: 1px solid #262626;
}
.profile-grid {
	display: grid;
	grid-template-columns: repeat(5, 1fr);
	gap: 2px;
}

.profile-divider {
	border: none;
	height: 1px;
	background: #000000;
	margin: 12px 0 32px; /* 아래 여백을 더 늘림 */
	border-radius: 0;
	width: 100%;
	max-width: calc(100% - 32px);
}
.profile-divider-container {
	width: 100%;
	display: flex;
	justify-content: center;
}

/* 사이드바 상태에 따라 컨텐츠의 왼쪽 여백을 조절합니다. */
.sidebar.toggled ~ #content-wrapper .profile-wrapper {
	padding-left: 6.5rem; /* 접힌 상태 기본값 */
}
.sidebar:not(.toggled) ~ #content-wrapper .profile-wrapper {
	padding-left: 14rem; /* 확장(펼쳐진) 상태일 때 더 넉넉히 확보 */
}

/* 작은 화면에서도 기본 여백을 유지 */
@media (max-width: 768px) {
	.sidebar ~ #content-wrapper .profile-wrapper {
		padding-left: 6.5rem !important;
		padding-right: 1rem !important;
		max-width: 1400px;
	}
	.profile-grid {
		grid-template-columns: repeat(3, 1fr);
	}
}
.profile-grid-item {
    aspect-ratio: 1 / 1;
    background-color: #efefef;
    position: relative;
    display: block;
}
.profile-grid-item img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

/* 페이지 전체 컨텐츠 배경 오버라이드 */
#content {
	background-color: #fff !important;
}
</style>
</head>

<body id="page-top">
	<div id="wrapper">
		<c:import url="/WEB-INF/views/temp/sidebar.jsp"></c:import>
        
		<div id="content-wrapper" class="d-flex flex-column">
        
			<div id="content">
            
				<c:import url="/WEB-INF/views/temp/topbar.jsp"></c:import>
				<c:set var="pageMember" value="${not empty myposts ? myposts[0].memberDTO : member}" />
                    
				<!-- Begin Page Content -->
				<div class="container-fluid" style="padding: 0; background: #fff;">
					<div class="profile-wrapper">

						<!-- Profile Info & Bio -->
						<div class="profile-info-section">
							<div class="profile-avatar-wrapper">
								<c:choose>
									<c:when test="${not empty pageMember.profileDTO and not empty pageMember.profileDTO.fileName}">
										<img src="/files/member/${pageMember.profileDTO.fileName}" alt="Profile"> 
									</c:when>
									<c:otherwise>
										<img src="/img/default_user.avif" alt="Profile"> 
									</c:otherwise>
								</c:choose>
							</div>

							<div class="profile-details">
								<div class="profile-username-row">
									<span class="username">${pageMember.userNickname}</span>
									<c:if test="${isMine}">
										<i class="fas fa-cog settings-icon" onclick="location.href='/member/update'"></i>
									</c:if>
								</div>

								<div class="profile-bio-name">${pageMember.userNickname}</div>

								<div class="profile-stats-inline">
									<span>게시물 <span class="stat-val">${pager.totalCount}</span></span>
									<span>
										<a href="../follow/follower?userNo=${targetUserNo}">
											팔로워 <span class="stat-val" id="followerCount">${followerCount}</span>
										</a>
									</span>
									<span>
										<a href="../follow/following?userNo=${targetUserNo}">
											팔로우 <span class="stat-val">${followingCount}</span>
										</a>
									</span>
								</div>

								<div class="profile-link">
									<i class="fab fa-threads"></i> @${pageMember.userNickname}
								</div>
							</div>
						</div>

						<!-- Action Buttons -->
						<div class="profile-actions">
							<c:choose>
								<c:when test="${isMine}">
									<!-- [내 마이페이지 일 때] -->
									<button type="button" class="profile-action-btn" onclick="location.href='/post/create'">
										<i class="fas fa-plus-circle me-2"></i>게시물 만들기
									</button>
									<button type="button" class="profile-action-btn" onclick="location.href='/story/create'">
										<i class="fas fa-history me-2"></i>스토리 추가
									</button>
								</c:when>
								<c:otherwise>
									<!-- [상대방 마이페이지 일 때] -->
									<sec:authorize access="isAuthenticated()">
										<c:if test="${!isMine}">
											<button type="button" 
													class="profile-action-btn ${isFollowing ? '' : 'btn-primary-custom'}" 
													data-follow-state="${isFollowing ? 'following' : 'not-following'}" 
													onclick="followUser('${targetUserNo}', this)">
												${isFollowing ? '팔로잉' : '팔로우'}
											</button>
										</c:if>
										<button type="button" class="profile-action-btn" onclick="startChat(${pageMember.userNo})">
											메시지 보내기
										</button>
										<button type="button" class="profile-action-btn profile-action-icon-btn">
											<i class="fas fa-chevron-down"></i>
										</button>
									</sec:authorize>
								</c:otherwise>
							</c:choose>
						</div>

						<div class="profile-divider-container">
							<hr class="profile-divider" />
						</div>

						<!-- Grid -->
						<div class="profile-grid">
							<c:choose>
								<c:when test="${not empty myposts}">
									<c:forEach items="${myposts}" var="p">
										<a class="profile-grid-item search-tile" href="/feed/detail/post/${p.feedNo}" title="${p.memberDTO.userNickname}">
											<c:choose>
												<c:when test="${not empty p.list}">
													<img src="/files/post/${p.list[0].fileName}" alt="post image" onerror="this.src='/img/default_post.png'">
												</c:when>
												<c:otherwise>
													<img src="/img/default_post.png" alt="default post image">
												</c:otherwise>
											</c:choose>
										</a>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<div style="grid-column: 1 / -1; text-align: center; padding: 40px; color: #8e8e8e;">
										작성한 게시물이 없습니다.
									</div>
								</c:otherwise>
							</c:choose>
						</div>

					</div> <!-- End profile-wrapper -->
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
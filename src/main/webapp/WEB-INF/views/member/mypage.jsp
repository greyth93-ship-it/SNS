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
    background-color: #fafafa;
    color: #262626;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
    padding: 0;
    width: 100%;
    margin: 0 auto;
    min-height: 100vh;
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
.profile-stats-container {
    display: flex;
    align-items: center;
    padding: 16px;
    gap: 20px;
}
.profile-avatar-wrapper {
    flex-shrink: 0;
    width: 86px;
    height: 86px;
    border-radius: 50%;
    background: linear-gradient(45deg, #f09433 0%, #e6683c 25%, #dc2743 50%, #cc2366 75%, #bc1888 100%);
    padding: 3px;
    display: flex;
    align-items: center;
    justify-content: center;
}
.profile-avatar-wrapper img {
    width: 100%;
    height: 100%;
    border-radius: 50%;
    border: 3px solid #fafafa;
    object-fit: cover;
}
.profile-stats {
    flex-grow: 1;
    display: flex;
    justify-content: space-around;
    text-align: center;
}
.stat-item {
    display: flex;
    flex-direction: column;
}
.stat-item .stat-num {
    font-size: 1.1rem;
    font-weight: 700;
    color: #262626;
}
.stat-item .stat-label {
    font-size: 0.85rem;
    color: #8e8e8e;
}
.stat-item a {
    color: inherit;
    text-decoration: none;
    display: flex;
    flex-direction: column;
}
.stat-item a:hover {
    color: #000000;
}
.profile-bio {
    padding: 0 16px 16px;
    font-size: 0.95rem;
    line-height: 1.4;
}
.profile-bio-name {
    font-weight: 600;
    color: #262626;
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
    grid-template-columns: repeat(3, 1fr);
    gap: 2px;
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
</style>
</head>

<body id="page-top">
	<div id="wrapper">
		<c:import url="/WEB-INF/views/temp/sidebar.jsp"></c:import>
		
		<div id="content-wrapper" class="d-flex flex-column">
		
			<div id="content">
			
				<c:import url="/WEB-INF/views/temp/topbar.jsp"></c:import>
					
				<!-- Begin Page Content -->
				<div class="container-fluid" style="padding: 0; background: #fafafa;">
					<div class="profile-wrapper">
						

						<!-- Profile Info -->
						<div class="profile-stats-container">
							<div class="profile-avatar-wrapper">
								<c:choose>
									<c:when test="${not empty member.profileDTO.fileName}">
										<img src="/files/member/${member.profileDTO.fileName}" alt="Profile">
									</c:when>
									<c:otherwise>
										<img src="/img/default_user.avif" alt="Profile">
									</c:otherwise>
								</c:choose>
							</div>
							
							<div class="profile-stats">
								<div class="stat-item">
									<span class="stat-num">${pager.totalCount}</span>
									<span class="stat-label">Posts</span>
								</div>
								<div class="stat-item">
									<a href="../follow/follower?userNo=${targetUserNo}">
										<span class="stat-num" id="followerCount">${followerCount}</span>
										<span class="stat-label">Followers</span>
									</a>
								</div>
								<div class="stat-item">
									<a href="../follow/following?userNo=${targetUserNo}">
										<span class="stat-num">${followingCount}</span>
										<span class="stat-label">Following</span>
									</a>
								</div>
							</div>
						</div>
						
						<!-- Bio -->
						<div class="profile-bio">
							<div class="profile-bio-name">${member.userNickname}</div>
						</div>

						<!-- Action Buttons -->
						<div class="profile-actions">
							<c:choose>
								<c:when test="${isMine}">
									<!-- [내 마이페이지 일 때] -->
									<button type="button" class="profile-action-btn" onclick="location.href='/member/update'">
										프로필 편집
									</button>
									<button type="button" class="profile-action-btn" onclick="location.href='/post/create'">
										<i class="fas fa-plus-circle me-2"></i>포스트 만들기
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
										<button type="button" class="profile-action-btn" onclick="startChat(${member.userNo})">
											메시지 보내기
										</button>
										<button type="button" class="profile-action-icon-btn">
											<i class="fas fa-chevron-down"></i>
										</button>
									</sec:authorize>
								</c:otherwise>
							</c:choose>
						</div>

						<!-- Tabs -->
						<div class="profile-tabs">
							<div class="profile-tab active"><i class="fas fa-th"></i></div>
							<div class="profile-tab"><i class="fas fa-user-tag"></i></div>
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
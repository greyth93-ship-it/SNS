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
.profile-info-section {
    display: flex;
    align-items: flex-start;
    padding: 24px 16px;
    gap: 24px;
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
				<c:set var="pageMember" value="${not empty myposts ? myposts[0].memberDTO : member}" />
                    
				<!-- Begin Page Content -->
				<div class="container-fluid">

					   <!-- Page Heading -->
						   <h1 class="h3 mb-4 text-gray-800">${pageMember.userNickname}의 마이페이지</h1>
                    
					<div class="mb-4">
						<!-- 프로필 이미지가 없을 때를 대비한 기본 이미지 처리 예시 -->
							<c:choose>
								<c:when test="${not empty pageMember.profileDTO and not empty pageMember.profileDTO.fileName}">
								<img class="img-profile rounded-circle" src="/files/member/${pageMember.profileDTO.fileName}" style="width: 80px; height: 80px; object-fit: cover;"> 
								</c:when>
								<c:otherwise>
								<img class="img-profile rounded-circle" src="/img/default_user.avif" style="width: 80px; height: 80px; object-fit: cover;"> 
								</c:otherwise>
							</c:choose>
						<h6 class="mt-2">게시물 <span class="badge bg-secondary text-white">${pager.totalCount}</span></h6>
						<h6>
							팔로워 <span id="followerCount" class="badge bg-secondary text-white">${followerCount}</span>
							<a class="ms-2" href="../follow/follower?userNo=${targetUserNo}">보기</a>
						</h6>
						<h6>
							팔로잉 <span class="badge bg-secondary text-white">${followingCount}</span>
							<a class="ms-2" href="../follow/following?userNo=${targetUserNo}">보기</a>
						</h6>
					</div>
                       
					<!-- 2. 내 페이지인가? 상대방 페이지인가? 에 따른 버튼 분기 처리 -->
					<c:choose>
						<c:when test="${isMine}">
							<!-- [내 마이페이지 일 때] -->
							<div class="d-flex justify-content-between gap-2 mb-2">
								<button type="button" class="btn btn-outline-primary w-100 py-2 fw-bold"
									onclick="location.href='/member/update'">
									프로필 편집
								</button>
							</div>
                            
							<div class="d-flex justify-content-between gap-2 mb-4">
								<button type="button" class="btn btn-primary w-100 py-2 fw-bold"
									onclick="location.href='/post/create'">
									<i class="fas fa-plus-circle me-2"></i>포스트 만들기
								</button>
								<button type="button"
									class="btn btn-outline-danger w-100 py-2 fw-bold"
									onclick="location.href='/story/create'">
									<i class="fas fa-history me-2"></i>스토리 추가
								</button>
							</div>
						</c:when>
						<c:otherwise>
							<!-- [상대방 마이페이지 일 때] 로그인한 상태일 때만 팔로우 가능 -->
							<sec:authorize access="isAuthenticated()">
								<div class="d-flex justify-content-between gap-2 mb-4">

									<c:if test="${!isMine}">
										<button type="button"
												class="btn ${isFollowing ? 'btn-secondary' : 'btn-outline-primary'}"
												data-follow-state="${isFollowing ? 'following' : 'not-following'}"
												onclick="followUser('${targetUserNo}', this)">
											${isFollowing ? '팔로잉' : '팔로우'}
										</button>
									</c:if>
									<button type="button" class="btn btn-outline-secondary w-50 py-2 fw-bold" onclick="startChat(${pageMember.userNo})">
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
                        
						<div class="post-summary-list mt-3">
							<c:choose>
								<c:when test="${not empty myposts}">
									<div class="search-gallery">
										<c:forEach items="${myposts}" var="p">
											<a class="search-tile" href="/feed/detail/post/${p.feedNo}" title="${p.memberDTO.userNickname}">
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
									</div>
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
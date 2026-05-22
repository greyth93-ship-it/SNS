<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SNS Feed</title>
<c:import url="/WEB-INF/views/temp/head_css.jsp"></c:import>
<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal" var="principal" />
	<meta name="current-user-no" content="${principal.userNo}">
</sec:authorize>
<link rel="stylesheet" type="text/css" href="/css/feed-detail.css">
<style>
	/* 인스타그램 피드 (card_list) 스타일 커스텀 */
	body {
		background-color: #fafafa !important;
	}
	.container-fluid {
		max-width: 800px;
		padding-top: 30px;
	}
	
	/* 스토리 영역 */
	.story-wrapper {
		display: flex;
		gap: 15px;
		overflow-x: auto;
		padding: 15px;
		margin-bottom: 20px;
		border: 1px solid #dbdbdb;
		border-radius: 8px;
		background-color: #fff;
		scrollbar-width: none; /* 파이어폭스 스크롤바 숨김 */
	}
	.story-wrapper::-webkit-scrollbar {
		display: none; /* 크롬 스크롤바 숨김 */
	}
	.story-item {
		display: flex;
		flex-direction: column;
		align-items: center;
		gap: 6px;
		cursor: pointer;
		min-width: 66px;
	}
	.story-circle {
		width: 66px;
		height: 66px;
		border-radius: 50%;
		padding: 2px;
		background: linear-gradient(45deg, #f09433 0%, #e6683c 25%, #dc2743 50%, #cc2366 75%, #bc1888 100%);
	}
	.story-circle img {
		width: 100%;
		height: 100%;
		border-radius: 50%;
		border: 2px solid #fff;
		object-fit: cover;
	}
	.story-item small {
		font-size: 12px;
		color: #262626;
		max-width: 66px;
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
	}

	/* 피드 카드 영역 */
	.post-container {
		display: flex;
		flex-direction: column;
		align-items: center;
	}
	.post-card {
		width: 100%;
		max-width: 600px;
		background: #fff;
		border: 1px solid #dbdbdb;
		border-radius: 8px;
		padding-bottom: 20px;
		margin-bottom: 25px;
	}
	
	/* 헤더 */
	.post-card .p-3.gap-3 {
		padding: 14px 16px !important;
		gap: 10px !important;
	}
	.profile-circle.post-profile {
		width: 32px;
		height: 32px;
		border-radius: 50%;
		overflow: hidden;
	}
	.profile-circle.post-profile img {
		width: 100%;
		height: 100%;
		object-fit: cover;
	}
	.user-info strong {
		font-size: 14px;
		color: #262626;
		font-weight: 600;
	}
	.user-info .text-muted.small {
		font-size: 12px;
	}
	.dropdown-toggle-dot {
		background: none !important;
		border: none !important;
		color: #262626 !important;
		font-size: 20px;
		padding: 0 8px;
		line-height: 1;
	}
	.dropdown-toggle-dot:focus, .dropdown-toggle-dot:hover {
		box-shadow: none !important;
	}

	/* 이미지 */
	.post-img-wrapper {
		border-radius: 0;
		border-top: 1px solid #efefef;
		border-bottom: 1px solid #efefef;
		overflow: hidden;
		width: 100%;
		cursor: pointer;
	}
	.post-img-wrapper img.post-img {
		width: 100%;
		height: auto;
		object-fit: cover;
		display: block;
	}

	/* 액션 버튼 (좋아요, 댓글, 공유) */
	.post-card .p-3.pb-0.gap-5 {
		padding: 14px 16px 8px 16px !important;
		gap: 16px !important; /* 아이콘 간격 축소 */
	}
	.action-item {
		display: flex;
		align-items: center;
	}
	.action-item i {
		font-size: 24px;
		color: #262626;
	}
	.action-item i.fa-heart.fas {
		color: #ed4956;
	}
	.action-item .like-count {
		font-size: 14px;
		font-weight: 600;
		color: #262626;
		margin-left: 8px !important;
	}

	/* 본문 텍스트 */
	.post-card .px-3.pb-3.pt-0 {
		padding: 0 16px !important;
	}
	.post-content {
		font-size: 14px;
		line-height: 1.5;
	}
	.post-author {
		font-weight: 600;
		margin-right: 4px;
	}
	.post-text {
		color: #262626;
	}
	.readmore-btn {
		color: #8e8e8e;
		font-size: 14px;
		text-decoration: none !important;
		margin-left: 5px;
	}
	
	/* 팔로우 버튼 */
	.follow-btn {
		font-size: 12px !important;
		padding: 4px 8px !important;
		border-radius: 6px !important;
		background-color: #efefef !important;
		color: #262626 !important;
		border: none !important;
	}
	.follow-btn:hover {
		background-color: #dbdbdb !important;
	}
</style>
</head>

<body>
	<div id="wrapper">
		<c:import url="/WEB-INF/views/temp/sidebar.jsp"></c:import>
		<div id="content-wrapper" class="d-flex flex-column">
			<div id="content">
				<c:import url="/WEB-INF/views/temp/topbar.jsp"></c:import>
				<div class="container-fluid">
					<div class="row justify-content-center">
						<div class="col-lg-8">
							<div class="story-pagination-wrapper" style="display:flex; align-items:center; gap:8px; width:100%">
								<button id="storyPrevBtn" class="btn btn-sm btn-light" style="min-width:36px;">◀</button>
								<div class="story-wrapper" id="storyWrapper" style="flex:1;">
									<c:forEach items="${storyList}" var="s">
										<div class="story-item" data-user-no="${s.userNo}" data-feed-no="${s.feedNo}" onclick="openDetail('story', '${s.feedNo}', '${s.userNo}')">
											<div class="story-circle">
												<img src="${not empty s.memberDTO.profileDTO and not empty s.memberDTO.profileDTO.fileName ? '/files/member/'.concat(s.memberDTO.profileDTO.fileName) : '/img/default_user.avif'}" onerror="this.src='/img/default_user.avif'">
											</div>
											<small>${s.memberDTO.userNickname}</small>
										</div>
									</c:forEach>
								</div>
								<button id="storyNextBtn" class="btn btn-sm btn-light" style="min-width:36px;">▶</button>
							</div>

							<div class="post-container">
								<c:forEach items="${postList}" var="p">
									<article class="post-card" data-feed-no="${p.feedNo}">
										<div class="p-3 d-flex align-items-center gap-3">
											<!-- 프로필 이미지 -->
											<div class="profile-circle post-profile flex-shrink-0" data-user-no="${p.memberDTO.userNo}">
												<img
													src="${not empty p.memberDTO.profileDTO and not empty p.memberDTO.profileDTO.fileName ? '/files/member/'.concat(p.memberDTO.profileDTO.fileName) : '/img/default_user.avif'}"
													onerror="this.src='/img/default_user.avif'">
											</div>

											<!-- 유저 정보 (flex-grow-1을 추가하여 남은 공간을 다 차지하게 함) -->
											<div class="user-info flex-grow-1">
												<a href="/member/mypage?userNo=${p.memberDTO.userNo}" class="user-link text-dark text-decoration-none" onclick="event.stopPropagation()">
													<strong class="d-block">${p.memberDTO.userNickname}</strong>
												</a>
												<div class="text-muted small">
													<i class="fas fa-location-dot"></i> <span>${p.feedLocation}</span>
												</div>
											</div>

											<!-- 팔로우 버튼 + 옵션 드롭다운 -->
											<div class="post-action-group ms-auto flex-shrink-0 d-flex align-items-center" style="gap:6px;">
												<c:if test="${not empty p.currentUserNo and not p.followedByMe}">
													<button type="button" class="btn btn-sm btn-light fw-bold text-primary follow-btn"
														data-user-no="${p.memberDTO.userNo}" style="white-space: nowrap;">팔로우</button>
												</c:if>
												<div class="dropdown-container position-relative">
													<button type="button" class="btn btn-sm btn-light dropdown-toggle-dot" onclick="togglePostMenu(event, 'list', '${p.feedNo}')">⋯</button>
													<div class="dropdown-menu-custom list-menu" id="post-menu-list-${p.feedNo}" style="display:none;">
														<button type="button" class="dropdown-item" onclick="editPost(event, '${p.feedNo}')">수정</button>
														<button type="button" class="dropdown-item text-danger" onclick="deletePost(event, '${p.feedNo}')">삭제</button>
													</div>
												</div>
											</div>
										</div>
										<div class="post-img-wrapper"
											onclick="openDetail('post', '${p.feedNo}')">
											<img
												src="${not empty p.list ? '/files/post/'.concat(p.list[0].fileName) : '/img/default_user.avif'}"
												class="post-img">
										</div>

										<div class="p-3 pb-0 d-flex gap-5">
											<div class="action-item" style="cursor: pointer;"
												onclick="likePost(event, '${p.feedNo}', this)">
												<img src="${p.likedByMe ? '/icon/like_select.svg' : '/icon/like_default.svg'}" class="like-icon" style="width: 24px; height: 24px;">
												<span class="like-count ms-1 small">${empty p.feedThumb ? 0 : p.feedThumb}</span>
											</div>
											<div class="action-item" style="cursor: pointer;"
												onclick="openDetail('post', '${p.feedNo}')">
												<img src="/icon/comment_default.svg" style="width: 24px; height: 24px;">
											</div>
											<div class="action-item" style="cursor: pointer;"
												onclick="sharePost(event, '${p.feedNo}')">
												<img src="/icon/chat_default.svg" style="width: 24px; height: 24px;">
											</div>
										</div>
										<div class="px-3 pb-3 pt-0">
											<div class="post-content">
												<a href="/member/mypage?userNo=${p.memberDTO.userNo}" class="post-author-link text-dark text-decoration-none" onclick="event.stopPropagation()">
													<strong class="post-author">${p.memberDTO.userNickname}</strong>
												</a>
												<span class="post-text">${p.feedContent}</span>
												<button type="button" class="btn btn-link p-0 readmore-btn" style="display:none;">더보기</button>
											</div>
										</div>
									</article>
								</c:forEach>

							</div>
							<div>
								<nav aria-label="Page navigation example">
									<ul class="pagination">
										<li class="page-item ${pager.pre ? '' : 'disabled'}"><a
											class="page-link"
											href="./list?page=${pager.pre ? pager.start-1 : pager.start}&search=${pager.search}&kind=${pager.kind}"
											aria-label="Previous"> <span aria-hidden="true">&laquo;</span>
										</a></li>

										<c:forEach begin="${pager.start}" end="${pager.end}" var="i">
											<li class="page-item ${pager.page == i ? 'active' : ''}">
												<a class="page-link"
												href="./list?page=${i}&search=${pager.search}&kind=${pager.kind}">${i}</a>
											</li>
										</c:forEach>

										<li class="page-item ${pager.next ? '' : 'disabled'}"><a
											class="page-link"
											href="./list?page=${pager.next ? pager.end+1 : pager.end}&search=${pager.search}&kind=${pager.kind}"
											aria-label="Next"> <span aria-hidden="true">&raquo;</span>
										</a></li>
									</ul>
								</nav>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div id="detailModal">
		<span class="close-btn" onclick="closeModal()">&times;</span>
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-body p-0">
					<div class="row g-0 h-100">
						<div id="mImage" class="col-md-7"></div>
						<div id="mInfo" class="col-md-5 info-side">
							<div class="modal-header-custom">
								<strong id="mOwner"></strong>
								<div id="mLocation" class="text-muted small"></div>
							</div>
							<div class="modal-body-custom">
								<div id="mContent"></div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div id="shareModal" class="modal"
		style="display: none; position: fixed; z-index: 2000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0, 0, 0, 0.5); justify-content: center; align-items: center;">
		<div class="modal-dialog modal-sm modal-dialog-centered"
			style="width: 300px; margin: auto;">
			<div class="modal-content"
				style="border-radius: 12px; overflow: hidden; border: none;">
				<div class="modal-header border-0 pb-0 justify-content-center pt-3">
					<h6 class="modal-title fw-bold">공유하기</h6>
				</div>
				<div class="modal-body p-0 pt-2">
					<div class="list-group list-group-flush text-center">
						<button type="button" id="shareChatBtn"
							class="list-group-item list-group-item-action py-3 text-primary fw-bold">
							<i class="far fa-comment-dots me-2"></i>채팅으로 공유하기
						</button>
						<button type="button" id="shareExternalBtn"
							class="list-group-item list-group-item-action py-3">
							<i class="far fa-copy me-2"></i>외부로 공유하기 (링크 복사)
						</button>
						<button type="button"
							class="list-group-item list-group-item-action py-3 text-muted small"
							onclick="closeShareModal()">취소</button>
					</div>
				</div>
			</div>
		</div>
	</div>

		<!-- 채팅 공유용 맞팔 목록 모달 -->
		<div id="shareChatListModal" class="modal" style="display:none; position: fixed; z-index: 4000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5); justify-content: center; align-items: center;">
			<div class="modal-dialog modal-dialog-centered" style="width: 320px !important; max-width: 90%; margin: auto;">
				<div class="modal-content" style="border-radius:12px; overflow:hidden; border:none;">
					<div class="modal-header border-0 pb-0 justify-content-center pt-3">
						<h6 class="modal-title fw-bold">공유할 친구 선택</h6>
					</div>
					<div class="modal-body p-2" style="max-height:60vh; overflow-y:auto;">
					<div id="shareChatListContainer" style="display: flex; flex-wrap: wrap; gap: 15px; justify-content: flex-start; align-items: flex-start; padding: 10px;"></div>
					</div>
					<div class="modal-footer border-0 pt-0 pb-3 justify-content-center">
						<button type="button" class="btn btn-sm btn-light text-muted" onclick="closeShareChatListModal()">취소</button>
					</div>
				</div>
			</div>
		</div>

		<c:import url="/WEB-INF/views/temp/footer_script.jsp"></c:import>
	<script src="/js/feed-detail.js"></script>

	<!-- Client-side pagination for story thumbnails (8 per page) -->
	<script>
	(function(){
		const ITEMS_PER_PAGE = 8;
		const wrapper = document.getElementById('storyWrapper');
		const prevBtn = document.getElementById('storyPrevBtn');
		const nextBtn = document.getElementById('storyNextBtn');
		if (!wrapper || !prevBtn || !nextBtn) return;
		const items = Array.from(wrapper.querySelectorAll('.story-item'));
		let currentPage = 0;
		const totalPages = Math.max(1, Math.ceil(items.length / ITEMS_PER_PAGE));

		function renderPage(page){
			currentPage = Math.max(0, Math.min(page, totalPages-1));
			items.forEach((it, idx) => {
				if (idx >= currentPage*ITEMS_PER_PAGE && idx < (currentPage+1)*ITEMS_PER_PAGE) {
					it.style.display = '';
				} else {
					it.style.display = 'none';
				}
			});
			prevBtn.disabled = (currentPage === 0);
			nextBtn.disabled = (currentPage === totalPages-1);
		}

		prevBtn.addEventListener('click', function(e){ e.preventDefault(); renderPage(currentPage-1); });
		nextBtn.addEventListener('click', function(e){ e.preventDefault(); renderPage(currentPage+1); });

		// initial render
		renderPage(0);
		// prevent horizontal scroll (we control visible items)
		wrapper.style.overflowX = 'hidden';
	})();
	</script>
</body>
</html>
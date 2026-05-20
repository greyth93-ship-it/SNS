<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>알림 센터</title>
<c:import url="/WEB-INF/views/temp/head_css.jsp"></c:import>
<link rel="stylesheet" type="text/css" href="/css/feed-detail.css">
<style>
	.push-read {
		opacity: 0.6;
	}

	.push-read .push-date,
	.push-read .push-message {
		font-weight: 400;
		color: #858796;
	}

	.push-unread .push-date {
		font-weight: 700;
		color: #5a5c69;
	}

	.push-unread .push-message {
		font-weight: 700;
		color: #212529;
	}

	.push-avatar {
		width: 42px;
		height: 42px;
		border-radius: 50%;
		overflow: hidden;
		flex-shrink: 0;
		background: #f8f9fc;
	}

	.push-avatar-wrap {
		position: relative;
		display: inline-block;
		overflow: visible;
	}

	.push-avatar img {
		width: 100%;
		height: 100%;
		object-fit: cover;
		display: block;
	}

	.push-like-badge {
		position: absolute;
		right: -2px;
		bottom: -2px;
		width: 18px;
		height: 18px;
		border-radius: 50%;
		background: #e74a3b;
		border: 2px solid #fff;
		display: flex;
		align-items: center;
		justify-content: center;
	}

	.push-like-badge i {
		font-size: 9px;
		color: #fff;
	}

	.push-follow-btn {
		white-space: nowrap;
		flex-shrink: 0;
	}

	.push-follow-btn.btn-secondary {
		cursor: default;
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
							<h4 class="mb-4 d-flex align-items-center">
								알림 센터
								<c:if test="${unreadCount > 0}">
									<span class="badge badge-danger badge-counter ml-2" style="position: static;">${unreadCount}</span>
								</c:if>
							</h4>
							<div class="list-group">
								<c:forEach items="${pushList}" var="p">
									<c:choose>
										<c:when test="${p.read}">
											<c:set var="itemClass" value="push-read" />
										</c:when>
										<c:otherwise>
											<c:set var="itemClass" value="push-unread" />
										</c:otherwise>
									</c:choose>
									<c:choose>
										<c:when test="${p.pushType eq 'FOLLOW'}">
											<c:set var="moveUrl" value="/feed/mypage?userNo=${p.senderNo}" />
										</c:when>
										<c:when test="${p.pushType eq 'STORY_LIKE'}">
											<c:set var="moveUrl" value="/feed/detail/story/${p.feedNo}" />
										</c:when>
										<c:otherwise>
											<c:set var="moveUrl" value="/feed/detail/post/${p.feedNo}" />
										</c:otherwise>
									</c:choose>
									<div class="list-group-item list-group-item-action d-flex align-items-center justify-content-between ${itemClass}"
										data-push-no="${p.pushNo}"
									data-move-url="${moveUrl}">
										<a href="javascript:void(0);" class="d-flex align-items-center flex-grow-1 text-decoration-none text-reset pr-2"
											onclick="handleNotificationClick(this.parentElement.dataset.pushNo, this.parentElement.dataset.moveUrl)">
											<div class="mr-3">
												<div class="push-avatar-wrap">
													<div class="push-avatar">
														<img src="${not empty p.senderProfileFileName ? '/files/member/'.concat(p.senderProfileFileName) : '/img/default_user.avif'}"
															onerror="this.src='/img/default_user.avif'" alt="profile">
													</div>
													<c:if test="${p.pushType eq 'LIKE'}">
														<span class="push-like-badge"><i class="fas fa-heart"></i></span>
													</c:if>
												</div>
											</div>
											<div>
												<div class="small push-date">${p.pushDate}</div>
												<div class="push-message">${p.pushMsg}</div>
											</div>
										</a>
										<c:if test="${p.pushType eq 'FOLLOW'}">
											<button type="button" class="btn btn-sm ${p.followedByMe ? 'btn-secondary' : 'btn-outline-primary'} push-follow-btn"
												data-sender-no="${p.senderNo}"
												data-follow-state="${p.followedByMe ? 'following' : 'not-following'}"
												onclick="toggleFollowFromAlarm(event, this.dataset.senderNo, this)">${p.followedByMe ? '팔로잉' : '팔로우'}</button>
										</c:if>
									</div>
								</c:forEach>
								<c:if test="${empty pushList}">
									<div class="list-group-item text-center small text-gray-500">새로운 알림이 없습니다.</div>
								</c:if>
							</div>
							<div class="mt-4">
								<nav aria-label="알림 페이지 네비게이션">
									<ul class="pagination justify-content-center">
										<li class="page-item ${pager.pre ? '' : 'disabled'}">
											<a class="page-link"
												href="./allList?page=${pager.pre ? pager.start - 1 : pager.start}"
												aria-label="Previous">
												<span aria-hidden="true">&laquo;</span>
											</a>
										</li>

										<c:forEach begin="${pager.start}" end="${pager.end}" var="i">
											<li class="page-item ${pager.page == i ? 'active' : ''}">
												<a class="page-link" href="./allList?page=${i}">${i}</a>
											</li>
										</c:forEach>

										<li class="page-item ${pager.next ? '' : 'disabled'}">
											<a class="page-link"
												href="./allList?page=${pager.next ? pager.end + 1 : pager.end}"
												aria-label="Next">
												<span aria-hidden="true">&raquo;</span>
											</a>
										</li>
									</ul>
								</nav>
							</div>
							<div class="mt-3 text-center">
								<a href="javascript:history.back();" class="btn btn-secondary">뒤로</a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<c:import url="/WEB-INF/views/temp/footer_script.jsp"></c:import>
	<script src="/js/topbar.js"></script>
</body>
</html>

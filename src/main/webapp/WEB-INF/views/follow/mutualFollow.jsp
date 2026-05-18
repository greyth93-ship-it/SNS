<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상호 팔로우</title>
<c:import url="/WEB-INF/views/temp/head_css.jsp"></c:import>
<link rel="stylesheet" type="text/css" href="/css/feed-search.css">
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
								<div class="search-title">맞팔로우</div>
								<div class="search-sub">서로 팔로우하고 있는 유저 목록입니다.</div>
							</div>

							<c:choose>
								<c:when test="${not empty mutualList}">
									<div class="user-grid">
										<c:forEach items="${mutualList}" var="u">
											<div class="user-card">
												<a href="/feed/goMypage?userNo=${u.memberDTO.userNo}"
													class="user-card-link">
													<div class="user-avatar-wrapper">
														<img
															src="${not empty u.memberDTO.profileDTO and not empty u.memberDTO.profileDTO.fileName ? '/files/member/'.concat(u.memberDTO.profileDTO.fileName) : '/img/default_user.avif'}"
															onerror="this.src='/img/default_user.avif'" alt="profile">
													</div>
													<div class="user-info">
														<div class="user_nickname">${u.memberDTO.userNickname}</div>
														<div class="user_no">@${u.memberDTO.userNo}</div>
													</div>
												</a>
												<div class="user-actions mt-2">
													<a href="/chat/detail?userNo=${u.memberDTO.userNo}"
														class="btn btn-sm btn-primary">채팅</a>
												</div>
											</div>
										</c:forEach>
									</div>
								</c:when>
								<c:otherwise>
									<div class="search-empty">상호 팔로우 중인 사용자가 없습니다.</div>
								</c:otherwise>
							</c:choose>
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

	<c:import url="/WEB-INF/views/temp/footer_script.jsp"></c:import>
</body>
</html>

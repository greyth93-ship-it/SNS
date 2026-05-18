<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>팔로워</title>
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
								<div class="search-title">팔로워</div>
								<div class="search-sub">나를 팔로우한 유저 목록입니다.</div>
							</div>

							<c:choose>
								<c:when test="${not empty followerList}">
									<div class="user-grid">
										<c:forEach items="${followerList}" var="u">
											<a href="/feed/goMypage?userNo=${u.memberDTO.userNo}"
												class="user-card-link">
												<div class="user-card">
													<div class="user-avatar-wrapper">
														<img
															src="${not empty u.memberDTO.profileDTO and not empty u.memberDTO.profileDTO.fileName ? '/files/member/'.concat(u.memberDTO.profileDTO.fileName) : '/img/default_user.avif'}"
															onerror="this.src='/img/default_user.avif'" alt="profile">
													</div>
													<div class="user-info">
														<div class="user_nickname">${u.memberDTO.userNickname}</div>
														<div class="user_no">@${u.memberDTO.userNo}</div>
													</div>
												</div>
											</a>
										</c:forEach>
									</div>
								</c:when>
								<c:otherwise>
									<div class="search-empty">팔로워가 없습니다.</div>
								</c:otherwise>
							</c:choose>
						</div>
						
					</div>
				</div>
			</div>
		</div>
	</div>

	<c:import url="/WEB-INF/views/temp/footer_script.jsp"></c:import>
</body>
</html>

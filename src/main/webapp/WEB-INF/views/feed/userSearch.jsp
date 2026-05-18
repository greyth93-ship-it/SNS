<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>User Search</title>
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
								<div class="search-title">Search Users</div>
								
								<form action="/feed/userSearch" method="get" class="search-form">
									<div class="search-input-group">
										<i class="fas fa-search"></i>
										<input type="text" name="keyword" value="${keyword}" class="search-input" placeholder="찾고 싶은 유저의 닉네임을 입력하세요">
									</div>

									<button type="submit" class="search-submit">검색</button>
								</form>
							</div>

							<c:choose>
								<c:when test="${not empty memberList}">
									<div class="user-grid">
										<c:forEach items="${memberList}" var="u">
											<a href="/feed/goMypage?userNo=${u.userNo}" class="user-card-link">
												<div class="user-card">
													<div class="user-avatar-wrapper">
														<img src="${not empty u.profileDTO and not empty u.profileDTO.fileName ? '/files/member/'.concat(u.profileDTO.fileName) : '/img/default_user.avif'}" 
															 onerror="this.src='/img/default_user.avif'" alt="profile">
													</div>
													<div class="user-info">
														<div class="user_nickname">${u.userNickname}</div>
														<div class="user_no">@${u.userNo}</div>
													</div>
												</div>
											</a>
										</c:forEach>
									</div>
								</c:when>
								<c:otherwise>
									<div class="search-empty">
										검색 결과가 없습니다.
									</div>
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
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SNS Search</title>
<c:import url="/WEB-INF/views/temp/head_css.jsp"></c:import>
<link rel="stylesheet" type="text/css" href="/css/feed-search.css">
<style>
	/* 인스타그램 그리드 (mypage_list) 스타일 커스텀 */
	.search-gallery {
		display: grid !important;
		grid-template-columns: repeat(3, 1fr) !important;
		gap: 5px !important; /* 이미지 사이의 간격 */
		width: 100% !important;
		max-width: 935px !important; /* 인스타그램 최대 너비 */
		margin: 20px auto 0 auto !important;
	}
	.search-tile {
		position: relative !important;
		width: 100% !important;
		padding-bottom: 100% !important; /* 정사각형(1:1) 비율 유지 핵심 */
		display: block !important;
		overflow: hidden !important;
		background-color: #efefef !important;
		margin: 0 !important;
		border: none !important;
	}
	.search-tile img {
		position: absolute !important;
		top: 0 !important;
		left: 0 !important;
		width: 100% !important;
		height: 100% !important;
		object-fit: cover !important; /* 이미지가 찌그러지지 않고 꽉 차게 잘림 */
		display: block !important;
	}
	
	/* 사진에 마우스를 올렸을 때 살짝 어두워지는 효과 */
	.search-tile:hover::after {
		content: '';
		position: absolute;
		top: 0; left: 0; right: 0; bottom: 0;
		background-color: rgba(0, 0, 0, 0.3);
		z-index: 1;
		transition: background-color 0.2s ease;
	}
</style>
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
								<div class="search-title">Search Contents</div>

								<form action="/post/search" method="get" class="search-form">
									<!-- 검색 조건 선택 (kind) -->
									<select name="kind" class="search-kind-select">
										<option value="v1" ${pager.kind eq 'v1' ? 'selected' : ''}>내용</option>
										<option value="v2" ${pager.kind eq 'v2' ? 'selected' : ''}>작성자</option>
									</select>

									<!-- 입력 그룹 -->
									<div class="search-input-group">
										<i class="fas fa-search"></i> <input type="text" name="search"
											value="${pager.search}" class="search-input"
											placeholder="검색어를 입력하세요">
									</div>

									<button type="submit" class="search-submit">검색</button>
								</form>
							</div>

							<c:choose>
								<c:when test="${not empty postList}">
									<div class="search-gallery">
										<c:forEach items="${postList}" var="p">
											<a class="search-tile" href="/feed/detail/post/${p.feedNo}"
												title="${p.memberDTO.userNickname}"> <c:choose>
													<c:when test="${not empty p.list}">
													<img src="/files/post/${p.list[0].fileName}"
															alt="post image"
															onerror="this.src='/img/default_post.png'">
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
									<div class="search-empty">검색 결과가 없습니다.</div>
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
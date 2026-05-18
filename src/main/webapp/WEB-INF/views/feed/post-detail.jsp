<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Post Detail</title>
<c:import url="/WEB-INF/views/temp/head_css.jsp"></c:import>
<link rel="stylesheet" type="text/css" href="/css/feed-detail.css">
</head>

<body>

	<!-- 배경 페이지는 그냥 빈 화면 -->
	<div id="wrapper">
		<div id="content-wrapper">
			<div id="content"></div>
		</div>
	</div>
									<div class="text-muted small post-location"><i class="fas fa-location-dot"></i> <span>${post.feedLocation}</span></div>
	<!-- 메인에서 쓰는 팝업 그대로 -->
	<div id="detailModal">
		<span class="close-btn" onclick="history.back()">&times;</span>
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-body p-0">
					<div class="row g-0 h-100">
						<div id="mImage" class="col-md-7"></div>
						<div id="mInfo" class="col-md-5 info-side"></div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<c:import url="/WEB-INF/views/temp/footer_script.jsp"></c:import>
	<script src="/js/feed-detail.js"></script>

	<script>
		window.addEventListener('load', () => {
			openDetail('post', '${post.feedNo}');
		});
	</script>

</body>
</html>
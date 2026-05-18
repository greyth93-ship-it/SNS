<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Story Detail</title>
<c:import url="/WEB-INF/views/temp/head_css.jsp"></c:import>
<link rel="stylesheet" type="text/css" href="/css/feed-detail.css">
</head>

<body>

	<div id="wrapper">
		<div id="content-wrapper">
			<div id="content"></div>
		</div>
	</div>

	<!-- 메인 스토리 팝업 그대로 -->
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
			openDetail('story', '${story.feedNo}', '${story.userNo}');
		});
	</script>

</body>
</html>
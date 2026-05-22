<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
<c:import url="/WEB-INF/views/temp/head_css.jsp"></c:import>
<link rel="stylesheet" type="text/css" href="/css/feed-create.css">
<style>
/* chat/detail 스타일을 활용한 가운데 정렬된 카드형 레이아웃 */
body { background-color: #fafafa !important; }
.container-fluid.dm-fluid { padding: 20px !important; display: flex; justify-content: center; align-items: center; min-height: calc(100vh - 110px); }
.chat-container { width: 100%; max-width: 680px; background-color: #fff; border: 1px solid #dbdbdb; border-radius: 8px; display: flex; flex-direction: column; gap: 0; overflow: hidden; padding: 0; }
.chat-header { display: flex; align-items: center; padding: 18px 20px; background-color: #fff; border-bottom: 1px solid #dbdbdb; }
.chat-header .user_nickname { font-weight: 700; font-size: 18px; color: #262626; }
.chat-messages { padding: 24px; width: 100%; box-sizing: border-box; }
.form-group label { font-weight: 600; }
.btn-primary { border-radius: 6px; }
	.profile-upload-card { width: 240px; max-width: 100%; margin: 0; }
	.profile-upload-card #imagePreview { width: 100%; height: 240px; border-radius: 8px; overflow: hidden; }
	.profile-upload-card .upload-placeholder { display: flex; align-items: center; justify-content: center; height: 100%; }
	.profile-upload-card .upload-placeholder p { margin-bottom: 0; font-size: 16px; text-align: center; }
</style>
</head>

<body id="page-top">
	<div id="wrapper">
		<c:import url="/WEB-INF/views/temp/sidebar.jsp"></c:import>
		
		<div id="content-wrapper" class="d-flex flex-column">
		
			<div id="content">
			
				<c:import url="/WEB-INF/views/temp/topbar.jsp"></c:import>
					
				<!-- Begin Page Content -->
				<div class="container-fluid dm-fluid">

					<div class="chat-container">
						<div class="chat-header">
							<span class="user_nickname">마이페이지</span>
						</div>

						<div class="chat-messages">
				<form:form method="post" modelAttribute="memberDTO" enctype="multipart/form-data">
						  
	                  		
						  <div class="form-group">
						    <label for="name">이름</label>
						    <form:input path="userNickname" cssClass="form-control" id="userNickname"/>
							<form:errors path="userNickname"></form:errors>
							<!-- <span id="nameError" ></span> -->
						  </div>
	
						  
						  <div class="form-group">
						    <label for="email">이메일</label>
						    <form:input path="userEmail" cssClass="form-control" id="userEmail"/>
						    <form:errors path="userEmail"></form:errors>
						    <!-- <span id="emailError"></span> -->
						  </div>
						  
													<div class="form-group">
														<label for="userBirth">생일</label>
														<input type="date" name="userBirth" id="userBirth" class="form-control" value="${userBirthStr}" />
														<form:errors path="userBirth"></form:errors>
													</div>
						  
											  <div class="form-group">
											  	<label>첨부파일</label>
											  	<div class="card card-upload shadow-sm theme-post profile-upload-card">
													<div id="imagePreview">
														<div class="upload-placeholder" id="uploadPlaceholder" onclick="document.getElementById('attachInput').click()">
															<i class="fas fa-images"></i>
															<p>프로필 사진을 선택하세요</p>
														</div>
													</div>
													<input type="file" id="attachInput" name="attach" class="d-none" accept="image/*">
											  	</div>
											  </div>
						  
						  <button type="submit" class="btn btn-primary" id="btn">수정</button>
						  
								</form:form>
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
	<script>
		(function () {
			const attachInput = document.getElementById('attachInput');
			const imagePreview = document.getElementById('imagePreview');
			const uploadPlaceholder = document.getElementById('uploadPlaceholder');

			if (!attachInput || !imagePreview || !uploadPlaceholder) return;

			attachInput.addEventListener('change', function () {
				const file = this.files && this.files[0];
				if (!file) return;

				const objectUrl = URL.createObjectURL(file);
				uploadPlaceholder.style.display = 'none';
				imagePreview.innerHTML = '';

				const img = document.createElement('img');
				img.src = objectUrl;
				img.alt = 'preview';
				img.style.width = '100%';
				img.style.height = '100%';
				img.style.objectFit = 'cover';
				imagePreview.appendChild(img);
			});
		})();
	</script>
</body>
</html>
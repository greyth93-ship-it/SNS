<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<style>
	/* 사이드바 모던 UI 커스텀 스타일 */
	.sidebar-light .nav-item .nav-link {
		color: #333 !important;
		padding: 12px 20px;
		display: flex;
		align-items: center;
	}
	.sidebar-light .nav-item .nav-link:hover {
		background-color: #f8f9fa;
		border-radius: 8px;
		margin: 0 10px;
		padding: 12px 10px;
	}
	.sidebar-light .nav-item .nav-link img {
		width: 26px;
		height: 26px;
		object-fit: contain;
	}
	.sidebar-light .nav-item .nav-link span {
		font-size: 16px;
		margin-left: 16px;
		font-weight: 500;
	}
	
	/* 사이드바 접혔을 때 (toggled) */
	.sidebar.toggled .nav-item .nav-link {
		justify-content: center;
		padding: 12px 0;
	}
	.sidebar.toggled .nav-item .nav-link:hover {
		margin: 0;
	}
	.sidebar.toggled .nav-item .nav-link span {
		display: none;
	}
	.sidebar.toggled .sidebar-brand-text {
		display: none;
	}
	
	/* 로고 영역 커스텀 */
	.sidebar-brand {
		padding: 30px 20px !important;
		justify-content: flex-start !important;
	}
	.sidebar.toggled .sidebar-brand {
		justify-content: center !important;
	}
</style>

<!-- Sidebar -->
<ul
	class="navbar-nav bg-white sidebar sidebar-light accordion border-right"
	id="accordionSidebar">

	<!-- Sidebar - Brand -->
	<a
		class="sidebar-brand d-flex align-items-center"
		href="/">
		<div class="sidebar-brand-icon">
			<img src="/img/undraw_profile_1.svg" alt="logo" style="width: 30px; height: 30px;">
		</div>
		<div class="sidebar-brand-text mx-3" style="color: #262626; font-size: 22px; font-weight: bold; font-family: 'cursive', sans-serif;">
			Instagram
		</div>
	</a>


	<!-- Nav Item - Dashboard -->
	<li class="nav-item"><a class="nav-link" href="/feed/list"> 
		<img src="/icon/home_default.svg" alt="홈"> 
		<span>홈</span></a></li>


	<!-- Nav Item - Pages Collapse Menu -->
	<li class="nav-item"><a class="nav-link collapsed" href="#"
		data-toggle="collapse" data-target="#collapseTwo" aria-expanded="true"
		aria-controls="collapseTwo"> 
		<img src="/icon/search_default.svg" alt="검색">
		<span>검색</span>
	</a>
		<div id="collapseTwo" class="collapse" aria-labelledby="headingTwo"
			data-parent="#accordionSidebar">
			<div class="bg-white py-2 collapse-inner rounded border">
				<a class="collapse-item" href="/post/search">포스트 검색</a> 
				<a class="collapse-item" href="/feed/userSearch">유저 검색</a>
			</div>
		</div></li>
	
	<li class="nav-item"><a class="nav-link collapsed" href="#"
		data-toggle="collapse" data-target="#collapseUtilities"
		aria-expanded="true" aria-controls="collapseUtilities"> 
		<img src="/icon/more.svg" alt="만들기">
		<span>만들기</span>
	</a>
		<div id="collapseUtilities" class="collapse"
			aria-labelledby="headingUtilities" data-parent="#accordionSidebar">
			<div class="bg-white py-2 collapse-inner rounded border">
				<h6 class="collapse-header">CREATE</h6>
				<button type="button" class="collapse-item btn btn-light w-100 mb-2" onclick="location.href='/post/create'">포스트 만들기</button>
				<button type="button" class="collapse-item btn btn-light w-100" onclick="location.href='/story/create'">스토리 추가</button>
			</div>
		</div></li>

    
    <!-- Nav Item - Alerts -->
    <li class="nav-item"><a class="nav-link" href="/push/allList"> 
		<img src="/icon/like_default.svg" alt="알림">
	    <span>알림</span></a></li>

    <!-- Nav Item - Tables -->
    <li class="nav-item"><a class="nav-link" href="/chat/list"> 
		<img src="/icon/chat_default.svg" alt="메시지">
	    <span>메시지</span></a></li>

	<sec:authorize access="isAuthenticated()">
		<li class="nav-item"><a class="nav-link" href="/member/mypage"> 
		<img src="/img/profile_default.png" alt="프로필" style="border-radius: 50%;">
	    <span>프로필</span></a></li>
	</sec:authorize>
	

	<!-- Sidebar Toggler (Sidebar) -->
	<div class="text-center d-none d-md-inline mt-4">
		<button class="rounded-circle border-0" id="sidebarToggle" style="background-color: #efefef;"></button>
	</div>

</ul>
<!-- End of Sidebar -->
 <sec:authorize access="isAuthenticated()">
	<script src="/js/topbar.js"></script>

	<script>
		// 2. 페이지 로드 시 알림 목록을 즉시 가져옵니다.
		document.addEventListener("DOMContentLoaded", function() {
			if (typeof loadAlarmList === "function") {
				loadAlarmList();
			}
		});
	</script>
</sec:authorize>
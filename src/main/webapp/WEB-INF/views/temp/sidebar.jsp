<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!-- Sidebar -->
<ul
	class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion"
	id="accordionSidebar">

	<!-- Sidebar - Brand -->
	<a
		class="sidebar-brand d-flex align-items-center justify-content-center"
		href="/">
		<div class="sidebar-brand-icon rotate-n-15">
			<i class="fas fa-laugh-wink"></i>
		</div>
		<div class="sidebar-brand-text mx-3">
			SB Admin <sup>2</sup>
		</div>
	</a>


	<!-- Nav Item - Dashboard -->
	<li class="nav-item"><a class="nav-link" href="/feed/list"> <i
			class="fas fa-fw fa-tachometer-alt"></i> <span>메인</span></a></li>


	<!-- Nav Item - Pages Collapse Menu -->
	<li class="nav-item"><a class="nav-link collapsed" href="#"
		data-toggle="collapse" data-target="#collapseTwo" aria-expanded="true"
		aria-controls="collapseTwo"> <i class="fas fa-fw fa-cog"></i> <span>검색</span>
	</a>
		<div id="collapseTwo" class="collapse" aria-labelledby="headingTwo"
			data-parent="#accordionSidebar">
			<div class="bg-white py-2 collapse-inner rounded">
				<a class="collapse-item" href="/post/search">포스트 검색</a> 
				<a class="collapse-item" href="/feed/userSearch">유저 검색</a>
			</div>
		</div></li>
	
	<li class="nav-item"><a class="nav-link collapsed" href="#"
		data-toggle="collapse" data-target="#collapseUtilities"
		aria-expanded="true" aria-controls="collapseUtilities"> <i
			class="fas fa-fw fa-wrench"></i> <span>만들기</span>
	</a>
		<div id="collapseUtilities" class="collapse"
			aria-labelledby="headingUtilities" data-parent="#accordionSidebar">
			<div class="bg-white py-2 collapse-inner rounded">
				<h6 class="collapse-header">CREATE</h6>
				<button type="button" class="collapse-item btn btn-light w-100 mb-2" onclick="location.href='/post/create'">포스트 만들기</button>
				<button type="button" class="collapse-item btn btn-light w-100" onclick="location.href='/story/create'">스토리 추가</button>
			</div>
		</div></li>

    
    <!-- Nav Item - Alerts -->
    <li class="nav-item"><a class="nav-link" href="/push/allList"> <i
	    class="fas fa-fw fa-bell"></i> <span>알림</span></a></li>

    <!-- Nav Item - Tables -->
    <li class="nav-item"><a class="nav-link" href="/chat/list"> <i
	    class="fas fa-fw fa-table"></i> <span>CHAT</span></a></li>

	<sec:authorize access="isAuthenticated()">
		<li class="nav-item"><a class="nav-link" href="/member/mypage"> <i
	    class="fas fa-fw fa-table"></i> <span>프로필</span></a></li>
	</sec:authorize>
	

	

	<!-- Sidebar Toggler (Sidebar) -->
	<div class="text-center d-none d-md-inline">
		<button class="rounded-circle border-0" id="sidebarToggle"></button>
	</div>

</ul>
<!-- End of Sidebar -->
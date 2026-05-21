<%--
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<style>
	/* 사이드바 모던 UI 커스텀 스타일 */
	.sidebar-light .nav-item .nav-link {
		color: #333 !important;
		padding: 12px 10px;
		margin: 0 10px;
		border-radius: 8px;
		display: flex;
		align-items: center;
		transition: background-color 0.2s;
	}
	.sidebar-light .nav-item .nav-link:hover {
		background-color: #f8f9fa;
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
		margin: 0 10px;
	}
	.sidebar.toggled .nav-item .nav-link:hover {
		background-color: #f8f9fa;
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

	/* 접힌 사이드바에서 하위 메뉴가 옆으로 삐져나오는 문제 방지 */
	.sidebar {
		overflow-x: hidden;
	}

	/* 사이드바 높이를 화면 전체로 유지하고 내부 스크롤 허용 */
	.sidebar {
		min-height: 100vh !important;
		height: 100vh;
		overflow-y: auto;
		-webkit-overflow-scrolling: touch;
	}

	/* 사이드바를 문서 흐름에서 분리하여 오버레이로 동작하게 함
	   - 다른 컨텐츠가 너비 변경으로 밀려나지 않음 */
	.sidebar {
		position: fixed !important;
		top: 0;
		left: 0;
		height: 100vh !important;
		z-index: 1040;
		box-shadow: 0 0 20px rgba(0,0,0,0.05);
		background-color: #fff;
	}

	/* 컨텐츠 래퍼가 사이드바의 너비로 인해 밀리지 않도록 보장 */
	#wrapper, #wrapper #content-wrapper, #content {
		margin-left: 0 !important;
	}

	/* 접힌 사이드바에 마우스 오버하면 자동으로 펼치기 */
	.sidebar.toggled {
		width: 6.5rem !important;
		transition: width 0.18s ease-in-out;
	}

	.sidebar.toggled:hover {
		width: 14rem !important;
		min-width: 14rem !important;
	}

	.sidebar.toggled .sidebar-brand-text {
		display: none;
	}

	.sidebar.toggled:hover .sidebar-brand-text {
		display: block !important;
		opacity: 1;
	}

	.sidebar.toggled .nav-item .nav-link span {
		display: none;
	}

	.sidebar.toggled:hover .nav-item .nav-link span {
		display: inline-block !important;
		margin-left: 16px;
	}

	/* 클릭 동작은 아래 JS에서 제어합니다 (hover 시에만 클릭으로 열리도록). */

	/* 접힌 상태에서 hover 시 하위 collapse 메뉴 보이기 */
	.sidebar.toggled .collapse,
	.sidebar.toggled .collapse-inner {
		display: none !important;
	}

	.sidebar.toggled:hover .collapse,
	.sidebar.toggled:hover .collapse-inner {
		display: block !important;
		position: relative !important;
		left: 0 !important;
		box-shadow: none !important;
	}

	.sidebar.toggled .nav-item .nav-link {
		text-align: center;
		padding: .75rem 1rem;
	}

	.sidebar.toggled:hover .nav-item .nav-link {
		text-align: left !important;
		padding: 1rem !important;
		width: 100% !important;
	}

	.sidebar .collapse {
		position: relative;
	}

	.sidebar .collapse-inner {
		white-space: nowrap;
		overflow: hidden;
	}

	/* 사이드바가 접혔을 때(작게 보일 때) 하위 collapse가 화면 밖으로 나오지 않도록 숨김 처리
	   단, Bootstrap이 추가하는 .show 클래스는 표시되도록 허용하여 클릭으로도 열리게 함 */
	.sidebar.toggled .collapse,
	.sidebar.toggled .collapse-inner,
	.sidebar.toggled .nav-item .collapse {
		display: none; /* not !important so .collapse.show can override */
	}

	/* 클릭으로 열리는 경우 (Bootstrap이 .show 추가)에는 오버레이로 표시 */
	.sidebar.toggled .collapse.show {
		display: block !important;
		position: absolute !important;
		left: 6.5rem !important;
		top: 0 !important;
		z-index: 1060 !important;
	}

	/* hover 시에는 서브메뉴를 자동으로 열지 않음 — 레이블만 보이게 함
	   서브메뉴는 클릭으로 열릴 때만 (.collapse.show) 표시됩니다 */
	.sidebar.toggled:hover .collapse,
	.sidebar.toggled:hover .collapse-inner {
		display: none !important;
	}

	/* 하지만 사용자가 클릭해서 .show 클래스가 붙은 경우는 hover 상태에서도 표시 */
	.sidebar.toggled:hover .collapse.show {
		display: block !important;
		position: relative !important;
		left: 0 !important;
		box-shadow: none !important;
	}

	.sidebar .nav-item .nav-link {
		overflow: hidden;
	}
</style>

<!-- Sidebar -->
<ul
	class="navbar-nav bg-white sidebar sidebar-light accordion border-right toggled"
	id="accordionSidebar">

	<!-- Sidebar - Brand -->
	<a
		class="sidebar-brand d-flex align-items-center"
		href="/">
		<div class="sidebar-brand-icon">
			<img src="/img/undraw_profile_1.svg" alt="logo" style="width: 30px; height: 30px;">
		</div>
	
	</a>


	<!-- Nav Item - Dashboard -->
	<li class="nav-item"><a class="nav-link" href="/feed/list"> 
		<img src="/icon/home_default.svg" alt="홈"> 
		<span>홈</span></a></li>


	<!-- Nav Item - Pages Collapse Menu -->
	<li class="nav-item"><a class="nav-link collapsed" href="#"
		data-toggle="collapse" data-target="#collapseTwo" aria-expanded="false"
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
		data-toggle="collapse" data-target="#collapseUtilities" aria-expanded="false"
		aria-controls="collapseUtilities"> 
		<img src="/icon/more.svg" alt="만들기">
		<span>만들기</span>
	</a>
		<div id="collapseUtilities" class="collapse" aria-labelledby="headingUtilities"
			data-parent="#accordionSidebar">
			<div class="bg-white py-2 collapse-inner rounded border">
				<a class="collapse-item" href="/post/create">포스트 만들기</a> 
				<a class="collapse-item" href="/story/create">스토리 추가</a>
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
		<sec:authentication property="principal" var="principal" />
		<li class="nav-item"><a class="nav-link" href="/member/mypage"> 
		<c:choose>
			<c:when test="${not empty principal.profileDTO and not empty principal.profileDTO.fileName}">
				<img src="/files/member/${principal.profileDTO.fileName}" alt="프로필" style="border-radius: 50%; object-fit: cover;">
			</c:when>
			<c:otherwise>
				<img src="/img/default_user.avif" alt="프로필" style="border-radius: 50%; object-fit: cover;">
			</c:otherwise>
		</c:choose>
	    <span>프로필</span></a></li>
	</sec:authorize>
	

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

<!-- Control collapse toggles: only toggle when sidebar is hovered (expanded) -->
<script>
document.querySelectorAll('.sidebar a[data-toggle="collapse"]').forEach(function(el){
	el.addEventListener('click', function(e){
		e.preventDefault();
		e.stopPropagation();
		var sidebar = document.querySelector('.sidebar');
		if(!sidebar) return;
		// require hover (expanded) to allow toggling when sidebar is in collapsed 'toggled' state
		if(sidebar.classList.contains('toggled') && !sidebar.matches(':hover')){
			return; // ignore click
		}
		var targetSelector = el.getAttribute('data-target') || el.getAttribute('href');
		if(!targetSelector) return;
		var target = document.querySelector(targetSelector);
		if(!target) return;
		// use jQuery collapse if available for smooth animation
		if(window.jQuery && typeof window.jQuery(target).collapse === 'function'){
			window.jQuery(target).collapse('toggle');
		} else {
			// fallback: toggle .show and aria-expanded
			var isOpen = target.classList.contains('show');
			if(isOpen){
				target.classList.remove('show');
				el.setAttribute('aria-expanded','false');
			} else {
				target.classList.add('show');
				el.setAttribute('aria-expanded','true');
			}
		}
	}, false);
});
</script>--%>
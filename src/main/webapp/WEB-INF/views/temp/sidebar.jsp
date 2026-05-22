<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<style>
    /* [기본 스타일] 사이드바 본체 자체의 내부 좌우 패딩을 제거해 비대칭 여백 방지 */
    .sidebar {
        padding-left: 0 !important;
        padding-right: 0 !important;
    }

    /* 사이드바 기본 모던 UI 스타일 (축소/확장 공통 구조 고정) */
    .sidebar-light .nav-item {
        width: 100% !important;
        margin-left: 0 !important;
        margin-right: 0 !important;
        margin-bottom: 2px !important; /* 아이템 간 상하 간격 축소 고정 */
    }
    
    /* 
       사이드바가 접히든 펼쳐지든 .nav-link의 정렬 기준과 내부 여백(패딩)을 완전히 통일합니다.
       왼쪽 패딩을 30px로 고정하여, 축소 상태(너비 5.5rem = 88px)에서 아이콘(28px)이 
       정확히 한가운데 정렬된 것처럼 배치되도록 계산된 값입니다.
    */
    .sidebar-light .nav-item .nav-link {
        color: #333 !important;
        padding-top: 10px !important;
        padding-bottom: 10px !important;
        padding-left: 30px !important;   /* 아이콘의 좌측 물리 좌표 고정 */
        padding-right: 0px !important;
        margin: 2px 0px !important;
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: flex-start !important; /* 항상 왼쪽 정렬 기준으로 고정 */
        position: relative;
        width: 100% !important;
        transition: background-color 0.2s;
    }
    .sidebar-light .nav-item .nav-link:hover {
        background-color: #f8f9fa;
    }
    .sidebar-light .nav-item .nav-link img {
        width: 28px;
        height: 28px;
        flex: 0 0 28px;
        object-fit: contain;
    }

    .sidebar-light .nav-item .nav-link .sidebar-alarm-badge {
        position: absolute;
        top: 4px;
        left: 46px;
        min-width: 18px;
        height: 18px;
        padding: 0 5px;
        border-radius: 999px;
        background: #e74a3b;
        color: #fff;
        font-size: 11px !important;
        font-weight: 700;
        line-height: 18px;
        text-align: center;
        display: none;
        z-index: 2;
        pointer-events: none;
        box-shadow: 0 1px 4px rgba(0,0,0,0.18);
    }
    
    /* 글씨는 아이콘 우측에 넉넉한 마진을 두고 자연스럽게 위치 */
    .sidebar-light .nav-item .nav-link span:not(.sidebar-alarm-badge) {
        font-size: 17px;
        font-weight: 600;
        margin-left: 16px; 
        white-space: nowrap;
        display: inline-block;
    }
    
    /* ================= 사이드바 접혔을 때 (toggled) ================= */
    .sidebar.toggled .nav-item .nav-link span {
        display: none !important; /* 접혔을 때는 글씨만 깔끔하게 숨김 */
    }
    .sidebar.toggled .nav-item .nav-link .sidebar-alarm-badge:not(:empty) {
        display: block !important;
    }
    .sidebar.toggled .sidebar-brand-text {
        display: none;
    }

    /* 
       마우스 오버(hover)로 확장될 때 
       패딩이나 정렬을 바꾸지 않으므로, 아이콘은 1px도 움직이지 않고 제자리에 고정됩니다.
    */
    .sidebar.toggled:hover .nav-item .nav-link {
        padding-left: 30px !important; /* 호버 시에도 아이콘 위치 절대 사수 */
    }
    .sidebar.toggled:hover .nav-item .nav-link span:not(.sidebar-alarm-badge) {
        display: inline-block !important; /* 확장되면서 글씨만 자연스럽게 등장 */
        font-size: 13px;
        font-weight: 700;
    }
    .sidebar.toggled:hover .sidebar-brand-text {
        display: block !important;
        opacity: 1;
    }

    .sidebar.toggled:hover .collapse-inner .collapse-item {
        font-size: 15px;
        font-weight: 600;
    }
    
    /* [수정] 로고 영역 커스텀 - 홈 아이콘과의 간격을 벌리기 위해 하단 패딩(30px -> 60px) 조정 */
    .sidebar-brand {
        padding-top: 30px !important;
        padding-bottom: 100px !important; /* 확장 시 아래 간격 대폭 증가 */
        padding-left: 29px !important;
        padding-right: 0px !important;
        justify-content: flex-start !important;
        width: 100% !important;
        margin: 0 !important;
    }
    .sidebar.toggled .sidebar-brand {
        padding-top: 25px !important;
        padding-bottom: 100px !important; /* 접혔을 때도 동일하게 간격 고정 */
        padding-left: 29px !important;
        padding-right: 0px !important;
    }

    /* 접힌 사이드바에서 하위 메뉴가 옆으로 삐져나오는 문제 방지 기본 설정 */
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

    /* 사이드바 고정 및 스타일 - 모든 테두리(border)와 그림자 제거 */
    .sidebar {
        position: fixed !important;
        top: 0;
        left: 0;
        height: 100vh !important;
        z-index: 1040;
        background-color: #fff;
        border-right: 0 !important; 
        box-shadow: none !important; 
    }

    /* 컨텐츠 래퍼가 사이드바 너비 때문에 밀리지 않도록 고정 */
    #wrapper, #wrapper #content-wrapper, #content {
        margin-left: 0 !important;
    }

    /* 접힌 사이드바에 마우스 오버 시 자동 확장 효과 너비 조절 */
    .sidebar.toggled {
        width: 5.5rem !important; 
        transition: width 0.18s ease-in-out;
    }
    .sidebar.toggled:hover {
        width: 13rem !important;
        min-width: 13rem !important;
    }

    .sidebar .nav-item .nav-link {
        overflow: hidden;
    }
    .sidebar .collapse {
        position: relative;
    }
    .sidebar .collapse-inner {
        white-space: nowrap;
        overflow: hidden;
    }

    /* ================= 하위 메뉴 제어 ================= */
    .sidebar.toggled .collapse {
        display: none;
    }
    .sidebar.toggled .collapse.show {
        display: block !important;
    }
    .sidebar.toggled:hover .collapse.show {
        display: block !important;
        position: relative !important;
        left: 0 !important;
        box-shadow: none !important;
        width: 100%;
    }
    .sidebar.toggled:not(:hover) .collapse.show {
        display: none !important;
    }
</style>

<!-- Sidebar -->
<ul class="navbar-nav bg-white sidebar sidebar-light accordion toggled" id="accordionSidebar">

    <!-- Sidebar - Brand -->
    <a class="sidebar-brand d-flex align-items-center" href="#">
        <div class="sidebar-brand-icon">
            <img src="/img/undraw_profile_1.svg" alt="logo" style="width: 30px; height: 30px;">
        </div>
    </a>

    <!-- Nav Item - Dashboard -->
    <li class="nav-item">
        <a class="nav-link" href="/feed/list"> 
            <img src="/icon/home_non.svg" alt="홈"> 
            <span>홈</span>
        </a>
    </li>

    <!-- Nav Item - Pages Collapse Menu (검색) -->
    <li class="nav-item">
        <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo"> 
            <img src="/icon/search_default.svg" alt="검색">
            <span>검색</span>
        </a>
        <div id="collapseTwo" class="collapse" aria-labelledby="headingTwo" data-parent="#accordionSidebar">
            <div class="bg-white py-2 collapse-inner rounded border">
                <a class="collapse-item" href="/post/search">게시물 검색</a> 
                <a class="collapse-item" href="/feed/userSearch">유저 검색</a>
            </div>
        </div>
    </li>
    
    <!-- Nav Item - Utilities Collapse Menu (만들기) -->
    <li class="nav-item">
        <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseOne" aria-expanded="false" aria-controls="collapseOne"> 
            <img src="/icon/feed.svg" alt="만들기">
            <span>만들기</span>
        </a>
        <div id="collapseOne" class="collapse" aria-labelledby="headingOne" data-parent="#accordionSidebar">
            <div class="bg-white py-2 collapse-inner rounded border">
                <a class="collapse-item" href="/post/create">게시물 만들기</a> 
                <a class="collapse-item" href="/story/create">스토리 추가</a>
            </div>
        </div>
    </li>
   
    <!-- Nav Item - Alerts -->
    <li class="nav-item">
        <a class="nav-link" href="/push/allList"> 
            <img src="/icon/like_default.svg" alt="알림">
            <span class="sidebar-alarm-badge" id="sidebar-alarm-count"></span>
            <span>알림</span>
        </a>
    </li>

    <!-- Nav Item - Tables -->
    <li class="nav-item">
        <a class="nav-link" href="/chat/list"> 
            <img src="/icon/chat_default.svg" alt="메시지">
            <span>메시지</span>
        </a>
    </li>

    <sec:authorize access="isAuthenticated()">
        <sec:authentication property="principal" var="principal" />
        <li class="nav-item">
           <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseUtilities" aria-expanded="false" aria-controls="collapseUtilities"> 
                <c:choose>
                    <c:when test="${not empty principal.profileDTO and not empty principal.profileDTO.fileName}">
                        <img src="/files/member/${principal.profileDTO.fileName}" alt="프로필" style="border-radius: 50%; object-fit: cover;">
                    </c:when>
                    <c:otherwise>
                        <img src="/img/default_user.avif" alt="프로필" style="border-radius: 50%; object-fit: cover;">
                    </c:otherwise>
                </c:choose>
                <span>프로필</span>
            </a>
            <div id="collapseUtilities" class="collapse" aria-labelledby="headingUtilities" data-parent="#accordionSidebar">
                <div class="bg-white py-2 collapse-inner rounded border">
                    <a class="collapse-item" href="/member/mypage">마이페이지</a> 
                    <a class="collapse-item" href="/member/logout">로그아웃</a>
                </div>
            </div>
        </li>
    </sec:authorize>
</ul>
<!-- End of Sidebar -->

<sec:authorize access="isAuthenticated()">
    <script src="/js/topbar.js"></script>

    <script>
        function loadSidebarAlarmCount() {
            const badge = document.getElementById('sidebar-alarm-count');
            if (!badge) return;

            fetch('/push/unreadCount', { credentials: 'same-origin' })
                .then(res => res.json())
                .then(data => {
                    const count = data && data.count ? parseInt(data.count, 10) : 0;
                    if (count > 0) {
                        badge.innerText = count;
                        badge.style.display = 'block';
                    } else {
                        badge.innerText = '';
                        badge.style.display = 'none';
                    }
                })
                .catch(err => console.error('사이드바 알림 카운트 로드 중 오류:', err));
        }

        document.addEventListener("DOMContentLoaded", function() {
            if (typeof loadAlarmList === "function") {
                loadAlarmList();
            }
            loadSidebarAlarmCount();
        });
    </script>
</sec:authorize>

<!-- Control collapse toggles -->
<script>
document.querySelectorAll('.sidebar a[data-toggle="collapse"]').forEach(function(el){
    el.addEventListener('click', function(e){
        e.preventDefault();
        e.stopPropagation();
        
        var sidebar = document.querySelector('.sidebar');
        if(!sidebar) return;
        
        var targetSelector = el.getAttribute('data-target') || el.getAttribute('href');
        if(!targetSelector) return;
        
        var target = document.querySelector(targetSelector);
        if(!target) return;
        
        if(window.jQuery && typeof window.jQuery(target).collapse === 'function'){
            window.jQuery(target).collapse('toggle');
        } else {
            var isOpen = target.classList.contains('show');
            if(isOpen){
                target.classList.remove('show');
                el.setAttribute('aria-expanded','false');
            } else {
                var openedCollapse = sidebar.querySelectorAll('.collapse.show');
                openedCollapse.forEach(function(openEl) {
                    if (openEl !== target) {
                        openEl.classList.remove('show');
                        var trigger = sidebar.querySelector('[data-target="#' + openEl.id + '"]');
                        if(trigger) trigger.setAttribute('aria-expanded', 'false');
                    }
                });

                target.classList.add('show');
                el.setAttribute('aria-expanded','true');
            }
        }
    }, false);
});
</script>
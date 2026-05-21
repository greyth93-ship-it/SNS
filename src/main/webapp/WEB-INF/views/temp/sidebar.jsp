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
        justify-content: flex-start;
        transition: background-color 0.2s;
    }
    .sidebar-light .nav-item .nav-link:hover {
        background-color: #f8f9fa;
    }
    .sidebar-light .nav-item .nav-link img {
        width: 26px;
        height: 26px;
        flex: 0 0 26px;
        object-fit: contain;
    }
    .sidebar-light .nav-item .nav-link span {
        font-size: 16px;
        margin-left: 16px;
        font-weight: 500;
    }
    
    /* 사이드바 접혔을 때 (toggled) 기본 세팅 */
    .sidebar.toggled .nav-item .nav-link {
        justify-content: flex-start;
        padding: 12px 10px;
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

    /* 사이드바를 고정(fixed) 레이어 형태로 띄움 */
    .sidebar {
        position: fixed !important;
        top: 0;
        left: 0;
        height: 100vh !important;
        z-index: 1040;
        box-shadow: 0 0 20px rgba(0,0,0,0.05);
        background-color: #fff;
    }

    /* 컨텐츠 래퍼가 사이드바 너비 때문에 밀리지 않도록 고정 */
    #wrapper, #wrapper #content-wrapper, #content {
        margin-left: 0 !important;
    }

    /* 접힌 사이드바에 마우스 오버 시 자동 확장 효과 */
    .sidebar.toggled {
        width: 6.5rem !important;
        transition: width 0.18s ease-in-out;
    }

    .sidebar.toggled:hover {
        width: 14rem !important;
        min-width: 14rem !important;
    }

    .sidebar.toggled:hover .sidebar-brand-text {
        display: block !important;
        opacity: 1;
    }

    .sidebar.toggled:hover .nav-item .nav-link span {
        display: inline-block !important;
        margin-left: 16px;
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

    /* ================= [수정 핵심] 하위 하이드/쇼 제어 규칙 충돌 해결 ================= */

    /* 1. 접힌 상태의 기본값은 하위 메뉴 숨김 */
    .sidebar.toggled .collapse {
        display: none;
    }

    /* 2. 클릭 또는 스크립트에 의해 .show가 붙으면 조건 불문하고 표시 */
    .sidebar.toggled .collapse.show {
        display: block !important;
    }

    /* 3. 마우스 호버하여 사이드바가 확장(14rem)되었을 때 열린 하위 메뉴 스타일 */
    .sidebar.toggled:hover .collapse.show {
        display: block !important;
        position: relative !important;
        left: 0 !important;
        box-shadow: none !important;
        width: 100%;
    }

    /* 4. 마우스 호버하지 않은 '좁은 아이콘 상태'에서 클릭했을 때 우측 오버레이로 메뉴 띄우기 */
    .sidebar.toggled:not(:hover) .collapse.show {
        display: block !important;
        position: absolute !important;
        left: 6.5rem !important; /* 접힌 사이드바 너비 바로 오른쪽에 밀착 */
        top: 0 !important;
        z-index: 1060 !important;
        min-width: 150px;
    }

    .sidebar.toggled .nav-item .nav-link {
        text-align: center;
        padding: .75rem 1rem;
    }

    .sidebar.toggled:hover .nav-item .nav-link {
        text-align: left !important;
        padding: 12px 10px !important;
        width: 100% !important;
    }
</style>

<!-- Sidebar -->
<ul class="navbar-nav bg-white sidebar sidebar-light accordion border-right toggled" id="accordionSidebar">

    <!-- Sidebar - Brand -->
    <a class="sidebar-brand d-flex align-items-center" href="/">
        <div class="sidebar-brand-icon">
            <img src="/img/undraw_profile_1.svg" alt="logo" style="width: 30px; height: 30px;">
        </div>
    </a>

    <!-- Nav Item - Dashboard -->
    <li class="nav-item">
        <a class="nav-link" href="/feed/list"> 
            <img src="/icon/home_default.svg" alt="홈"> 
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
                <a class="collapse-item" href="/post/search">포스트 검색</a> 
                <a class="collapse-item" href="/feed/userSearch">유저 검색</a>
            </div>
        </div>
    </li>
    
    <!-- Nav Item - Utilities Collapse Menu (만들기) -->
    <li class="nav-item">
        <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseUtilities" aria-expanded="false" aria-controls="collapseUtilities"> 
            <img src="/icon/more.svg" alt="만들기">
            <span>만들기</span>
        </a>
        <div id="collapseUtilities" class="collapse" aria-labelledby="headingUtilities" data-parent="#accordionSidebar">
            <div class="bg-white py-2 collapse-inner rounded border">
                <a class="collapse-item" href="/post/create">포스트 만들기</a> 
                <a class="collapse-item" href="/story/create">스토리 추가</a>
            </div>
        </div>
    </li>
   
    <!-- Nav Item - Alerts -->
    <li class="nav-item">
        <a class="nav-link" href="/push/allList"> 
            <img src="/icon/like_default.svg" alt="알림">
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
            <a class="nav-link" href="/member/mypage"> 
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
        </li>
    </sec:authorize>
</ul>
<!-- End of Sidebar -->

<sec:authorize access="isAuthenticated()">
    <script src="/js/topbar.js"></script>

    <script>
        // 페이지 로드 시 알림 목록을 즉시 가져옵니다.
        document.addEventListener("DOMContentLoaded", function() {
            if (typeof loadAlarmList === "function") {
                loadAlarmList();
            }
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
        
        // [수정] 사이드바가 좁아진 상태든 늘어난 상태든 클릭하면 무조건 하위 메뉴가 열리도록 
        // 기존에 존재하던 '호버 스킵 조건문(!sidebar.matches(:hover))'을 제거하여 클릭 반응성을 확보했습니다.
        
        // jQuery collapse가 로드되어 있으면 부드러운 애니메이션 사용
        if(window.jQuery && typeof window.jQuery(target).collapse === 'function'){
            window.jQuery(target).collapse('toggle');
        } else {
            // Native JS Fallback: .show 클래스 토글 및 접근성 제어
            var isOpen = target.classList.contains('show');
            if(isOpen){
                target.classList.remove('show');
                el.setAttribute('aria-expanded','false');
            } else {
                // 다른 서브메뉴가 열려있다면 닫아주기 (Accordion 기능 유지)
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
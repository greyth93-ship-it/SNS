<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<a class="scroll-to-top rounded" href="#page-top"> 
    <i class="fas fa-angle-up"></i>
</a>

<div class="modal fade" id="logoutModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Ready to Leave?</h5>
                <button class="close" type="button" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span>
                </button>
            </div>
            <div class="modal-body">Select "Logout" below if you are ready to end your current session.</div>
            <div class="modal-footer">
                <button class="btn btn-secondary" type="button" data-dismiss="modal">Cancel</button>
                <a class="btn btn-primary" href="/member/logout">Logout</a>
            </div>
        </div>
    </div>
</div>

<script src="/vendor/jquery/jquery.min.js"></script>
<script src="/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

<script src="/vendor/jquery-easing/jquery.easing.min.js"></script>

<script src="/js/sb-admin-2.min.js"></script>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script src="https://js.pusher.com/8.2.0/pusher.min.js"></script>

<sec:authorize access="isAuthenticated()">
    <script>
        (function() {
            var rawUserNo = "<sec:authentication property='principal.userNo' />";

            if (rawUserNo && rawUserNo !== "" && rawUserNo !== "anonymousUser") {
                try {
                    const pusher = new Pusher('ee4b5ef3d42390bab887', {
                        cluster: 'ap3'
                    });

                    const myChannelName = 'sns-alarm-' + rawUserNo;
                    const channel = pusher.subscribe(myChannelName);

                    // ✅ 2. 알림 발생 시 실행될 로직 수정
                    channel.bind('new-post', function(data) {
                        if (data.message) {
                            // 확인 버튼 없는 토스트 설정
                            const Toast = Swal.mixin({
                                toast: true,
                                position: 'top-end',      // 우측 상단
                                showConfirmButton: false, // 확인 버튼 숨김
                                timer: 3000,              // 3초 후 자동 소멸
                                timerProgressBar: true,   // 하단 진행바 표시
                                didOpen: (toast) => {
                                    toast.addEventListener('mouseenter', Swal.stopTimer)
                                    toast.addEventListener('mouseleave', Swal.resumeTimer)
                                }
                            });

                            // 토스트 띄우기
                            Toast.fire({
                                icon: 'info', // 정보 아이콘
                                title: '새로운 알림',
                                text: data.message
                            });
                            
                            // 상단바 목록 실시간 갱신
                            if (typeof loadAlarmList === "function") {
                                loadAlarmList();
                            }
                        }
                    });

                    pusher.connection.bind('connected', function() {
                        console.log('Pusher 연결 성공! (UserNo: ' + rawUserNo + ')');
                    });
                    
                } catch (err) {
                    console.error("Pusher 초기화 오류:", err);
                }
            }
        })();
    </script>
</sec:authorize>

<sec:authorize access="isAnonymous()">
    <script>
        console.log("로그인하지 않은 상태이므로 알림 구독을 생략합니다.");
    </script>
</sec:authorize>
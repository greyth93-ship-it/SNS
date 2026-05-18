function loadAlarmList() {
    const container = document.getElementById("alarm-items-container");
    const countBadge = document.getElementById("alarm-count");

    if (!container) return;

    fetch('/push/list') // 아까 만든 @GetMapping("/list") 경로
        .then(res => res.json())
        .then(data => {
            container.innerHTML = ""; // 기존 목록 초기화

            if (!data || data.length === 0) {
                container.innerHTML = '<a class="dropdown-item text-center small text-gray-500">새로운 알림이 없습니다.</a>';
                countBadge.style.display = "none";
                return;
            }

            // 1. 안 읽은 알림 개수 계산 및 배지 표시
            const isUnread = item => item.isRead === false || item.isRead === 'false' || item.isRead === 'N' || item.isRead === 0;
            const unreadCount = data.filter(isUnread).length;
            if (unreadCount > 0) {
                countBadge.innerText = unreadCount > 5 ? '5+' : unreadCount;
                countBadge.style.display = "block";
            } else {
                countBadge.style.display = "none";
            }

            // 2. 알림 아이템 생성 (최대 5개)
            data.forEach(item => {
                // 1. 읽음 상태 확인
                const unread = isUnread(item);

                // 2. 안 읽은 글은 진하게, 읽은 글은 흐리게 표시
                const itemStyle = unread ? "" : "opacity:0.6;";
                const dateStyle = unread ? "font-weight:700; color:#5a5c69;" : "font-weight:400; color:#858796;";
                const messageStyle = unread ? "font-weight:700; color:#212529;" : "font-weight:400; color:#858796;";

			    const alarmHtml = `
			        <a class="dropdown-item d-flex align-items-center" 
			           href="javascript:void(0);" 
                       style="${itemStyle}"
			           onclick="handleNotificationClick(${item.pushNo}, '/post/detail?postNo=${item.postNo}')">
			            <div class="mr-3">
			                <div class="icon-circle bg-primary">
			                    <i class="fas fa-bell text-white"></i>
			                </div>
			            </div>
                        <div>
                            <div class="small" style="${dateStyle}">${item.pushDate}</div>
                            <span style="${messageStyle}">${item.pushMsg}</span>
			            </div>
			        </a>
			    `;
			    container.insertAdjacentHTML('beforeend', alarmHtml);
			});
            // ✅ 읽음 처리 요청 및 이동 함수
            window.handleNotificationClick = function(pushNo, moveUrl) {
                // 1. 서버의 /push/read (또는 매핑된 경로)로 요청 보냄
                fetch('/push/read?pushNo=' + pushNo, {
                    method: 'POST'
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.status === "success") {
                            // 2. 읽음 처리 성공 시 해당 페이지로 이동
                            location.href = moveUrl;
                        } else {
                            console.error("읽음 처리 중 오류 발생");
                            location.href = moveUrl; // 실패해도 일단 이동은 시킴
                        }
                    })
                    .catch(err => {
                        console.error("네트워크 오류:", err);
                        location.href = moveUrl;
                    });
            }
        })
        .catch(err => console.error("알림 로드 중 오류:", err));
}
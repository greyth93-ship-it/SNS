// push.js 내부의 함수들을 수정합니다.

function getIconColor(type) {
    switch(type) {
        case 'LIKE': return 'bg-primary';    // 파란색
        case 'FOLLOW': return 'bg-warning';  // 노란색
        case 'CHAT': return 'bg-success';    // 초록색
        default: return 'bg-secondary';
    }
}

function getIconClass(type) {
    switch(type) {
        case 'LIKE': return 'fas fa-heart';
        case 'FOLLOW': return 'fas fa-user-plus';
        case 'CHAT': return 'fas fa-comments';
        default: return 'fas fa-bell';
    }
}

// 알림 목록 로드 시 호출되는 부분 (예시)
function loadAlarmList() {
    fetch('/push/list')
        .then(res => res.json())
        .then(data => {
            // ... (중략) ...
            data.forEach(item => {
                const alarmHtml = `
                    <a class="dropdown-item d-flex align-items-center" 
                       onclick="readAlarm('${item.pushNo}', '${getMoveUrl(item)}')" 
                       style="cursor:pointer; ${item.read ? 'opacity:0.6;' : ''}">
                        <div class="mr-3">
                            <div class="icon-circle ${getIconColor(item.pushType)}">
                                <i class="${getIconClass(item.pushType)} text-white"></i>
                            </div>
                        </div>
                        <div>
                            <div class="small text-gray-500">${formatDate(item.regDate)}</div>
                            <span class="${item.read ? '' : 'font-weight-bold'}">${item.pushMsg}</span>
                        </div>
                    </a>
                `;
                container.insertAdjacentHTML('beforeend', alarmHtml);
            });
        });
}

// 타입에 따라 이동할 페이지 결정
function getMoveUrl(item) {
    switch(item.pushType) {
        case 'LIKE': return '/post/detail?postNo=' + item.postNo;
        case 'FOLLOW': return '/member/profile?userNo=' + item.senderNo;
        case 'CHAT': return '/chat/room?roomNo=' + item.refNo; // 채팅방 번호 등
        default: return '#';
    }
}
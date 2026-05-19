function initMutualChatButtons() {
    // 1. 페이지 전체(body)에 클릭 이벤트 위임
    document.body.addEventListener('click', function (e) {
        // 클릭된 요소나 그 상위 요소 중 <button> 태그가 있는지 확인
        const btn = e.target.closest('button');
        
        // 버튼이 존재하고, 그 버튼의 텍스트가 '채팅'인지 확인
        if (btn && btn.classList.contains('btn-chat-trigger')) {
            e.preventDefault();
            e.stopPropagation();
            
            // 클릭 시점에 안전하게 다시 한 번 데이터를 읽어옵니다.
            const currentUserNo = document.body.dataset.currentUserNo || '';
            const userNo = btn.dataset.userNo || '';
            
            console.log('--- 전송 데이터 최종 확인 ---');
            console.log('나(currentUserNo):', currentUserNo);
            console.log('상대(userNo):', userNo);
            
            // 2. 주소 조립 및 이동 (변수가 비어있어도 에러 안 나게 처리)
            let targetUrl = '/chat/create';
            
            if (userNo && currentUserNo) {
                targetUrl += '?targetUserNo=' + userNo
            }
            
            // 최종 조립된 주소로 이동
            window.location.href = targetUrl;
        }
    });
}

// 3. DOM 로딩 상태와 관계없이 안전하게 실행되도록 등록
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initMutualChatButtons);
} else {
    initMutualChatButtons();
}
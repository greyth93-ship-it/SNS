// =====================
// 공통 변수 및 페이징 상태 관리
// =====================
const roomNo = document.getElementById("chatForm").dataset.roomNo;
const messageArea = document.getElementById("messageArea");
const chatForm = document.getElementById("chatForm");

let currentPage = 1;      // 현재 불러온 페이지 번호
let isLoading = false;    // 중복 요청 방지 플래그
let isLastPage = false;   // 더 이상 불러올 과거 메시지가 없는지 확인하는 플래그

// =====================
// 1. 메시지 조회 (GET) - 무한 스크롤 적용
// =====================
function loadMessages(page = 1, isScrollLoad = false) {
    if (isLoading || (isScrollLoad && isLastPage)) return;
    
    isLoading = true;
    console.log(`[요청] ${page} 페이지 데이터 가져오는 중...`);

    fetch(`/chat/message?roomNo=${roomNo}&page=${page}`)
        .then(res => res.json())
        .then(data => {
            // ⭐ [디버깅] 서버에서 넘어오는 데이터 구조를 콘솔창(F12)에서 직접 확인하세요.
            console.log("[서버 응답 데이터]:", data);

            // 💡 만약 자바 Map에서 담은 key 이름이 다르면 여기를 수정해야 합니다 (예: data.list 등)
            const messageList = data.messages || data.list; 

            // 더 이상 가져올 메시지가 없거나 빈 배열인 경우
            if (!messageList || messageList.length === 0) {
                console.log("더 이상 불러올 과거 메시지가 없습니다.");
                isLastPage = true;
                isLoading = false;
                return;
            }

            // 스크롤 위치 유지를 위한 기존 높이 기억
            const previousHeight = messageArea.scrollHeight;
            let htmlChunks = [];

            messageList.forEach(msg => {
                const isMe = (msg.userNo == MY_USER_NO);
                let timeStr = msg.messageDate ? msg.messageDate.substring(11, 16) : "";

                let html = isMe ? `
                    <div class="message my-msg">
                        <div class="msg-box">
                            <div class="msg-content">${msg.messageContent}</div>
                            <div class="msg-info">${timeStr}</div>
                        </div>
                    </div>` 
                : `
                    <div class="message other-msg">
                        <div class="msg-profile-wrap">
                            <img class="img-profile rounded-circle" src="${TARGET_PROFILE ? ('/files/member/' + TARGET_PROFILE) : '/img/default_user.avif'}" style="width:30px; height:30px;">
                            <span class="msg-nickname">${TARGET_NICKNAME}</span>
                        </div>
                        <div class="msg-box">
                            <div class="msg-content">${msg.messageContent}</div>
                            <div class="msg-info">${timeStr}</div>
                        </div>
                    </div>`;
                
                htmlChunks.push(html);
            });

            const finalHtml = htmlChunks.join("");

            if (isScrollLoad) {
                // 💡 과거 내역 불러오기: 최상단(위)에 붙이기
                messageArea.insertAdjacentHTML("afterbegin", finalHtml);
                // 스크롤 튐 방지 계산
                messageArea.scrollTop = messageArea.scrollHeight - previousHeight;
                console.log(`[성공] 과거 데이터 ${page}페이지 삽입 완료`);
            } else {
                // 💡 최초 로딩 또는 방금 내가 보낸 메시지: 전체 다시 깔고 맨 아래로
                messageArea.innerHTML = finalHtml;
                messageArea.scrollTop = messageArea.scrollHeight;
            }

            currentPage = page;
            isLoading = false;
        })
        .catch(err => {
            console.error("메시지 로딩 실패:", err);
            isLoading = false;
        });
}

// =====================
// 2. 무한 스크롤 이벤트 감지
// =====================
messageArea.addEventListener("scroll", () => {
    // [확인용 콘솔] 스크롤할 때 이 로그가 찍히는지 보세요! 안 찍히면 1단계 CSS 문제입니다.
    // console.log("현재 스크롤 위치(scrollTop):", messageArea.scrollTop);

    // 스크롤 바가 맨 위(0)에 닿았을 때 과거 데이터(다음 페이지) 가져오기
    if (messageArea.scrollTop === 0) {
        console.log("스크롤이 최상단에 닿았습니다. 다음 페이지를 요청합니다.");
        loadMessages(currentPage + 1, true);
    }
});

// =====================
// 3. 메시지 전송 (POST)
// =====================
chatForm.addEventListener("submit", function(event) {
    event.preventDefault(); 

    const input = document.getElementById("messageContent");
    const content = input.value.trim();
    if (!content) return;

    const tokenMeta = document.querySelector('meta[name="_csrf"]');
    const headerMeta = document.querySelector('meta[name="_csrf_header"]');
    const headers = { "Content-Type": "application/x-www-form-urlencoded" };

    if (tokenMeta && headerMeta) {
        const headerName = headerMeta.getAttribute('content');
        const tokenValue = tokenMeta.getAttribute('content');
        if (headerName && tokenValue) {
            headers[headerName] = tokenValue;
        }
    }

    fetch("/chat/create", {
        method: "POST",
        headers: headers,
        body: new URLSearchParams({
            roomNo: roomNo,
            messageContent: content
        })
    })
    .then(res => res.json())
    .then(result => {
        if (result > 0) {
            input.value = "";
            currentPage = 1;
            isLastPage = false;
            loadMessages(1, false);
            input.focus();
        } else {
            alert("메시지 전송에 실패했습니다.");
        }
    })
    .catch(err => console.error("메시지 전송 에러:", err));
});

// =====================
// 4. 최초 실행
// =====================
window.onload = function () {
    loadMessages(1, false);
};
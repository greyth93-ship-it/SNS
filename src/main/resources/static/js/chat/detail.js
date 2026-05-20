

// =====================
// 공통 변수
// =====================
const roomNo = document.getElementById("chatForm").dataset.roomNo;
const messageArea = document.getElementById("messageArea");
const chatForm = document.getElementById("chatForm")

// =====================
// 1. 메시지 조회 (GET) 및 동적 레이아웃 생성
// =====================
function loadMessages(page = 1) {
    fetch(`/chat/message?roomNo=${roomNo}&page=${page}`)
        .then(res => res.json())
        .then(data => {
            messageArea.innerHTML = "";

            // 메시지가 역순으로 배치되어 있다면 필요에 따라 .reverse()를 붙이세요. 
            // 현재 Mapper는 ASC 정렬이므로 그대로 사용합니다.
            data.messages.forEach(msg => {
                const isMe = (msg.userNo == MY_USER_NO);
                
                // 시간 데이터가 있을 경우 HH:mm 포맷으로 자르기 (JSP fn:substring 대체)
                let timeStr = "";
                if (msg.messageDate) {
                    timeStr = msg.messageDate.substring(11, 16); 
                }

                let html = "";
                if (isMe) {
                    // 내가 보낸 메시지 폼
                    html = `
                        <div class="message my-msg">
                            <div class="msg-box">
                                <div class="msg-content">${msg.messageContent}</div>
                                <div class="msg-info">${timeStr}</div>
                            </div>
                        </div>`;
                } else {
                    // 상대방이 보낸 메시지 폼
                    html = `
                        <div class="message other-msg">
                            <div class="msg-profile-wrap">
                                <img class="img-profile rounded-circle" src="/files/member/${TARGET_PROFILE || 'default.png'}" style="width:30px; height:30px;">
                                <span class="msg-nickname">${TARGET_NICKNAME}</span>
                            </div>
                            <div class="msg-box">
                                <div class="msg-content">${msg.messageContent}</div>
                                <div class="msg-info">${timeStr}</div>
                            </div>
                        </div>`;
                }

                messageArea.insertAdjacentHTML("beforeend", html);
            });

            // 스크롤을 맨 아래로 이동
            messageArea.scrollTop = messageArea.scrollHeight;
        })
        .catch(err => console.error("메시지 로딩 실패:", err));
}

// =====================
// 2. 메시지 전송 (POST)
// =====================
chatForm.addEventListener("click", function(event) {
    // 1. 브라우저의 기존 submit 행동(페이지 새로고침)을 완전히 막음
    event.preventDefault(); 

    const input = document.getElementById("messageContent");
    const content = input.value.trim();

    // 빈 문자열이면 전송 안 함
    if (!content) return;

	const tokenMeta = document.querySelector('meta[name="_csrf"]');
	const headerMeta = document.querySelector('meta[name="_csrf_header"]');
	const headers = { "Content-Type": "application/x-www-form-urlencoded" };

	if (tokenMeta && headerMeta) {
	    const headerName = headerMeta.getAttribute('content');
	    const tokenValue = tokenMeta.getAttribute('content');

	    // 💡 이름과 값이 모두 정상적으로 존재할 때만 헤더에 추가 (Invalid name 방어)
	    if (headerName && tokenValue) {
	        headers[headerName] = tokenValue;
	    } else {
	        console.warn("CSRF 메타 태그의 content 값이 비어있습니다. Security 설정을 확인하세요.");
	    }
	}

    // 비동기 전송 시작
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
            // 메시지 성공 시 입력창 비우고 다시 그리기
            input.value = "";
            loadMessages();
            input.focus();
        } else {
            alert("메시지 전송에 실패했습니다.");
        }
    })
    .catch(err => console.error("메시지 전송 에러:", err));
});

// =====================
// 3. 최초 실행
// =====================
window.onload = function () {
    loadMessages();
};




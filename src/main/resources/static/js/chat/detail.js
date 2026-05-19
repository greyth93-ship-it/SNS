

// =====================
// 공통 변수
// =====================
const roomNo = document.getElementById("chatForm").dataset.roomNo;
const messageArea = document.getElementById("messageArea");


// =====================
// 1. 메시지 조회 (GET)
// =====================
function loadMessages(page = 1) {

    fetch(`/chat/message?roomNo=${roomNo}&page=${page}`)
        .then(res => res.json())
        .then(data => {

            messageArea.innerHTML = "";

            data.messages.forEach(msg => {

                const html =
                    `<div class="message">
                        <div>${msg.messageContent}</div>
                    </div>`;

                messageArea.insertAdjacentHTML("beforeend", html);
            });

            messageArea.scrollTop = messageArea.scrollHeight;
        });
}


// =====================
// 2. 메시지 전송 (POST)
// =====================
function sendMessage(event) {
    event.preventDefault();

    const input = document.getElementById("messageContent");
    const content = input.value.trim();

    if (!content) return;

    fetch("/chat/create", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: new URLSearchParams({
            roomNo: roomNo,
            messageContent: content
        })
    })
    .then(res => res.json())
    .then(result => {

        if (result > 0) {
            // 서버 기준 다시 그림 (중요)
            loadMessages();

            input.value = "";
        }
    });
}


// =====================
// 3. 최초 실행
// =====================
window.onload = function () {
    loadMessages();
};





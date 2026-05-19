let page = 1;
let loading = false;
let hasMore = true;

function loadMessages(roomNo, page) {

    if (loading || !hasMore) return;

    loading = true;

    fetch(`/chat/message?roomNo=${roomNo}&page=${page}`)
        .then(res => res.json())
        .then(data => {

            const messages = data.messages;

            if (messages.length === 0) {
                hasMore = false;
                return;
            }

            const messageArea = document.getElementById("messageArea");

            // 👇 기존 메시지 위에 추가 (중요)
            messages.forEach(msg => {
                const html =
                    `<div class="message">
                        <div class="msg-content">${msg.messageContent}</div>
                        <div class="msg-time">${msg.messageDate}</div>
                    </div>`;

                messageArea.insertAdjacentHTML("afterbegin", html);
            });

            page++;

        })
        .finally(() => {
            loading = false;
        });
}		
window.onload = function () {
		    loadMessages(roomNo, page);
		};
		const messageArea = document.getElementById("messageArea");

		messageArea.addEventListener("scroll", function () {

		    // 위로 거의 도달했을 때
		    if (messageArea.scrollTop === 0) {

		        const prevHeight = messageArea.scrollHeight;

		        loadMessages(roomNo, page);

		        // 스크롤 위치 유지 (깜빡임 방지)
		        setTimeout(() => {
		            messageArea.scrollTop =
		                messageArea.scrollHeight - prevHeight;
		        }, 100);
		    }
		});
		
		function appendMyMessage(content) {

		    const messageArea = document.getElementById("messageArea");

		    const html =
		        `<div class="message my-msg">
		            <div class="msg-content">${content}</div>
		            <div class="msg-time">now</div>
		        </div>`;

		    messageArea.insertAdjacentHTML("beforeend", html);

		    // 아래로 스크롤 유지
		    messageArea.scrollTop = messageArea.scrollHeight;
		}
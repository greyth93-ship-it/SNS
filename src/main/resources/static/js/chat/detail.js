

function sendMessage(event) { // 1. 기본 form 제출 기능(새로고침)을 중지시킵니다. 
event.preventDefault();

const messageInput = document.getElementById("messageContent");
const messageContent = messageInput.value.trim(); const chatForm = document.getElementById("chatForm") 
const roomNo = chatForm.dataset.roomNo;

if (messageContent === "") return;

fetch(`/chat/create`, { 
	method: "POST", 
	body: new URLSearchParams({ 
		"roomNo":roomNo, 
		"messageContent": messageContent
	}) 
}) 
	.then(r=> r.json()) 
	.then(r => { console.log(r) 
		if (r > 0) {
			appendMyMessage(messageContent);
			messageInput.value = ""; messageInput.focus(); 
		} 
			else { alert("메시지 전송에 실패했습니다."); 
				
			} 
		}) .catch(error => console.error("Error:", error)); 
}

function appendMyMessage(content) { 
	const messageArea = document.getElementById("messageArea");
	const now = new Date(); 
	const timeString = now.getHours().toString().padStart(2, "0") + ":" + now.getMinutes().toString().padStart(2, "0");
	const messageHtml = 
	'<div class="message my-msg">' + 
	' <div class="msg-content">' + 
	content + 
	'</div>' + 
	' <div class="msg-info">' + 
	timeString + 
	'</div>' + 
	'</div>';

	messageArea.insertAdjacentHTML("beforeend", messageHtml);
	messageArea.scrollTop = messageArea.scrollHeight; 
}





function loadMessages(roomNo, page) {

    fetch(`/chat/message?roomNo=${roomNo}&page=${page}`)
        .then(res => res.json())
        .then(data => {

            const messageArea = document.getElementById("messageArea");
            messageArea.innerHTML = "";

            data.messages.forEach(msg => {

                const html =
                    `<div class="message">
                        <div>${msg.messageContent}</div>
                    </div>`;

                messageArea.insertAdjacentHTML("beforeend", html);
            });
        });
}



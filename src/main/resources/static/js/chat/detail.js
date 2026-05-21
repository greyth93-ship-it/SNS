// =====================
// 공통 변수 및 페이징 상태 관리
// =====================
const roomNo = document.getElementById("chatForm").dataset.roomNo;
const messageArea = document.getElementById("messageArea");
const chatForm = document.getElementById("chatForm");

let currentPage = 1;      // 현재 표시 중인 페이지 번호
let totalPages = 1;       // 전체 페이지 수
let isLoading = false;    // 중복 요청 방지 플래그
let isInitialized = false; // 초기화 완료 플래그
let scrollEventEnabled = false; // 초기 로드 후 scroll 이벤트 활성화
let ignoreNextScroll = false; // 프로그램적 스크롤 이벤트 무시 플래그

// =====================
// 0. 유틸리티 함수
// =====================
function calculateTotalPages(totalCount) {
    const perPage = 10;
    if (!totalCount || totalCount <= 0) return 1;
    return Math.ceil(totalCount / perPage);
}

function updateTotalPages(pager) {
    if (pager && pager.totalCount !== undefined && pager.totalCount !== null) {
        const oldTotalPages = totalPages;
        totalPages = calculateTotalPages(pager.totalCount);
        console.log(`[✓ totalPages 업데이트] 이전: ${oldTotalPages} → 현재: ${totalPages} (totalCount: ${pager.totalCount})`);
        return totalPages;
    }
    return totalPages;
}

// =====================
// 1. 메시지 조회 (GET) - 무한 스크롤 적용
// =====================
function loadMessages(page = 1, direction = 'init') {
    // direction: 'init' (초기 로드), 'up' (위로 스크롤 = 과거), 'down' (아래로 스크롤 = 최신)
    
    if (isLoading) {
        console.log(`⚠️ 이미 로딩 중입니다. 중복 요청 방지`);
        return;
    }
    
    console.log(`\n[요청 시작] page=${page}, direction=${direction}, currentPage=${currentPage}, totalPages=${totalPages}`);
    
    isLoading = true;

    fetch(`/chat/message?roomNo=${roomNo}&page=${page}`)
        .then(res => res.json())
        .then(data => {
            console.log("[✓ 서버 응답]", data);
            
            const messageList = data.messages || data.list;
            const pager = data.pager;

            // 매 호출마다 totalPages 업데이트 (중요!)
            if (pager) {
                updateTotalPages(pager);
            }

            // 페이지 범위 재검증
            if (page < 1 || page > totalPages) {
                console.log(`⚠️ 페이지 범위 초과 (${page} > ${totalPages}) - 요청 취소`);
                isLoading = false;
                return;
            }

            // 더 이상 가져올 메시지가 없거나 빈 배열인 경우
            if (!messageList || messageList.length === 0) {
                console.log("⚠️ 메시지 없음");
                isLoading = false;
                return;
            }

            // 초기 로드 시: 마지막 페이지에 메시지가 perPage보다 적으면 이전 페이지 일부를 가져와 최신 perPage개 채우기
            const perPage = 10;
            if (direction === 'init' && messageList.length < perPage && page > 1) {
                const need = perPage - messageList.length;
                // 이전 페이지를 요청하여 부족한 개수만큼 채움
                fetch(`/chat/message?roomNo=${roomNo}&page=${page-1}`)
                    .then(res2 => res2.json())
                    .then(data2 => {
                        const prevList = data2.messages || data2.list || [];
                        // prevList는 오래된->최근 순이므로 뒤에서 필요한 개수만큼 잘라서 앞에 붙임
                        const sliceStart = Math.max(0, prevList.length - need);
                        const neededPrev = prevList.slice(sliceStart);

                        // 결합된 리스트: 필요한 이전 메시지 + 현재 페이지 메시지
                        const combined = neededPrev.concat(messageList);

                        renderMessages(combined, 'init');
                        currentPage = page; // 현재는 마지막 페이지
                        isLoading = false;
                    })
                    .catch(err2 => {
                        console.error('이전 페이지 로드 실패:', err2);
                        // 실패 시 현재 페이지만 표시
                        renderMessages(messageList, 'init');
                        currentPage = page;
                        isLoading = false;
                    });

                return; // 중복 렌더링 방지
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

            if (direction === 'up') {
                // 위로 스크롤: 과거 메시지를 최상단에 추가
                messageArea.insertAdjacentHTML("afterbegin", finalHtml);
                messageArea.scrollTop = messageArea.scrollHeight - previousHeight;
                console.log(`[✓ 완료] 과거 페이지 ${page} 추가, 스크롤 ${messageArea.scrollHeight - previousHeight}px 조정`);
            } else if (direction === 'down') {
                // 아래로 스크롤: 최신 메시지를 최하단에 추가
                messageArea.insertAdjacentHTML("beforeend", finalHtml);
                console.log(`[✓ 완료] 최신 페이지 ${page} 추가`);
            } else {
                // 초기 로딩: 새로 로드 (renderMessages를 통해 처리)
                renderMessages(messageList, 'init');
            }

            currentPage = page;
            isLoading = false;
        })
        .catch(err => {
            console.error("❌ 메시지 로딩 실패:", err);
            isLoading = false;
        });
}

// =====================
// 2. 무한 스크롤 이벤트 감지 (양방향)
// =====================
messageArea.addEventListener("scroll", () => {
    // 초기 로드 완료 전에는 이벤트 무시
    if (!scrollEventEnabled) return;
    
    // 스크롤 가능한 상태 확인 (overflow가 있는지)
    const hasScroll = messageArea.scrollHeight > messageArea.clientHeight;
    if (!hasScroll) {
        return; // 스크롤이 없으면 이벤트 무시
    }

    // 프로그램적(자동)으로 발생한 첫 스크롤 이벤트는 무시
    if (ignoreNextScroll) {
        ignoreNextScroll = false;
        console.log('[스크롤] 자동 발생 이벤트 무시');
        return;
    }

    console.log(`[스크롤] scrollTop: ${messageArea.scrollTop}, 페이지: ${currentPage}/${totalPages}`);

    // 스크롤 바가 맨 위(0 근처)에 닿았을 때 과거 데이터(이전 페이지) 가져오기
    if (messageArea.scrollTop <= 5 && currentPage > 1) {
        console.log("✅ 위로 스크롤: 이전 페이지(더 과거) 요청");
        loadMessages(currentPage - 1, 'up');
    }
    // 아래로 스크롤 시에는 페이지 변경 없음 (벽 역할)
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
            // 메시지 전송 성공 후 새 메시지 확인 위해 다시 초기화
            console.log("[메시지 전송 완료] 채팅창 갱신 중...");
            isInitialized = false;
            initializeChat();
            input.focus();
        } else {
            alert("메시지 전송에 실패했습니다.");
        }
    })
    .catch(err => console.error("메시지 전송 에러:", err));
});

// =====================
// 4. 초기화 함수
// =====================
function initializeChat() {
    if (isInitialized) {
        console.log("⚠️ 이미 초기화 완료됨 - 중복 실행 방지");
        return;
    }
    
    console.log("\n🔄 === 채팅 초기화 시작 ===\n");
    isInitialized = true;
    
    // 페이지 1을 요청하여 totalCount 확인
    console.log(`📡 페이지 1 요청 → totalCount 확인`);
    fetch(`/chat/message?roomNo=${roomNo}&page=1`)
        .then(res => res.json())
        .then(data => {
            console.log("[✓ 서버 응답]", data);
            
            const pager = data.pager;
            if (!pager) {
                console.warn("⚠️ pager 정보 없음!");
                isLoading = false;
                return;
            }
            
            console.log(`[✓] pager.totalCount = ${pager.totalCount}`);
            
            // totalPages 계산
            const newTotalPages = calculateTotalPages(pager.totalCount);
            console.log(`[✓] 계산: totalPages = Math.ceil(${pager.totalCount} / 10) = ${newTotalPages}`);
            totalPages = newTotalPages;
            
            // 마지막 페이지부터 로드 (최신 메시지)
            console.log(`\n📡 마지막 페이지(${totalPages}) 요청 → 최신 메시지 로드`);
            currentPage = totalPages;
            loadMessages(totalPages, 'init');
        })
        .catch(err => {
            console.error("[✗] 초기 요청 실패:", err);
            isLoading = false;
            isInitialized = false; // 재시도 가능하도록 플래그 해제
        });
}

// =====================
// 4-1. 최초 실행 - 가능한 빨리 초기화
// =====================
// 문서 로드 확인 후 즉시 초기화
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function() {
        console.log("[✓] DOMContentLoaded 이벤트 발생");
        initializeChat();
    });
} else {
    console.log("[✓] 문서 이미 로드됨");
    initializeChat();
}

// =====================
// 메시지 렌더링 유틸
// =====================
function renderMessages(list, mode) {
    // mode: 'init'|'up'|'down'
    const previousHeight = messageArea.scrollHeight;
    let htmlChunks = [];

    list.forEach(msg => {
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

    if (mode === 'up') {
        messageArea.insertAdjacentHTML("afterbegin", finalHtml);
        messageArea.scrollTop = messageArea.scrollHeight - previousHeight;
    } else if (mode === 'down') {
        messageArea.insertAdjacentHTML("beforeend", finalHtml);
        messageArea.scrollTop = messageArea.scrollHeight;
    } else {
        // init
        scrollEventEnabled = false;
        ignoreNextScroll = true;
        messageArea.innerHTML = finalHtml;
        messageArea.scrollTop = messageArea.scrollHeight;
        setTimeout(() => {
            scrollEventEnabled = true;
            console.log(`[✓ 완료] 초기 로드 메시지 렌더링 완료, 스크롤 이벤트 활성화`);
        }, 100);
    }
}
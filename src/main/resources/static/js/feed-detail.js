const detailModal = document.getElementById('detailModal');
const shareModal = document.getElementById('shareModal');
const standaloneMode = !detailModal;
const mImageArea = document.getElementById('mImage');
const mInfoArea = document.getElementById('mInfo');
const mOwner = document.getElementById('mOwner');
const mLocation = document.getElementById('mLocation');
const mContent = document.getElementById('mContent');
let postSlideIndex = 0;
let postSlideCount = 0;
let storySlideIndex = 0;
let storySlideCount = 0;
let storyUserOrder = [];
let currentStoryUserNo = null;

// 안전한 HTML 이스케이프 (텍스트를 innerHTML로 넣을 때 사용)
function escapeHtml(str) {
    return String(str)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;');
}

function getCurrentUserNo(feedData = {}) {
    const metaCurrentUserNo = document.querySelector('meta[name="current-user-no"]')?.content ?? null;
    const rawCurrentUserNo = feedData.currentUserNo ?? metaCurrentUserNo ?? document.body?.dataset?.currentUserNo ?? null;

    if (rawCurrentUserNo == null || rawCurrentUserNo === '' || rawCurrentUserNo === 'anonymousUser') {
        return null;
    }

    return rawCurrentUserNo;
}

function getStoryOwnerNo(feedData = {}) {
    return feedData.memberDTO?.userNo ?? feedData.userNo ?? null;
}

function isOwnStory(feedData = {}) {
    const currentUserNo = getCurrentUserNo(feedData);
    const ownerUserNo = getStoryOwnerNo(feedData);

    if (currentUserNo == null || ownerUserNo == null) {
        return false;
    }

    return String(currentUserNo).trim() === String(ownerUserNo).trim();
}

function getCommentList(feedNo) {
    const listArea = document.getElementById("comment_display_list");
    if (!listArea) return;

    fetch(`/comment/list?feedNo=${feedNo}`)
        .then(r => r.text())
        .then(r => {
            listArea.innerHTML = r.trim();
        })
        .catch(e => console.error("댓글 로딩 실패:", e));
}

function applyThumbState(button, likedByMe, thumbCount) {
    if (!button) return;

    const icon = button.querySelector('i');
    if (icon) {
        icon.classList.toggle('fas', !!likedByMe);
        icon.classList.toggle('far', !likedByMe);
    }

    const countArea = button.querySelector('.like-count');
    if (countArea) {
        countArea.textContent = thumbCount ?? 0;
    }
}

function syncListThumbState(feedNo, likedByMe, thumbCount) {
    const cards = document.querySelectorAll(`.post-card[data-feed-no="${feedNo}"]`);
    cards.forEach((card) => {
        const likeButton = card.querySelector('.action-item[onclick*="likePost"]');
        if (likeButton) {
            applyThumbState(likeButton, likedByMe, thumbCount);
        }
    });
}

function bindCommentEvents(feedNo) {
    const commentBtn = document.getElementById("comment_add_btn");
    const commentInput = document.getElementById("comment_contents");

    if (!commentBtn) return;

    commentBtn.disabled = false;
    commentInput.disabled = false;

    commentBtn.onclick = () => {
        const content = commentInput.value.trim();
        if (!content) return;

        let p = new FormData();
        p.append("commentContent", content);
        p.append("feedNo", feedNo);

        fetch("/comment/create", {
            method: "POST",
            credentials: 'same-origin',
            body: p
        })
            .then(r => r.text())
            .then(r => {
                if (!r) return;
                if (r.trim() === "-1") {
                    alert("로그인 후 댓글을 작성할 수 있습니다.");
                    location.href = "/member/login";
                    return;
                }
                if (r.trim() > 0) {
                    commentInput.value = "";
                    getCommentList(feedNo);
                } else {
                    alert("댓글 등록 실패");
                }
            });
    };
}

function toggleReplyForm(commentNo, feedNo, commentDepth) {
    const form = document.getElementById(`reply_form_${commentNo}`);
    const input = document.getElementById(`reply_input_${commentNo}`);

    if (!form || !input) return;

    const isHidden = form.style.display === 'none' || form.style.display === '';
    form.style.display = isHidden ? 'block' : 'none';
    if (isHidden) {
        input.focus();
    }
}

function submitReplyComment(commentNo, feedNo, parentDepth) {
    const input = document.getElementById(`reply_input_${commentNo}`);
    const form = document.getElementById(`reply_form_${commentNo}`);
    if (!input || !form) return;

    const content = input.value.trim();
    if (!content) return;

    const nextDepth = Number(parentDepth) + 1;
    if (nextDepth > 1) {
        alert("답글은 한 단계까지만 가능합니다.");
        return;
    }

    const p = new FormData();
    p.append("commentContent", content);
    p.append("feedNo", feedNo);
    p.append("commentRef", commentNo);
    p.append("commentStep", 1);
    p.append("commentDepth", nextDepth);

    fetch("/comment/create", {
        method: "POST",
        credentials: 'same-origin',
        body: p
    })
        .then(r => r.text())
        .then(r => {
            if (!r) return;
            if (r.trim() === "-1") {
                alert("로그인 후 댓글을 작성할 수 있습니다.");
                location.href = "/member/login";
                return;
            }
            if (r.trim() > 0) {
                input.value = "";
                form.style.display = 'none';
                getCommentList(feedNo);
            } else {
                alert("답글 등록 실패");
            }
        });
}

async function likeComment(event, commentNo, button) {
    if (event) event.stopPropagation();

    const formData = new FormData();
    formData.append('commentNo', commentNo);

    const response = await fetch('/comment/thumb', {
        method: 'POST',
        credentials: 'same-origin',
        body: formData
    });

    const result = await response.json();
    if (result.result === -1) {
        alert('로그인 후 좋아요를 누를 수 있습니다.');
        location.href = '/member/login';
        return;
    }
    applyThumbState(button, result.likedByMe, result.commentThumb);
}

function getStoryUserOrder() {
    const items = Array.from(document.querySelectorAll('.story-wrapper .story-item'));
    const seen = new Set();
    const ordered = [];

    items.forEach((item) => {
        const userNo = item.dataset.userNo;
        if (!userNo || seen.has(userNo)) return;
        seen.add(userNo);
        ordered.push(userNo);
    });

    return ordered;
}

function hasAdjacentStoryUser(step) {
    if (!currentStoryUserNo || storyUserOrder.length === 0) return false;
    const currentIndex = storyUserOrder.findIndex((userNo) => String(userNo) === String(currentStoryUserNo));
    if (currentIndex < 0) return false;

    const targetIndex = currentIndex + step;
    return targetIndex >= 0 && targetIndex < storyUserOrder.length;
}

function getAdjacentStoryUser(step) {
    if (!currentStoryUserNo || storyUserOrder.length === 0) return null;
    const currentIndex = storyUserOrder.findIndex((userNo) => String(userNo) === String(currentStoryUserNo));
    if (currentIndex < 0) return null;

    const targetIndex = currentIndex + step;
    if (targetIndex < 0 || targetIndex >= storyUserOrder.length) return null;
    return storyUserOrder[targetIndex];
}

function renderStorySlide(index) {
    const track = document.getElementById('storyCarouselTrack');
    const counter = document.getElementById('storyCarouselCounter');
    if (!track) return;

    storySlideIndex = Math.max(0, Math.min(index, storySlideCount - 1));
    track.style.transform = `translateX(-${storySlideIndex * 100}%)`;

    if (counter) {
        counter.innerText = `${storySlideIndex + 1} / ${storySlideCount}`;
    }

    const prevBtn = document.getElementById('storyCarouselPrev');
    const nextBtn = document.getElementById('storyCarouselNext');
    if (prevBtn) prevBtn.disabled = storySlideIndex === 0 && !hasAdjacentStoryUser(-1);
    if (nextBtn) nextBtn.disabled = storySlideIndex >= storySlideCount - 1 && !hasAdjacentStoryUser(1);
}

async function loadStoryByUser(userNo, selectedFeedNo, stepDirection = 1) {
    currentStoryUserNo = String(userNo);

    const response = await fetch(`/feed/detail/story/user/${userNo}`);
    const storyList = await response.json();
    const stories = Array.isArray(storyList) ? storyList : [];

    if (stories.length === 0) return false;

    storySlideCount = stories.length;

    if (selectedFeedNo) {
        const selectedIndex = stories.findIndex((story) => String(story.feedNo) === String(selectedFeedNo));
        storySlideIndex = selectedIndex >= 0 ? selectedIndex : 0;
    } else {
        storySlideIndex = stepDirection < 0 ? stories.length - 1 : 0;
    }

    const slides = stories.map((story) => {
        const imgPath = story.list?.[0]?.fileName
            ? `/files/story/${story.list[0].fileName}`
            : '/img/default_user.avif';

        const profileImgPath = story.memberDTO?.profileDTO?.fileName
            ? `/files/member/${story.memberDTO.profileDTO.fileName}`
            : '/img/default_user.avif';

        const ownerName = story.memberDTO?.userNickname || story.memberDTO?.userNo || '';

        console.log('currentUserNo:', getCurrentUserNo(story));

        const isMyStory = isOwnStory(story);

        return `
            <div class="story-carousel-slide">
                <div class="story-frame">
                    <div class="dropdown-container story-dropdown" style="position:absolute; top:12px; right:12px; z-index:12;">
                        <button type="button" class="btn btn-sm btn-light dropdown-toggle-dot" onclick="togglePostMenu(event, 'story', '${story.feedNo}')">⋯</button>
                        <div class="dropdown-menu-custom story-menu" id="post-menu-story-${story.feedNo}" style="display:none;">
                            <button type="button" class="dropdown-item text-danger" onclick="deleteStory(event, '${story.feedNo}')">삭제</button>
                        </div>
                    </div>
                    <div class="story-user-label">
                        <div class="d-flex align-items-center">
                            <div class="profile-circle avatar-xs me-2">
                                <img src="${profileImgPath}" onerror="this.src='/img/default_user.avif'">
                            </div>
                            <span>${ownerName}</span>
                        </div>
                    </div>
                    <img src="${imgPath}" onerror="this.src='/img/default_user.avif'">
                    <div class="story-controls">
                        <!-- [수정] 본인이 작성한 스토리가 아닐 경우에만 좋아요 버튼 렌더링 -->
                        ${!isMyStory ? `
                        <button type="button" class="btn btn-sm btn-icon story-like-btn" onclick="likePost(event, '${story.feedNo}', this, 'story')">
                            <i class="${story.likedByMe ? 'fas' : 'far'} fa-heart"></i>
                        </button>
                        ` : ''}
                        <button type="button" class="btn btn-sm btn-icon story-share-btn" onclick="sharePost(event, '${story.feedNo}', 'story')"><i class="far fa-paper-plane"></i></button>
                    </div>
                </div>
            </div>
        `;
    }).join('');

    mImageArea.innerHTML = `
        <div class="story-carousel">
            <button type="button" class="story-carousel-btn prev" id="storyCarouselPrev" aria-label="Previous story">‹</button>
            <div class="story-carousel-viewport">
                <div class="story-carousel-track" id="storyCarouselTrack">${slides}</div>
            </div>
            <button type="button" class="story-carousel-btn next" id="storyCarouselNext" aria-label="Next story">›</button>
            <div class="story-carousel-counter" id="storyCarouselCounter"></div>
        </div>
    `;

    const prevBtn = document.getElementById('storyCarouselPrev');
    const nextBtn = document.getElementById('storyCarouselNext');

    if (prevBtn) {
        prevBtn.onclick = async () => {
            if (storySlideIndex > 0) {
                renderStorySlide(storySlideIndex - 1);
                return;
            }
            const prevUserNo = getAdjacentStoryUser(-1);
            if (!prevUserNo) return;
            await loadStoryByUser(prevUserNo, null, -1);
        };
    }

    if (nextBtn) {
        nextBtn.onclick = async () => {
            if (storySlideIndex < storySlideCount - 1) {
                renderStorySlide(storySlideIndex + 1);
                return;
            }
            const nextUserNo = getAdjacentStoryUser(1);
            if (!nextUserNo) return;
            await loadStoryByUser(nextUserNo, null, 1);
        };
    }

    renderStorySlide(storySlideIndex);
    return true;
}

function renderPostSlide(index) {
    const track = document.getElementById('postCarouselTrack');
    const counter = document.getElementById('postCarouselCounter');
    if (!track) return;

    postSlideIndex = Math.max(0, Math.min(index, postSlideCount - 1));
    track.style.transform = `translateX(-${postSlideIndex * 100}%)`;

    if (counter) {
        counter.innerText = `${postSlideIndex + 1} / ${postSlideCount}`;
    }

    const prevBtn = document.getElementById('postCarouselPrev');
    const nextBtn = document.getElementById('postCarouselNext');
    if (prevBtn) prevBtn.disabled = postSlideIndex === 0;
    if (nextBtn) nextBtn.disabled = postSlideIndex >= postSlideCount - 1;
}

function resetModalLayout() {
    detailModal.classList.remove('story-mode', 'post-mode');
    mImageArea.className = '';
    mImageArea.style.height = '';
    mInfoArea.style.display = 'flex';
    mImageArea.innerHTML = '';
}

function openDetail(type, feedNo, userNo) {
    resetModalLayout();
    detailModal.style.display = 'flex';
    document.body.style.overflow = 'hidden';

    if (type === 'story') {
        renderStory(feedNo, userNo);
    } else {
        renderPost(feedNo);
    }
}

async function likePost(event, feedNo, button, feedType = null) {
    if (event) event.stopPropagation();
    const formData = new FormData();
    formData.append('feedNo', feedNo);

    // 스토리 모드인지 확인: 버튼이 story-carousel 내부에 있으면 스토리로 간주
    const isStory = feedType === 'story' || (!!button && !!button.closest && button.closest('.story-carousel'));
    const url = isStory ? '/story/thumb' : '/post/thumb';

    let result;
    try {
        const response = await fetch(url, {
            method: 'POST',
            credentials: 'same-origin',
            body: formData
        });

        if (!response.ok) {
            console.error('likePost: network error', response.status, response.statusText);
            return;
        }

        result = await response.json();
    } catch (e) {
        console.error('likePost: fetch failed', e);
        return;
    }
    if (result.result === -1) {
        alert('로그인 후 좋아요를 누를 수 있습니다.');
        location.href = '/member/login';
        return;
    }

    // 스토리에서는 좋아요 수를 표시하지 않으므로 count 전달은 무시해도 됨
    applyThumbState(button, result.likedByMe, result.feedThumb);
    syncListThumbState(feedNo, result.likedByMe, result.feedThumb);
}

// 공유 창 닫기 함수
function closeShareModal() {
    if (shareModal) {
        shareModal.style.display = 'none';
        // 상세 모달이 열려있는 상태가 아니라면 본문 스크롤 정상화
        if (typeof detailModal !== 'undefined' && detailModal.style.display !== 'flex') {
            document.body.style.overflow = 'auto';
        }
    }
}

function sharePost(event, feedNo, type = 'post') {
    if (event) event.stopPropagation();

    if (!shareModal) return;

    // 1. 상세 모달(detailModal)이 켜져 있다면, 그 녀석의 z-index를 확인해서 그것보다 무조건 높게 설정
    if (detailModal && detailModal.style.display === 'flex') {
        // CSS 파일이나 인라인에 적용된 z-index 값을 가져옴 (없으면 기본값 계산)
        const detailZIndex = window.getComputedStyle(detailModal).zIndex;
        const parsedZIndex = parseInt(detailZIndex, 10);

        if (!isNaN(parsedZIndex)) {
            // 상세 모달보다 무조건 10만큼 더 위에 오도록 동적 주입
            shareModal.style.setProperty('z-index', (parsedZIndex + 10).toString(), 'important');
        } else {
            // 만약 숫자가 아니면 그냥 우주 끝까지 높임
            shareModal.style.setProperty('z-index', '99999', 'important');
        }
    } else {
        // 상세 모달이 안 켜져 있는 일반 피드 상태일 때의 기본 높이
        shareModal.style.setProperty('z-index', '3000', 'important');
    }

    // 공유 선택창 열기
    shareModal.style.display = 'flex';
    document.body.style.overflow = 'hidden';

    // 2. 외부로 공유하기 버튼 (링크 복사)
    const shareExternalBtn = document.getElementById('shareExternalBtn');
    if (shareExternalBtn) {
        shareExternalBtn.onclick = () => {
            let path = (type === 'story') ? `/feed/detail/story/${feedNo}` : `/feed/detail/post/${feedNo}`;
            const url = `${window.location.origin}${path}`;

            if (navigator.clipboard && navigator.clipboard.writeText) {
                navigator.clipboard.writeText(url).then(() => {
                    alert('공유 링크가 클립보드에 복사되었습니다.');
                    closeShareModal();
                }).catch(() => {
                    copyToClipboardFallback(url);
                    closeShareModal();
                });
            } else {
                copyToClipboardFallback(url);
                closeShareModal();
            }
        };
    }

    // 3. 채팅으로 공유하기 버튼
    const shareChatBtn = document.getElementById('shareChatBtn');
    if (shareChatBtn) {
        shareChatBtn.onclick = () => {
            // 모달 닫고 맞팔 목록 모달 열기
            closeShareModal();
            openShareChatModal(feedNo, type);
        };
    }
}

// 스크립트 하단 window.onclick 이벤트에 shareModal 바깥 클릭 시 닫히는 로직 추가
const originalWindowClick = window.onclick;
window.onclick = (e) => {
    if (originalWindowClick) originalWindowClick(e); // 기존 윈도우 클릭 이벤트 유지
    if (e.target == shareModal) closeShareModal();
    if (e.target && e.target.id === 'shareChatListModal') closeShareChatListModal();
};

// ESC 키 입력 시 닫히는 로직 추가
const originalKeyDown = document.onkeydown;
document.onkeydown = (e) => {
    if (originalKeyDown) originalKeyDown(e); // 기존 키 입력 이벤트 유지
    if (e.key === 'Escape') closeShareModal();
};

function copyToClipboardFallback(url) {
    const dummy = document.createElement('input');
    document.body.appendChild(dummy);
    dummy.value = url;
    dummy.select();
    document.execCommand('copy');
    document.body.removeChild(dummy);
    alert('공유 링크가 클립보드에 복사되었습니다.');
}

// 채팅 공유 목록 모달 관련 함수
function openShareChatModal(feedNo, type = 'post') {
    const modal = document.getElementById('shareChatListModal');
    const container = document.getElementById('shareChatListContainer');
    if (!modal || !container) return;

    // 로딩 표시
    container.innerHTML = '<div class="w-100 text-center p-3 text-muted">불러오는 중...</div>';
    modal.style.display = 'flex';
    document.body.style.overflow = 'hidden';

    // 기존의 서버 렌더링된 /chat/list 페이지를 불러와서 .user-grid 영역을 추출해 재사용합니다.
    fetch('/chat/list?page=1')
        .then(r => r.text())
        .then(html => {
            const parser = new DOMParser();
            const doc = parser.parseFromString(html, 'text/html');
            const grid = doc.querySelector('.user-grid');
            const empty = doc.querySelector('.search-empty');
            if (grid) {
                // 각 .user-card에서 프로필 이미지, 닉네임, userNo 추출 후 스토리 썸네일 스타일로 렌더
                const users = Array.from(grid.querySelectorAll('.user-card'));
                if (users.length === 0) {
                    container.innerHTML = '<div class="w-100 text-center p-3 text-muted">맞팔로우한 사용자가 없습니다.</div>';
                } else {
                    const items = users.map(card => {
                        const imgEl = card.querySelector('img');
                        const imgSrc = imgEl ? imgEl.getAttribute('src') : '/img/default_user.avif';
                        const nickEl = card.querySelector('.user_nickname');
                        const nickname = nickEl ? nickEl.textContent.trim() : '';
                        const btn = card.querySelector('.btn-chat-trigger');
                        let userNo = null;
                        if (btn && btn.dataset && btn.dataset.userNo) userNo = btn.dataset.userNo;
                        if (!userNo) {
                            const link = card.querySelector('.user-card-link');
                            if (link) {
                                const m = (link.getAttribute('href') || '').match(/userNo=(\d+)/);
                                if (m) userNo = m[1];
                            }
                        }
                        if (!userNo) return '';

                        return `
                            <div class="story-item" style="cursor:pointer;" onclick="shareToUser(event, '${userNo}', '${feedNo}')">
                                <div class="story-circle">
                                    <img src="${imgSrc}" onerror="this.src='/img/default_user.avif'">
                                </div>
                                <small>${escapeHtml(nickname)}</small>
                            </div>
                        `;
                    }).filter(Boolean).join('');

                    container.innerHTML = `<div class="story-wrapper" style="padding:10px; justify-content:flex-start;">${items}</div>`;
                }
            } else if (empty) {
                container.innerHTML = '<div class="w-100 text-center p-3 text-muted">맞팔로우한 사용자가 없습니다.</div>';
            } else {
                container.innerHTML = '<div class="w-100 text-center p-3 text-muted">목록 로드 실패</div>';
            }
        })
        .catch(e => {
            console.error('맞팔 목록 로드 실패', e);
            container.innerHTML = '<div class="w-100 text-center p-3 text-muted">목록 로드 실패</div>';
        });
}

function closeShareChatListModal() {
    const modal = document.getElementById('shareChatListModal');
    if (!modal) return;
    modal.style.display = 'none';
    document.body.style.overflow = 'auto';
}

function shareToUser(e, targetUserNo, feedNo) {
    if (e) e.stopPropagation();
    // 채팅방 생성 페이지로 이동 (서버에서 방을 찾아서 리다이렉트함)
    // feedNo는 필요 시 쿼리로 전달하도록 추가
    window.location.href = `/chat/create?targetUserNo=${targetUserNo}&shareFeedNo=${feedNo}`;
}

// [수정] 스토리 렌더링 함수 - 프로필 이미지 노출 로직 개선 및 본인 피드 좋아요 제한
async function renderStory(feedNo, userNo) {
    detailModal.classList.add('story-mode');
    mInfoArea.style.display = 'none';
    mImageArea.className = 'h-100 w-100 d-flex justify-content-center';

    try {
        if (userNo) {
            storyUserOrder = getStoryUserOrder();
            const loaded = await loadStoryByUser(userNo, feedNo, 1);
            if (!loaded) closeModal();
            return;
        }

        const response = await fetch(`/feed/api/story/${feedNo}`);
        const data = await response.json();

        const imgPath = data.list?.[0]?.fileName ? `/files/story/${data.list[0].fileName}` : '/img/default_user.avif';
        const ownerName = data.memberDTO?.userNickname || data.memberDTO?.userNo || '';

        // 프로필 이미지 경로 안전하게 생성 (여러 구조에 대응)
        const profileFileName = data.memberDTO?.profileDTO?.fileName
            || data.profileDTO?.fileName
            || data.memberDTO?.fileName
            || data.profileFileName
            || data.PROFILE_FILE_NAME;
        const profileImgPath = profileFileName ? `/files/member/${profileFileName}` : '/img/default_user.avif';

        console.log('currentUserNo:', getCurrentUserNo(data));

        const isMyStory = isOwnStory(data);

        mImageArea.innerHTML = `
            <div class="story-frame">
                <div class="dropdown-container story-dropdown" style="position:absolute; top:12px; right:12px; z-index:12;">
                    <button type="button" class="btn btn-sm btn-light dropdown-toggle-dot" onclick="togglePostMenu(event, 'story', '${feedNo}')">⋯</button>
                    <div class="dropdown-menu-custom story-menu" id="post-menu-story-${feedNo}" style="display:none;">
                        <button type="button" class="dropdown-item text-danger" onclick="deleteStory(event, '${feedNo}')">삭제</button>
                    </div>
                </div>
                <div class="story-user-label">
                    <div class="d-flex align-items-center">
                        <div class="profile-circle avatar-xs me-2">
                            <img src="${profileImgPath}" onerror="this.src='/img/default_user.avif'">
                        </div>
                        <span>${ownerName}</span>
                    </div>
                </div>
                <img src="${imgPath}" onerror="this.src='/img/default_user.avif'">
                <div class="story-controls">
                    <!-- [수정] 본인이 작성한 스토리가 아닐 경우에만 좋아요 버튼 렌더링 -->
                    ${!isMyStory ? `
                    <button type="button" class="btn btn-sm btn-icon story-like-btn" onclick="likePost(event, '${feedNo}', this, 'story')">
                        <i class="${data.likedByMe ? 'fas' : 'far'} fa-heart"></i>
                        <span class="like-count ms-1 small">${data.feedThumb ?? 0}</span>
                    </button>
                    ` : ''}
                    <button type="button" class="btn btn-sm btn-icon story-share-btn" onclick="sharePost(event, '${feedNo}', 'story')"><i class="far fa-paper-plane"></i></button>
                </div>
            </div>
        `;
    } catch (e) {
        console.error("스토리 로드 실패:", e);
        closeModal();
    }
}

async function renderPost(feedNo) {
    if (!standaloneMode && detailModal) {
        detailModal.classList.add('post-mode');
        mImageArea.className = 'col-md-7';
    } else {
        mImageArea.className = 'post-image-area';
    }

    try {
        const response = await fetch(`/feed/api/post/${feedNo}`);
        const data = await response.json();
        const ownerName = data.memberDTO?.userNickname || data.memberDTO?.userNo || '';
        const showFollowButton = !!data.currentUserNo && data.followedByMe === false;

        const postProfileFileName = data.memberDTO?.profileDTO?.fileName
            || data.profileDTO?.fileName
            || data.memberDTO?.fileName
            || data.profileFileName
            || data.PROFILE_FILE_NAME;
        const profileImgPath = postProfileFileName ? `/files/member/${postProfileFileName}` : '/img/default_user.avif';

        const images = data.list && data.list.length > 0
            ? data.list.map((fileDTO) => `
            <div class="post-carousel-slide">
                                <img src="/files/post/${fileDTO.fileName}" class="post-detail-img" onerror="this.src='/img/default_user.avif'">
                            </div>
            `).join('')
            : `<div class="post-carousel-slide"><img src="/img/default_user.avif" class="post-detail-img"></div>`;

        postSlideCount = data.list && data.list.length > 0 ? data.list.length : 1;
        postSlideIndex = 0;

        mImageArea.innerHTML = `
            <div class="post-gallery">
                <button type="button" class="post-carousel-btn prev" id="postCarouselPrev">‹</button>
                <div class="post-carousel-viewport">
                    <div class="post-carousel-track" id="postCarouselTrack">${images}</div>
                </div>
                <button type="button" class="post-carousel-btn next" id="postCarouselNext">›</button>
                <div class="post-carousel-counter" id="postCarouselCounter"></div>
            </div>`;

        mInfoArea.innerHTML = `
            <div class="p-3 border-bottom w-100 d-flex align-items-center justify-content-between">
                <div class="d-flex align-items-center">
                    <div class="profile-circle avatar-md me-3">
                        <img src="${profileImgPath}" onerror="this.src='/img/default_user.avif'">
                    </div>
                    <div>
                        <strong id="mOwner" class="d-block" style="line-height:1.2;">${ownerName}</strong>
                        <small id="mLocation" class="text-muted">
                            <i class="fas fa-location-dot me-1"></i>${data.feedLocation || ''}
                        </small>
                    </div>
                </div>
                <div class="d-flex align-items-center">
                    ${showFollowButton ? `<button type="button" class="btn btn-sm btn-light fw-bold text-primary flex-shrink-0 ms-auto follow-btn" data-user-no="${data.memberDTO?.userNo}" style="white-space: nowrap;">팔로우</button>` : ''}
                    <div class="dropdown-container ms-2">
                        <button type="button" class="btn btn-sm btn-light dropdown-toggle-dot" onclick="togglePostMenu(event, 'modal', '${feedNo}')">⋯</button>
                        <div class="dropdown-menu-custom modal-menu" id="post-menu-modal-${feedNo}" style="display:none;">
                            <button type="button" class="dropdown-item" onclick="editPost(event, '${feedNo}')">수정</button>
                            <button type="button" class="dropdown-item text-danger" onclick="deletePost(event, '${feedNo}')">삭제</button>
                        </div>
                    </div>
                </div>
            </div>
            <div id="comment_scroll_area" style="flex-grow: 1; overflow-y: auto; width: 100%; padding: 15px;">
                <div id="mContent" class="mb-3 d-flex gap-2">
                    <div class="profile-circle avatar-xs flex-shrink-0">
                        <img src="${profileImgPath}" onerror="this.src='/img/default_user.avif'">
                    </div>
                    <div>
                        <strong>${ownerName}</strong>
                        <div class="m-feed-text">${data.feedContent || ''}</div>
                    </div>
                </div>
                <hr>
                <div id="comment_display_list"></div> 
            </div>
            <div class="px-3 py-2 border-top d-flex align-items-center" style="gap: 20px;">
                <div class="action-item" style="cursor: pointer;" onclick="likePost(event, '${feedNo}', this)">
                    <i class="${data.likedByMe ? 'fas' : 'far'} fa-heart fa-lg"></i>
                    <span class="like-count ms-1 small">${data.feedThumb ?? 0}</span>
                </div>
                <div class="action-item" style="cursor: pointer;" onclick="sharePost(event, '${feedNo}', 'post')">
                    <i class="far fa-paper-plane fa-lg"></i>
                </div>
            </div>
            <div class="p-3 border-top w-100">
                <div class="input-group">
                    <input type="text" id="comment_contents" class="form-control border-0" placeholder="댓글 달기...">
                    <button class="btn btn-link text-decoration-none" type="button" id="comment_add_btn">게시</button>
                </div>
            </div>
        `;

        const prevBtn = document.getElementById('postCarouselPrev');
        const nextBtn = document.getElementById('postCarouselNext');
        if (prevBtn) prevBtn.onclick = () => renderPostSlide(postSlideIndex - 1);
        if (nextBtn) nextBtn.onclick = () => renderPostSlide(postSlideIndex + 1);
        renderPostSlide(0);

        getCommentList(feedNo);
        bindCommentEvents(feedNo);

        // 모달 내부의 팔로우 버튼 처리: 메인 팝업의 팔로우 버튼과 동일하게 /follow/follow로 POST
        const modalFollowBtn = mInfoArea.querySelector('.follow-btn');
        if (modalFollowBtn) {
            modalFollowBtn.onclick = (e) => {
                e.stopPropagation();
                const targetUserNo = modalFollowBtn.dataset.userNo;
                const fd = new FormData();
                fd.append('userFollowing', targetUserNo);
                fd.append('feedNo', feedNo);
                fetch('/follow/follow', { method: 'POST', credentials: 'same-origin', body: fd })
                    .then(resp => {
                        if (resp.redirected) { window.location = resp.url; return; }
                        return resp.text().then(() => { window.location.reload(); });
                    })
                    .catch(err => console.error('follow error', err));
            };
        }

    } catch (e) {
        console.error("포스트 로드 실패:", e);
        closeModal();
    }
}

function closeModal() {
    detailModal.style.display = 'none';
    document.body.style.overflow = 'auto';
}

// 카드에 내용이 길면 '더보기' 버튼을 표시하고, 클릭하면 내용 확장/축소
document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.post-card').forEach(card => {
        const text = card.querySelector('.post-text');
        const btn = card.querySelector('.readmore-btn');
        if (!text || !btn) return;

        // 원문 보관(추후 확장 시 사용)
        const original = text.textContent || '';
        const hasNewline = original.indexOf('\n') >= 0 || original.indexOf('\r') >= 0;

        if (hasNewline) {
            // 첫 줄만 표시 (줄바꿈 이전)
            const parts = original.split(/\r?\n/);
            const firstLine = parts[0] || '';
            const rest = parts.slice(1).join('\n');
            text.dataset.full = original;
            // 안전하게 innerHTML로 첫 줄 삽입하고 버튼을 텍스트 뒤로 이동
            // 더보기 전에 점(...) 표시를 추가
            text.innerHTML = escapeHtml(firstLine) + '<span class="inline-ellipsis">...</span>';
            // 버튼을 텍스트 내부 끝에 붙이면 첫 줄 바로 뒤에 위치
            text.appendChild(btn);
            card.classList.add('has-newline');
            btn.style.display = 'inline-block';
        } else {
            // 기존 오버플로우 검사 (긴 한 줄이면 더보기 표시)
            const isOverflow = text.scrollWidth > text.clientWidth + 2;
            if (isOverflow) btn.style.display = 'inline-block';
        }

        btn.addEventListener('click', (e) => {
            e.stopPropagation();
            // 원문이 있으면 원문으로, 없으면 기존 텍스트 그대로
            if (text.dataset.full) {
                // 줄바꿈 포함 원문을 안전하게 넣음
                text.innerHTML = escapeHtml(text.dataset.full).replace(/\n/g, '<br>');
            }
            card.classList.add('content-expanded');
            btn.style.display = 'none';
        });
    });
});

// 토글: 특정 포스트의 옵션 메뉴 열기/닫기
function togglePostMenu(event, context, feedNo) {
    if (event) event.stopPropagation();
    const id = `post-menu-${context}-${feedNo}`;
    const el = document.getElementById(id);
    if (!el) return;
    const visible = el.style.display === 'block';
    // 다른 메뉴는 닫기
    document.querySelectorAll('.dropdown-menu-custom').forEach(m => m.style.display = 'none');
    el.style.display = visible ? 'none' : 'block';
}

function editPost(event, feedNo) {
    if (event) event.stopPropagation();
    // 수정 페이지로 이동
    location.href = `/post/update?feedNo=${feedNo}`;
}

async function deletePost(event, feedNo) {
    if (event) event.stopPropagation();
    if (!confirm('정말로 삭제하시겠습니까?')) return;
    const form = new FormData();
    form.append('feedNo', feedNo);
    try {
        const resp = await fetch('/post/delete', { method: 'POST', credentials: 'same-origin', body: form });
        if (resp.ok) {
            if (resp.redirected) { location.href = resp.url; return; }
            location.reload();
            return;
        }
    } catch (e) {
    }
}

async function deleteStory(event, feedNo) {
    if (event) event.stopPropagation();
    if (!confirm('정말로 스토리를 삭제하시겠습니까?')) return;
    const form = new FormData();
    form.append('feedNo', feedNo);

    try {
        const resp = await fetch('/story/delete', { method: 'POST', credentials: 'same-origin', body: form });
        if (resp.redirected) {
            location.href = resp.url;
            return;
        }
        location.reload();
    } catch (e) {
    }
}

// 전역 클릭: 드롭다운 닫기 및 모달 외부 클릭 처리
window.onclick = (e) => {
    // 드롭다운이 열려있으면 클릭한 요소가 그 내부가 아닌 경우 모두 닫음
    document.querySelectorAll('.dropdown-menu-custom').forEach(m => {
        if (!m) return;
        if (e.target === m || m.contains(e.target)) return;
        m.style.display = 'none';
    });
    // 공유 모달은 외부 클릭으로 닫되, 상세 모달(detailModal)은 빈 공간 클릭으로 닫지 않음
    if (e.target == shareModal) closeShareModal();
};

document.onkeydown = (e) => { if (e.key === 'Escape') closeModal(); };
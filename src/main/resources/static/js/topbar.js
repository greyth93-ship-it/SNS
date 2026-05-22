function loadAlarmList() {
    const countBadges = [
        document.getElementById("alarm-count"),
        document.getElementById("sidebar-alarm-count")
    ].filter(Boolean);

    if (countBadges.length === 0) return;

    fetch('/push/unreadCount')
        .then(res => res.json())
        .then(data => {
            const count = data && data.count ? parseInt(data.count, 10) : 0;
            countBadges.forEach(countBadge => {
                if (count > 0) {
                    countBadge.innerText = count;
                    countBadge.style.display = "block";
                } else {
                    countBadge.style.display = "none";
                }
            });
        })
        .catch(err => console.error("알림 카운트 로드 중 오류:", err));
}

// 간단한 푸시 토스트 표시기
function showPushToast(message, type) {
    try {
        let container = document.getElementById('push-toast-container');
        if (!container) {
            container = document.createElement('div');
            container.id = 'push-toast-container';
            container.style.position = 'fixed';
            container.style.top = '16px';
            container.style.right = '16px';
            container.style.zIndex = 1060;
            document.body.appendChild(container);
        }

        const toast = document.createElement('div');
        toast.className = 'push-toast-item';
        toast.style.minWidth = '180px';
        toast.style.marginTop = '8px';
        toast.style.padding = '10px 14px';
        toast.style.borderRadius = '6px';
        toast.style.boxShadow = '0 6px 18px rgba(0,0,0,0.12)';
        toast.style.color = '#fff';
        toast.style.fontSize = '13px';
        toast.style.opacity = '0';
        toast.style.transition = 'opacity 0.18s ease, transform 0.18s ease';
        toast.style.transform = 'translateY(-6px)';
        if (type === 'success') {
            toast.style.background = '#28a745';
        } else if (type === 'error') {
            toast.style.background = '#dc3545';
        } else {
            toast.style.background = '#343a40';
        }

        toast.innerText = message;
        container.appendChild(toast);

        // animate in
        requestAnimationFrame(() => {
            toast.style.opacity = '1';
            toast.style.transform = 'translateY(0)';
        });

        setTimeout(() => {
            toast.style.opacity = '0';
            toast.style.transform = 'translateY(-6px)';
            setTimeout(() => container.removeChild(toast), 220);
        }, 1800);
    } catch (e) {
        console.error('push toast error', e);
    }
}

function getSenderProfileSrc(item) {
    return item.senderProfileFileName ? '/files/member/' + item.senderProfileFileName : '/img/default_user.avif';
}

function getSenderAvatarHtml(item) {
    const senderProfileSrc = getSenderProfileSrc(item);
    const likeBadge = (item.pushType === 'POST_LIKE' || item.pushType === 'STORY_LIKE')
        ? '<span style="position:absolute;right:-2px;bottom:-2px;width:18px;height:18px;border-radius:50%;background:#e74a3b;display:flex;align-items:center;justify-content:center;border:2px solid #fff;"><i class="fas fa-heart" style="font-size:9px;color:#fff;"></i></span>'
        : '';
    return `
        <div class="mr-3" style="position:relative;">
            <div style="width:42px;height:42px;border-radius:50%;overflow:hidden;flex-shrink:0;background:#f8f9fc;position:relative;">
                <img src="${senderProfileSrc}" alt="profile" onerror="this.src='/img/default_user.avif'"
                    style="width:100%;height:100%;object-fit:cover;display:block;">
            </div>
            ${likeBadge}
        </div>
    `;
}

function emitFollowStateChange(targetUserNo, isFollowing) {
    if (!targetUserNo || typeof document === 'undefined') {
        return;
    }

    document.dispatchEvent(new CustomEvent('sns:follow-state-change', {
        detail: {
            targetUserNo: String(targetUserNo),
            isFollowing: !!isFollowing
        }
    }));
}

function followBackFromAlarm(event, senderNo, button) {
    if (event) {
        event.preventDefault();
        event.stopPropagation();
    }

    if (!senderNo) {
        return;
    }

    const body = 'userFollowing=' + encodeURIComponent(senderNo);
    fetch('/follow/follow', {
        method: 'POST',
        credentials: 'same-origin',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: body
    })
        .then(resp => {
            if (!resp.ok) {
                throw new Error('서버 오류');
            }

            if (button) {
                setFollowButtonState(button, true, senderNo);
            }

            emitFollowStateChange(senderNo, true);

            if (typeof loadAlarmList === 'function') {
                loadAlarmList();
            }

            if (typeof loadAlarmItems === 'function') {
                loadAlarmItems();
            }
        })
        .catch(err => {
            console.error('follow alarm error', err);
            if (button) {
                button.disabled = false;
                button.textContent = '팔로우';
            }
        });
}

function setFollowButtonState(button, isFollowing, senderNo) {
    // If a senderNo is provided, update all buttons for that sender across the DOM
    if (senderNo) {
        const selector = `[data-sender-no="${senderNo}"]`;
        const buttons = document.querySelectorAll(selector);
        buttons.forEach(btn => {
            btn.disabled = false;
            btn.textContent = isFollowing ? '팔로잉' : '팔로우';
            btn.classList.toggle('btn-secondary', isFollowing);
            btn.classList.toggle('btn-outline-primary', !isFollowing);
            btn.dataset.followState = isFollowing ? 'following' : 'not-following';
            btn.onclick = function(e) {
                toggleFollowFromAlarm(e, senderNo, btn);
            };
        });
        return;
    }

    // Fallback: update only the provided button
    if (!button) return;
    button.disabled = false;
    button.textContent = isFollowing ? '팔로잉' : '팔로우';
    button.classList.toggle('btn-secondary', isFollowing);
    button.classList.toggle('btn-outline-primary', !isFollowing);
    button.dataset.followState = isFollowing ? 'following' : 'not-following';
    button.onclick = function(e) {
        toggleFollowFromAlarm(e, senderNo, button);
    };
}

function unfollowFromAlarm(event, senderNo, button) {
    if (event) {
        event.preventDefault();
        event.stopPropagation();
    }

    if (!senderNo) {
        return;
    }

    const body = 'userFollowing=' + encodeURIComponent(senderNo);
    fetch('/follow/delete', {
        method: 'POST',
        credentials: 'same-origin',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: body
    })
        .then(resp => {
            if (!resp.ok) {
                throw new Error('서버 오류');
            }

            return resp.text();
        })
        .then(text => {
            const num = parseInt(text, 10);
            if (!isNaN(num) && num > 0) {
                if (button) {
                    setFollowButtonState(button, false, senderNo);
                }

                emitFollowStateChange(senderNo, false);

                if (typeof loadAlarmList === 'function') {
                    loadAlarmList();
                }

                if (typeof loadAlarmItems === 'function') {
                    loadAlarmItems();
                }
            } else {
                throw new Error('삭제 실패');
            }
        })
        .catch(err => {
            console.error('unfollow alarm error', err);
        });
}

document.addEventListener('sns:follow-state-change', function(event) {
    const detail = event && event.detail ? event.detail : null;
    if (!detail || !detail.targetUserNo) {
        return;
    }

    setFollowButtonState(null, !!detail.isFollowing, detail.targetUserNo);
});

function toggleFollowFromAlarm(event, senderNo, button) {
    const state = button && button.dataset ? button.dataset.followState : '';
    if (state === 'following') {
        unfollowFromAlarm(event, senderNo, button);
        return;
    }

    followBackFromAlarm(event, senderNo, button);
}

function getNotificationMoveUrl(item) {
    if (!item) {
        return '#';
    }

    if (item.pushType === 'FOLLOW') {
        return item.senderNo ? '/member/mypage?userNo=' + item.senderNo : '#';
    }

    if (item.pushType === 'POST_LIKE') {
        return item.feedNo ? '/feed/detail/post/' + item.feedNo : '#';
    }

    if (item.pushType === 'STORY_LIKE') {
        return item.feedNo ? '/feed/detail/story/' + item.feedNo : '#';
    }

    return item.feedNo ? '/feed/detail/post/' + item.feedNo : '#';
}

// 드롭다운이 열릴 때 알림 항목들을 로드하여 보여줍니다.
function loadAlarmItems() {
    const container = document.getElementById("alarm-items-container");
    if (!container) return;

    // 목록을 새로 불러옵니다.
    fetch('/push/list')
        .then(res => res.json())
        .then(data => {
            container.innerHTML = "";
            if (!data || data.length === 0) {
                container.innerHTML = '<a class="dropdown-item text-center small text-gray-500">새로운 알림이 없습니다.</a>';
                return;
            }

            const isUnread = item => item.isRead === false || item.read === false || item.isRead === 'false' || item.read === 'false' || item.isRead === 'N' || item.read === 'N' || item.isRead === 0 || item.read === 0;

            data.forEach(item => {
                const unread = isUnread(item);
                const itemStyle = unread ? "" : "opacity:0.6;";
                const dateStyle = unread ? "font-weight:700; color:#5a5c69;" : "font-weight:400; color:#858796;";
                const messageStyle = unread ? "font-weight:700; color:#212529;" : "font-weight:400; color:#858796;";
                const moveUrl = getNotificationMoveUrl(item);
                console.log('알림 항목:', item); // 디버깅용 로그
                console.log('moveUrl:', moveUrl); // 디버깅용 로그
                const followButton = item.pushType === 'FOLLOW'
                    ? `<button type="button" class="btn btn-sm ${item.followedByMe ? 'btn-secondary' : 'btn-outline-primary'} ml-3 flex-shrink-0" style="white-space:nowrap;" data-follow-state="${item.followedByMe ? 'following' : 'not-following'}" onclick="toggleFollowFromAlarm(event, ${item.senderNo}, this)">${item.followedByMe ? '팔로잉' : '팔로우'}</button>`
                    : '';

                const alarmHtml = `
                    <div class="dropdown-item d-flex align-items-center justify-content-between" style="${itemStyle}">
                        <a href="javascript:void(0);" class="d-flex align-items-center flex-grow-1 text-decoration-none text-reset pr-2" onclick="handleNotificationClick(${item.pushNo}, '${moveUrl}')">
                            ${getSenderAvatarHtml(item)}
                            <div>
                                <div class="small" style="${dateStyle}">${item.pushDate || ''}</div>
                                <span style="${messageStyle}">${item.pushMsg || ''}</span>
                            </div>
                        </a>
                        ${followButton}
                    </div>
                `;
                container.insertAdjacentHTML('beforeend', alarmHtml);
            });

            // 읽음 처리 + 이동 함수
            window.handleNotificationClick = function(pushNo, moveUrl) {
                fetch('/push/read?pushNo=' + pushNo, {
                    method: 'POST'
                })
                    .then(response => response.json())
                    .then(data => {
                        try { location.href = moveUrl; } catch(e) { console.error(e); }
                    })
                    .catch(err => {
                        console.error("읽음 처리 중 오류:", err);
                        try { location.href = moveUrl; } catch(e) { console.error(e); }
                    });
            }
        })
        .catch(err => console.error("알림 목록 로드 중 오류:", err));
}

// 드롭다운 열기 시 알림 항목을 로드하도록 바인딩
document.addEventListener('DOMContentLoaded', function() {
    const alertsToggle = document.getElementById('alertsDropdown');
    if (!alertsToggle) return;

    alertsToggle.addEventListener('click', function() {
        // 버튼 클릭으로 드롭다운이 열릴 때마다 최신 목록을 불러옵니다.
        loadAlarmItems();
    });
});
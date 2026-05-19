function loadAlarmList() {
    const countBadge = document.getElementById("alarm-count");
    if (!countBadge) return;

    fetch('/push/unreadCount')
        .then(res => res.json())
        .then(data => {
            const count = data && data.count ? parseInt(data.count, 10) : 0;
            if (count > 0) {
                countBadge.innerText = count;
                countBadge.style.display = "block";
            } else {
                countBadge.style.display = "none";
            }
        })
        .catch(err => console.error("알림 카운트 로드 중 오류:", err));
}

function getSenderProfileSrc(item) {
    return item.senderProfileFileName ? '/files/member/' + item.senderProfileFileName : '/img/default_user.avif';
}

function getSenderAvatarHtml(item) {
    const senderProfileSrc = getSenderProfileSrc(item);
    const likeBadge = item.pushType === 'LIKE'
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
                if (!resp.ok) throw new Error('서버 오류');
                if (button) {
                    setFollowButtonState(button, true, senderNo);
                }

                if (typeof loadAlarmList === 'function') loadAlarmList();
                if (typeof loadAlarmItems === 'function') loadAlarmItems();

                if (window.Swal) {
                    Swal.fire({ toast: true, position: 'top-end', showConfirmButton: false, timer: 1800, timerProgressBar: true, icon: 'success', title: '팔로우했습니다.' });
                }
            })
            .catch(err => {
                console.error('follow alarm error', err);
                if (button) {
                    button.disabled = false;
                    button.textContent = '팔로우';
                }
            });

    fetch('/follow/follow', {
        method: 'POST',
        credentials: 'same-origin',
        body: fd
    })
        .then(resp => {
            if (button) {
                setFollowButtonState(button, true, senderNo);
            }

            if (typeof loadAlarmList === 'function') {
                loadAlarmList();
            }

            if (typeof loadAlarmItems === 'function') {
                loadAlarmItems();
            }

            if (window.Swal) {
                Swal.fire({
                    toast: true,
                    position: 'top-end',
                    showConfirmButton: false,
                    timer: 1800,
                    timerProgressBar: true,
                    icon: 'success',
                    title: '팔로우했습니다.'
                });
            }

            return resp;
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
    if (!button) {
        return;
    }

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
                if (!resp.ok) throw new Error('서버 오류');
                return resp.text();
            })
            .then(text => {
                const num = parseInt(text);
                if (!isNaN(num) && num > 0) {
                    if (button) setFollowButtonState(button, false, senderNo);
                    if (typeof loadAlarmList === 'function') loadAlarmList();
                    if (typeof loadAlarmItems === 'function') loadAlarmItems();
                    if (window.Swal) Swal.fire({ toast: true, position: 'top-end', showConfirmButton: false, timer: 1800, timerProgressBar: true, icon: 'success', title: '팔로우를 취소했습니다.' });
                } else {
                    throw new Error('삭제 실패');
                }
            })
            .catch(err => {
                console.error('unfollow alarm error', err);
            });

    fetch('/follow/delete', {
        method: 'POST',
        credentials: 'same-origin',
        body: fd
    })
        .then(resp => {
            if (button) {
                setFollowButtonState(button, false, senderNo);
            }

            if (window.Swal) {
                Swal.fire({
                    toast: true,
                    position: 'top-end',
                    showConfirmButton: false,
                    timer: 1800,
                    timerProgressBar: true,
                    icon: 'success',
                    title: '팔로우를 취소했습니다.'
                });
            }

            return resp;
        })
        .catch(err => {
            console.error('unfollow alarm error', err);
        });
}

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
        return item.senderNo ? '/feed/mypage?userNo=' + item.senderNo : '#';
    }

    return item.postNo ? '/post/detail?postNo=' + item.postNo : '#';
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
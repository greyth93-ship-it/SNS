
function setFollowButtonState(button, isFollowing) {
    if (!button) {
        return;
    }

    button.dataset.followState = isFollowing ? 'following' : 'not-following';
    button.classList.toggle('btn-secondary', isFollowing);
    button.classList.toggle('btn-outline-primary', !isFollowing);
    button.textContent = isFollowing ? '팔로잉' : '팔로우';
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

function syncFollowButtonFromEvent(event) {
    const detail = event && event.detail ? event.detail : null;
    if (!detail || !detail.targetUserNo) {
        return;
    }

    const button = document.querySelector('[data-user-no="' + detail.targetUserNo + '"][data-follow-state]');
    if (!button) {
        return;
    }

    const currentState = button.dataset.followState === 'following';
    const nextState = !!detail.isFollowing;
    if (currentState === nextState) {
        return;
    }

    setFollowButtonState(button, nextState);

    const badge = document.getElementById('followerCount');
    if (badge) {
        const val = parseInt(badge.textContent || '0', 10) || 0;
        badge.textContent = nextState ? val + 1 : Math.max(0, val - 1);
    }
}

function followUser(targetUserNo, button) {
    const isFollowing = button && button.dataset && button.dataset.followState === 'following';

    if (isFollowing) {
        fetch('/follow/delete', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: 'userFollowing=' + encodeURIComponent(targetUserNo)
        })
        .then(response => response.text())
        .then(text => {
            if (parseInt(text, 10) > 0) {
                setFollowButtonState(button, false);
                const badge = document.getElementById('followerCount');
                if (badge) {
                    const val = parseInt(badge.textContent || '0', 10) || 0;
                    badge.textContent = Math.max(0, val - 1);
                }
                emitFollowStateChange(targetUserNo, false);
            } else {
                alert('팔로우 취소 실패');
            }
        })
        .catch(error => {
            console.error(error);
        });

        return;
    }

    fetch('/member/follow', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: 'targetUserNo=' + encodeURIComponent(targetUserNo)
    })
        .then(response => response.json())
        .then(data => {

        if (data.success) {
            setFollowButtonState(button, true);
            // update follower count badge if present
            const badge = document.getElementById('followerCount');
            if (badge) {
                const val = parseInt(badge.textContent || '0', 10) || 0;
                badge.textContent = val + 1;
            }
            emitFollowStateChange(targetUserNo, true);
        } else {
            alert(data.message || '실패');
        }

    })
    .catch(error => {
        console.error(error);
    });
}

function bindFollowStateSync() {
    document.addEventListener('sns:follow-state-change', syncFollowButtonFromEvent);
}

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', bindFollowStateSync);
} else {
    bindFollowStateSync();
}
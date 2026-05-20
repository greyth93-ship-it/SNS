
function setFollowButtonState(button, isFollowing) {
    if (!button) {
        return;
    }

    button.dataset.followState = isFollowing ? 'following' : 'not-following';
    button.classList.toggle('btn-secondary', isFollowing);
    button.classList.toggle('btn-outline-primary', !isFollowing);
    button.textContent = isFollowing ? '팔로잉' : '팔로우';
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
        } else {
            alert(data.message || '실패');
        }

    })
    .catch(error => {
        console.error(error);
    });
}
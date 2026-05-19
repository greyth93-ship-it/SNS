


function followUser(targetUserNo) {

    console.log("targetUserNo =", targetUserNo);

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
            alert('팔로우 완료');
            location.reload();
        } else {
            alert(data.message || '실패');
        }

    })
    .catch(error => {
        console.error(error);
    });
}
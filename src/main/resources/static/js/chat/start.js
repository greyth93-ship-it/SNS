function startChat(targetUserNo) {
    try {
        if (!targetUserNo) return;
        window.location.href = '/chat/create?targetUserNo=' + encodeURIComponent(targetUserNo);
    } catch (e) {
        console.error('startChat error', e);
    }
}

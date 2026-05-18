// mutual.js
// 채팅 버튼 클릭을 가로채서 mutual 파라미터를 추가해 서버에 fetch 호출 후
// 서버가 리다이렉트하면 그 최종 URL로 이동합니다.
document.addEventListener('click', function(e) {
	const link = e.target.closest('a[href^="/chat/detail"]');
	if (!link) return;

	e.preventDefault();
	try {
		const href = link.getAttribute('href');
		const url = new URL(href, window.location.origin);
		url.searchParams.set('mutual', 'true');

		fetch(url.toString(), { credentials: 'same-origin', redirect: 'follow' })
			.then(function(resp) {
				if (resp.redirected) {
					window.location.href = resp.url;
				} else {
					window.location.href = url.toString();
				}
			})
			.catch(function() {
				// 네트워크 오류 시에도 원래 URL(파라미터 포함)로 이동
				window.location.href = url.toString();
			});
	} catch (err) {
		console.error('mutual.js error', err);
	}
});

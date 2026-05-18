document.getElementById('imageInput').addEventListener('change', function(e) {
    const file = e.target.files[0]; // 사용자가 선택한 파일
    if (file) {
        const reader = new FileReader();
        
        // 파일을 다 읽었을 때 실행되는 함수
        reader.onload = function(event) {
            const base64Data = event.target.result; // 이게 바로 그 긴 문자열!
            
            // 1. 화면에 미리보기 출력
            const preview = document.getElementById('preview');
            preview.src = base64Data;
            preview.style.display = 'block';
            
            // 2. 나중에 서버로 보내기 위해 숨겨진 input에 저장
            document.getElementById('base64String').value = base64Data;
            
            console.log("문자열 생성 완료!");
        };
        
        // 파일을 Base64 문자열로 읽기 시작
        reader.readAsDataURL(file);
    }
});
let cropper;
const fileInput = document.getElementById('fileInput');
const preview = document.getElementById('imagePreview');
const placeholder = document.getElementById('placeholder');
const form = document.getElementById('uploadForm');
const feedType = form.dataset.feedType;
const isPost = feedType === 'post';
const orderToggleBtn = document.getElementById('orderToggleBtn');
const orderModal = document.getElementById('orderModal');
const orderDropList = document.getElementById('orderDropList');
const orderModalCancel = document.getElementById('orderModalCancel');
const orderModalApply = document.getElementById('orderModalApply');
const orderModalCloseButtons = document.querySelectorAll('[data-order-close]');

let postItems = [];
let postCropper = null;
let postCurrentIndex = 0;
let postOrderSnapshot = [];
let postDragIndex = null;

// 1. 유틸리티 함수
function makePostObjectUrl(file) { return URL.createObjectURL(file); }

function revokePostUrls() {
    postItems.forEach(item => { if (item.objectUrl) URL.revokeObjectURL(item.objectUrl); });
}

function saveCurrentPostCrop() {
    if (postCropper && postItems[postCurrentIndex]) {
        postItems[postCurrentIndex].cropData = postCropper.getData(true);
    }
}

// 2. 메인 프리뷰 렌더링
function renderPostPreview() {
    const oldEditor = preview.querySelector('.post-editor');
    if (oldEditor) oldEditor.remove();

    const editor = document.createElement('div');
    editor.className = 'post-editor';
    editor.innerHTML = `
        <div class="post-editor-counter" id="postEditorCounter"></div>
        <div class="post-editor-viewport">
            <button type="button" class="post-editor-nav prev">‹</button>
            <div class="post-editor-slide"><img id="cropTarget"></div>
            <button type="button" class="post-editor-nav next">›</button>
        </div>
    `;
    preview.appendChild(editor);

    editor.querySelector('.prev').onclick = () => navigatePostEditor(-1);
    editor.querySelector('.next').onclick = () => navigatePostEditor(1);

    if (orderToggleBtn) {
        orderToggleBtn.classList.remove('d-none');
        orderToggleBtn.onclick = openOrderModal;
    }
    loadPostSlide(postCurrentIndex);
}

function loadPostSlide(index) {
    const currentItem = postItems[index];
    const img = document.getElementById('cropTarget');
    if (!currentItem || !img) return;

    if (postCropper) postCropper.destroy();

    img.onload = function() {
        postCropper = new Cropper(img, {
            aspectRatio: 1,
            viewMode: 1,
            dragMode: 'move',
            autoCropArea: 1,
            background: false,
            ready() {
                if (currentItem.cropData) postCropper.setData(currentItem.cropData);
            }
        });
    };
    img.src = currentItem.objectUrl;

    document.getElementById('postEditorCounter').innerText = `${index + 1} / ${postItems.length}`;
    preview.querySelector('.prev').disabled = (index === 0);
    preview.querySelector('.next').disabled = (index === postItems.length - 1);
}

function navigatePostEditor(dir) {
    saveCurrentPostCrop();
    postCurrentIndex += dir;
    loadPostSlide(postCurrentIndex);
}

// 3. 파일 선택 이벤트
fileInput.addEventListener('change', function(e) {
    const files = Array.from(e.target.files || []);
    if (files.length === 0) return;

    placeholder.style.display = 'none';
    if (postCropper) postCropper.destroy();
    if (cropper) cropper.destroy();

    if (!isPost) {
        const reader = new FileReader();
        reader.onload = (ev) => {
            const img = document.createElement('img');
            img.id = 'cropTarget';
            img.src = ev.target.result;
            preview.innerHTML = '';
            preview.appendChild(img);
            cropper = new Cropper(img, { aspectRatio: 9 / 16, viewMode: 1 });
        };
        reader.readAsDataURL(files[0]);
    } else {
        revokePostUrls();
        postItems = files.map(file => ({
            // UUID 대신 현재 시간과 랜덤값을 조합한 ID 사용
            id: Date.now() + Math.random().toString(36).substr(2, 9),
            file,
            objectUrl: makePostObjectUrl(file),
            cropData: null
        }));
        postCurrentIndex = 0;
        renderPostPreview();
    }
});

// 4. 드래그 앤 드롭 순서 변경 (모달 로직)
function openOrderModal() {
    saveCurrentPostCrop();
    postOrderSnapshot = JSON.parse(JSON.stringify(postItems.map(item => ({ ...item, file: item.file })))); // 스냅샷 복사
    renderOrderModal();
    orderModal.classList.remove('d-none');
    document.body.style.overflow = 'hidden';
}

function renderOrderModal() {
    if (!orderDropList) return;
    orderDropList.innerHTML = postItems.map((item, i) => `
        <div class="order-drop-item" draggable="true" data-index="${i}">
            <img src="${item.objectUrl}" class="order-drop-thumb" draggable="false">
            <div class="order-drop-label">${i + 1}</div>
            <div class="order-drop-handle">⋮⋮</div>
        </div>
    `).join('');
}

// 드래그 이벤트 위임
if (orderDropList) {
    orderDropList.addEventListener('dragstart', (e) => {
        const item = e.target.closest('.order-drop-item');
        if (!item) return;
        postDragIndex = Number(item.dataset.index);
        item.classList.add('dragging');
        e.dataTransfer.effectAllowed = 'move';
    });

    orderDropList.addEventListener('dragover', (e) => {
        e.preventDefault();
        const draggingItem = orderDropList.querySelector('.dragging');
        const overItem = e.target.closest('.order-drop-item');
        if (!draggingItem || !overItem || draggingItem === overItem) return;

        const allItems = [...orderDropList.querySelectorAll('.order-drop-item')];
        const currIdx = allItems.indexOf(draggingItem);
        const overIdx = allItems.indexOf(overItem);

        if (currIdx < overIdx) {
            overItem.after(draggingItem);
        } else {
            overItem.before(draggingItem);
        }
    });

    orderDropList.addEventListener('drop', (e) => {
        e.preventDefault();
        const items = [...orderDropList.querySelectorAll('.order-drop-item')];
        const newOrder = items.map(el => postItems[Number(el.dataset.index)]);
        postItems = newOrder;
        postCurrentIndex = 0; // 순서 변경 후 첫 번째 사진으로 초기화 (안정성)
        renderOrderModal();
    });

    orderDropList.addEventListener('dragend', (e) => {
        const item = e.target.closest('.order-drop-item');
        if (item) item.classList.remove('dragging');
    });
}

if (orderModalCancel) orderModalCancel.onclick = () => {
    postItems = [...postOrderSnapshot];
    orderModal.classList.add('d-none');
    document.body.style.overflow = 'auto';
    renderPostPreview();
};

if (orderModalApply) orderModalApply.onclick = () => {
    orderModal.classList.add('d-none');
    document.body.style.overflow = 'auto';
    renderPostPreview();
};

orderModalCloseButtons.forEach(btn => {
    btn.onclick = () => orderModalCancel.onclick();
});

// 5. 폼 제출 (비동기 크롭 처리)
form.addEventListener('submit', async function(e) {
    e.preventDefault();
    const submitBtn = document.getElementById('submitBtn');
    submitBtn.disabled = true;
    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 처리 중...';

    try {
        const dataTransfer = new DataTransfer();
        if (isPost) {
            saveCurrentPostCrop();
            for (let i = 0;i < postItems.length;i++) {
                const canvas = await getCroppedCanvasPromise(postItems[i]);
                const blob = await getBlobPromise(canvas);
                const file = new File([blob], `image_${i}.jpg`, { type: 'image/jpeg' });
                dataTransfer.items.add(file);
            }
        } else {
            if (!cropper) {
                alert("이미지를 선택해주세요.");
                submitBtn.disabled = false;
                return;
            }
            const canvas = cropper.getCroppedCanvas({
                width: 720,
                height: 1280,
                imageSmoothingEnabled: true,
                imageSmoothingQuality: 'high'
            });

            // 2. 캔버스를 Blob으로 변환
            const blob = await getBlobPromise(canvas);

            // 3. Blob을 File 객체로 변환하여 DataTransfer에 추가
            const file = new File([blob], 'story_upload.jpg', { type: 'image/jpeg' });
            dataTransfer.items.add(file);

            // [주의] 만약 기존에 base64String hidden input에 값을 넣는 코드가 있었다면 제거하세요.
            const base64Input = document.getElementById('base64String');
            if (base64Input) base64Input.value = "";
        }
        fileInput.files = dataTransfer.files;
        form.submit();
    } catch (err) {
        console.error(err);
        alert("이미지 처리 중 오류 발생");
        submitBtn.disabled = false;
        submitBtn.innerText = "다시 시도";
    }
});

function getCroppedCanvasPromise(item) {
    return new Promise((resolve) => {
        const tempImg = new Image();
        tempImg.onload = function() {
            const tempDiv = document.createElement('div');
            tempDiv.style.visibility = 'hidden';
            tempDiv.style.position = 'absolute';
            tempDiv.innerHTML = `<img src="${item.objectUrl}">`;
            document.body.appendChild(tempDiv);
            const imgEl = tempDiv.querySelector('img');

            const tCropper = new Cropper(imgEl, {
                aspectRatio: 1,
                viewMode: 1,
                ready() {
                    if (item.cropData) tCropper.setData(item.cropData);
                    const canvas = tCropper.getCroppedCanvas({ width: 1080, height: 1080 });
                    tCropper.destroy();
                    document.body.removeChild(tempDiv);
                    resolve(canvas);
                }
            });
        };
        tempImg.src = item.objectUrl;
    });
}

function getBlobPromise(canvas) {
    return new Promise((resolve) => {
        canvas.toBlob((blob) => resolve(blob), 'image/jpeg', 0.9);
    });
}
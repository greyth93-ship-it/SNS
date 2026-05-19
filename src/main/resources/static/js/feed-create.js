let cropper;
const fileInput = document.getElementById('fileInput');
const preview = document.getElementById('imagePreview');
const placeholder = document.getElementById('placeholder');
const form = document.getElementById('uploadForm');
const replaceImagesBtn = document.getElementById('replaceImagesBtn');
const feedType = form.dataset.feedType;
const isPost = feedType === 'post';
const orderToggleBtn = document.getElementById('orderToggleBtn');
const orderModal = document.getElementById('orderModal');
const orderDropList = document.getElementById('orderDropList');
const orderModalCancel = document.getElementById('orderModalCancel');
const orderModalApply = document.getElementById('orderModalApply');
const orderModalCloseButtons = document.querySelectorAll('[data-order-close]');
const currentPhotoSection = document.getElementById('currentPhotoSection');

let postItems = [];
let postCropper = null;
let postCurrentIndex = 0;
let postOrderSnapshot = [];
let postDragIndex = null;
const MAX_POST_IMAGES = 5;

// 1. 유틸리티 함수
function makePostObjectUrl(file) { return URL.createObjectURL(file); }

function revokePostUrls() {
    postItems.forEach(item => { if (item.objectUrl && item.objectUrl.startsWith('blob:')) URL.revokeObjectURL(item.objectUrl); });
}

// Open existing images (from server) in the post editor
function openExistingPostImages(fileNames, startIndex = 0) {
    if (!Array.isArray(fileNames) || fileNames.length === 0) return;
    if (isPost && fileNames.length > MAX_POST_IMAGES) fileNames = fileNames.slice(0, MAX_POST_IMAGES);

    if (postCropper) postCropper.destroy();
    if (cropper) cropper.destroy();
    placeholder.style.display = 'none';
    if (currentPhotoSection) currentPhotoSection.style.display = 'none';
    revokePostUrls();

    postItems = fileNames.map(fn => ({
        id: Date.now() + Math.random().toString(36).substr(2, 9),
        file: null,
        objectUrl: `/files/post/${fn}`,
        cropData: null
    }));
    postCurrentIndex = Math.max(0, startIndex);
    renderPostPreview();
}

if (replaceImagesBtn && fileInput) {
    replaceImagesBtn.addEventListener('click', () => {
        fileInput.value = '';
        fileInput.click();
    });
}

// Delegate clicks on existing images to open crop UI
document.addEventListener('click', (e) => {
    const img = e.target.closest && e.target.closest('.existing-image');
    if (!img) return;
    // collect all existing images in the container to preserve order
    const imgs = Array.from(document.querySelectorAll('.existing-image'));
    const fileNames = imgs.map(i => i.dataset.filename).filter(Boolean);
    const idx = fileNames.indexOf(img.dataset.filename);
    openExistingPostImages(fileNames, idx >= 0 ? idx : 0);
});

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

    if (isPost && files.length > MAX_POST_IMAGES) {
        alert(`포스트 사진은 최대 ${MAX_POST_IMAGES}장까지 첨부할 수 있습니다.`);
        fileInput.value = '';
        return;
    }

    placeholder.style.display = 'none';
    if (currentPhotoSection) currentPhotoSection.style.display = 'none';
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
            if (postItems.length > MAX_POST_IMAGES) {
                alert(`포스트 사진은 최대 ${MAX_POST_IMAGES}장까지 첨부할 수 있습니다.`);
                submitBtn.disabled = false;
                submitBtn.innerText = "포스트 게시하기";
                return;
            }
            for (let i = 0;i < postItems.length;i++) {
                const canvas = await getCroppedCanvasPromise(postItems[i]);
                const blob = await getBlobPromise(canvas);
                const file = new File([blob], `image_${i}.jpg`, { type: 'image/jpeg' });
                dataTransfer.items.add(file);
            }
        } else {
            if (!cropper) return;
            const canvas = cropper.getCroppedCanvas({ width: 720, height: 1280 });
            const blob = await getBlobPromise(canvas);
            const file = new File([blob], 'story.jpg', { type: 'image/jpeg' });
            dataTransfer.items.add(file);

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
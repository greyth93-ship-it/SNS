<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${name eq 'story' ? '새 스토리' : '새 포스트'} 작성</title>
<!-- 공통 CSS 임포트 -->
<c:import url="/WEB-INF/views/temp/head_css.jsp"></c:import>

<!-- Cropper.js 라이브러리 추가 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.13/cropper.min.css">
<link rel="stylesheet" type="text/css" href="/css/feed-create.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.13/cropper.min.js"></script>


</head>

<body id="page-top">
    <div id="wrapper">
        <c:import url="/WEB-INF/views/temp/sidebar.jsp"></c:import>
        
        <div id="content-wrapper" class="d-flex flex-column">
            <div id="content">
                <c:import url="/WEB-INF/views/temp/topbar.jsp"></c:import>

                <div class="container-fluid">
                    <div class="upload-container">
                        
                        <form id="uploadForm" action="/${name}/create" method="post" enctype="multipart/form-data" data-feed-type="${name}">
                            <input type="hidden" name="userNo" value="${userNo}">
                            <div class="card card-upload shadow-sm ${name eq 'story' ? 'theme-story' : 'theme-post'}">
                                
                                <div class="card-header bg-white d-flex justify-content-between align-items-center py-3">
                                    <h6 class="m-0 font-weight-bold ${name eq 'story' ? 'text-danger' : 'text-primary'}">
                                        <i class="${name eq 'story' ? 'fas fa-plus-circle' : 'fas fa-camera'}"></i> 
                                        ${name eq 'story' ? '스토리 추가' : '새 포스트 작성'}
                                    </h6>
                                    <a href="/feed/list" class="text-muted"><i class="fas fa-times"></i></a>
                                </div>

                                <!-- 이미지 미리보기 및 크로퍼 영역 -->
                                <div id="imagePreview">
                                    <div class="upload-placeholder" id="placeholder" onclick="document.getElementById('fileInput').click()">
                                        <i class="fas fa-images"></i>
                                        <p>${name eq 'story' ? '스토리 사진을 선택하세요' : '포스트 사진을 선택하세요'}</p>
                                    </div>
                                    <!-- 이미지가 삽입될 곳 -->
                                </div>
                                <input type="file" name="attach" id="fileInput" class="d-none" accept="image/*" <c:if test="${name eq 'post'}">multiple</c:if> required>
                                <c:if test="${name eq 'post'}">
                                    <div class="px-3 pt-3 pb-0">
                                        <button type="button" id="orderToggleBtn" class="btn btn-outline-primary btn-sm w-100 d-none">
                                            순서 변경
                                        </button>
                                    </div>
                                </c:if>

                                <div class="card-body">
                                    <c:choose>
                                        <c:when test="${name eq 'post'}">
                                            <div class="form-group mb-3">
                                                <label class="small font-weight-bold text-dark">위치 추가</label>
                                                <input type="text" name="feedLocation" class="form-control" placeholder="장소를 입력하세요">
                                            </div>
                                            <div class="form-group mb-4">
                                                <label class="small font-weight-bold text-dark">문구 입력</label>
                                                <textarea name="feedContent" class="form-control" rows="4" placeholder="내용을 입력하세요..."></textarea>
                                            </div>
                                        </c:when>
                                        <c:when test="${name eq 'story'}">
                                            <div class="text-center py-3 mb-3">
                                                <p class="text-muted small">
                                                    <i class="fas fa-info-circle"></i> 스토리는 사진만 업로드됩니다.
                                                </p>
                                            </div>
                                        </c:when>
                                    </c:choose>

                                    <div class="d-grid gap-2">
                                        <button type="submit" id="submitBtn" class="btn btn-block ${name eq 'story' ? 'btn-danger' : 'btn-primary'} btn-user">
                                            ${name eq 'story' ? '스토리 공유하기' : '포스트 게시하기'}
                                        </button>
                                        <a href="/feed/list" class="btn btn-block btn-light btn-user mt-2">취소</a>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <c:import url="/WEB-INF/views/temp/footer.jsp"></c:import>
        </div>
    </div>

    <c:import url="/WEB-INF/views/temp/footer_script.jsp"></c:import>

    <c:if test="${name eq 'post'}">
        <div id="orderModal" class="order-modal d-none">
            <div class="order-modal-backdrop" data-order-close></div>
            <div class="order-modal-panel" role="dialog" aria-modal="true" aria-labelledby="orderModalTitle">
                <div class="order-modal-header">
                    <div>
                        <div id="orderModalTitle" class="order-modal-title">사진 순서 변경</div>
                        <div class="order-modal-subtitle">사진을 드래그해서 순서를 바꾸세요.</div>
                    </div>
                    <button type="button" class="order-modal-close" data-order-close>&times;</button>
                </div>
                <div class="order-modal-body">
                    <div id="orderDropList" class="order-drop-list"></div>
                </div>
                <div class="order-modal-footer">
                    <button type="button" id="orderModalCancel" class="btn btn-light">취소</button>
                    <button type="button" id="orderModalApply" class="btn btn-primary">적용</button>
                </div>
            </div>
        </div>
    </c:if>

    <script src="/js/feed-create.js"></script>

</body>
</html>
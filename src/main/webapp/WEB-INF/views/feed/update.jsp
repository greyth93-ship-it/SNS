<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>포스트 수정</title>
<c:import url="/WEB-INF/views/temp/head_css.jsp"></c:import>
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
                        <form id="uploadForm" action="/post/update" method="post" enctype="multipart/form-data" data-feed-type="post">
                            <input type="hidden" name="feedNo" value="${dto.feedNo}">

                            <div class="card card-upload shadow-sm theme-post">
                                <div class="card-header bg-white d-flex justify-content-between align-items-center py-3">
                                    <h6 class="m-0 font-weight-bold text-primary">
                                        <i class="fas fa-pen-to-square"></i> 포스트 수정
                                    </h6>
                                    <a href="/feed/list" class="text-muted"><i class="fas fa-times"></i></a>
                                </div>

                                <div id="imagePreview">
                                    <div class="upload-placeholder d-none" id="placeholder" onclick="document.getElementById('fileInput').click()">
                                        <i class="fas fa-images"></i>
                                        <p>사진 파일을 선택하세요</p>
                                    </div>
                                </div>
                                <input type="file" name="attach" id="fileInput" class="d-none" accept="image/*" multiple>

                                <div class="px-3 pt-2 text-muted small">
                                    최대 5장까지 첨부할 수 있습니다.
                                </div>
                                <div class="px-3 pt-3 pb-0">
                                    <button type="button" id="orderToggleBtn" class="btn btn-outline-primary btn-sm w-100 d-none">
                                        순서 변경
                                    </button>
                                    <button type="button" id="replaceImagesBtn" class="btn btn-primary btn-sm w-100 mt-2">
                                        사진 파일 변경하기
                                    </button>
                                </div>

                                <div class="card-body">
                                    <c:if test="${not empty dto.list}">
                                        <div class="mb-4" id="currentPhotoSection">
                                            <label class="small font-weight-bold text-dark">현재 사진</label>
                                            <div class="row g-2 mt-1">
                                                <c:forEach items="${dto.list}" var="file">
                                                    <div class="col-6 col-md-4">
                                                        <div class="border rounded overflow-hidden bg-light" style="aspect-ratio: 1 / 1;">
                                                            <img src="${not empty file.fileName ? '/files/post/'.concat(file.fileName) : '/img/default_user.avif'}"
                                                                 data-filename="${file.fileName}"
                                                                 class="existing-image w-100 h-100"
                                                                 style="object-fit: cover;"
                                                                 onerror="this.src='/img/default_user.avif'"
                                                                 alt="post image">
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </c:if>

                                    <div class="form-group mb-3">
                                        <label class="small font-weight-bold text-dark">위치</label>
                                        <input type="text" name="feedLocation" class="form-control" value="<c:out value='${dto.feedLocation}'/>" placeholder="장소를 입력하세요">
                                    </div>

                                    <div class="form-group mb-4">
                                        <label class="small font-weight-bold text-dark">문구</label>
                                        <textarea name="feedContent" class="form-control" rows="4" placeholder="내용을 입력하세요..."><c:out value='${dto.feedContent}'/></textarea>
                                    </div>

                                    <div class="d-grid gap-2">
                                        <button type="submit" id="submitBtn" class="btn btn-primary btn-user btn-block">수정하기</button>
                                        <a href="/feed/list" class="btn btn-light btn-user btn-block mt-2">취소</a>
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
    <script src="/js/feed-create.js"></script>

    <c:if test="${not empty dto.list}">
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
</body>
</html>

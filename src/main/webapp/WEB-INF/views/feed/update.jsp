<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>포스트 수정</title>
<c:import url="/WEB-INF/views/temp/head_css.jsp"></c:import>
<link rel="stylesheet" type="text/css" href="/css/feed-create.css">
</head>

<body id="page-top">
    <div id="wrapper">
        <c:import url="/WEB-INF/views/temp/sidebar.jsp"></c:import>

        <div id="content-wrapper" class="d-flex flex-column">
            <div id="content">
                <c:import url="/WEB-INF/views/temp/topbar.jsp"></c:import>

                <div class="container-fluid">
                    <div class="upload-container">
                        <form id="uploadForm" action="/post/update" method="post">
                            <input type="hidden" name="feedNo" value="${dto.feedNo}">

                            <div class="card card-upload shadow-sm theme-post">
                                <div class="card-header bg-white d-flex justify-content-between align-items-center py-3">
                                    <h6 class="m-0 font-weight-bold text-primary">
                                        <i class="fas fa-pen-to-square"></i> 포스트 수정
                                    </h6>
                                    <a href="/feed/list" class="text-muted"><i class="fas fa-times"></i></a>
                                </div>

                                <div class="card-body">
                                    <c:if test="${not empty dto.list}">
                                        <div class="mb-4">
                                            <label class="small font-weight-bold text-dark">현재 사진</label>
                                            <div class="row g-2 mt-1">
                                                <c:forEach items="${dto.list}" var="file">
                                                    <div class="col-6 col-md-4">
                                                        <div class="border rounded overflow-hidden bg-light" style="aspect-ratio: 1 / 1;">
                                                            <img src="${file.fileName}" alt="post image" class="w-100 h-100" style="object-fit: cover;">
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
                                        <button type="submit" class="btn btn-primary btn-user btn-block">수정하기</button>
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
</body>
</html>

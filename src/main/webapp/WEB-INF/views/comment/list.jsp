<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>

<c:if test="${empty commentList}">
    <div class="text-center text-muted py-4">
        <small>아직 댓글이 없습니다. 첫 댓글을 남겨보세요!</small>
    </div>
</c:if>

<c:forEach items="${commentList}" var="c">
    <c:if test="${c.commentDepth eq 0}">
        <!-- [댓글 단위 시작] -->
        <div class="mb-3">
            <!-- 1. 부모 댓글 영역 -->
            <div class="d-flex align-items-start justify-content-between gap-2">
                <div class="d-flex align-items-start gap-2 flex-grow-1">
                    <!-- 댓글 작성자 프로필 이미지 -->
                    <div class="profile-circle comment-avatar flex-shrink-0" style="border: 1px solid #f0f0f0;">
                        <img src="${not empty c.memberDTO.profileDTO and not empty c.memberDTO.profileDTO.fileName ? '/files/member/'.concat(c.memberDTO.profileDTO.fileName) : '/img/default_user.avif'}" onerror="this.src='/img/default_user.avif'">
                    </div>
                    
                    <div class="flex-grow-1">
                        <strong style="font-size: 0.9rem; display: block; line-height: 1.2;">
                            <c:choose>
                                <c:when test="${not empty c.memberDTO and not empty c.memberDTO.userNickname}">
                                    ${c.memberDTO.userNickname}
                                </c:when>
                                <c:otherwise>
                                    user_${c.userNo}
                                </c:otherwise>
                            </c:choose>
                        </strong>
                        <span style="font-size: 0.9rem; word-break: break-all;">${c.commentContent}</span>
                    </div>
                </div>

                <div class="d-flex align-items-center gap-1 flex-shrink-0">
                    <button type="button" class="btn btn-sm btn-link text-decoration-none p-0" onclick="likeComment(event, ${c.commentNo}, this)">
                        <i class="${c.likedByMe ? 'fas' : 'far'} fa-heart"></i>
                        <span class="like-count ms-1 small text-muted">${empty c.commentThumb ? 0 : c.commentThumb}</span>
                    </button>
                    <button type="button" class="btn btn-sm btn-link text-decoration-none p-0 text-muted" style="font-size: 0.75rem;" onclick="toggleReplyForm(${c.commentNo}, ${c.feedNo}, ${c.commentDepth})">답글</button>
                </div>
            </div>

            <!-- 답글 입력 폼 -->
            <div id="reply_form_${c.commentNo}" class="mt-2 ps-5" style="display:none;">
                <div class="input-group input-group-sm">
                    <input type="text" id="reply_input_${c.commentNo}" class="form-control" placeholder="답글 달기...">
                    <button type="button" class="btn btn-outline-secondary" onclick="submitReplyComment(${c.commentNo}, ${c.feedNo}, ${c.commentDepth})">등록</button>
                </div>
            </div>

            <!-- 2. 대댓글 리스트 영역 (왼쪽 보더로 계층 표시) -->
            <div class="mt-2 ps-4 border-start" style="border-color: #f0f0f0 !important; margin-left: 15px;">
                <c:forEach items="${commentList}" var="r">
                    <c:if test="${r.commentDepth eq 1 and r.commentRef eq c.commentNo}">
                        <div class="d-flex align-items-start justify-content-between gap-2 mb-2 ms-2 ps-1 py-1">
                            <div class="d-flex align-items-start gap-2 flex-grow-1">
                                <!-- 대댓글 작성자 프로필 이미지 (부모보다 작게) -->
                                <div class="profile-circle reply-avatar flex-shrink-0" style="border: 1px solid #f0f0f0;">
                                    <img src="${not empty r.memberDTO.profileDTO and not empty r.memberDTO.profileDTO.fileName ? '/files/member/'.concat(r.memberDTO.profileDTO.fileName) : '/img/default_user.avif'}" onerror="this.src='/img/default_user.avif'">
                                </div>

                                <div class="flex-grow-1">
                                    <strong style="font-size: 0.85rem; display: block; line-height: 1.2;">
                                        <c:choose>
                                            <c:when test="${not empty r.memberDTO and not empty r.memberDTO.userNickname}">
                                                ${r.memberDTO.userNickname}
                                            </c:when>
                                            <c:otherwise>
                                                user_${r.userNo}
                                            </c:otherwise>
                                        </c:choose>
                                    </strong>
                                    <span style="font-size: 0.85rem; word-break: break-all;">${r.commentContent}</span>
                                </div>
                            </div>

                            <div class="d-flex align-items-center gap-1 flex-shrink-0">
                                <button type="button" class="btn btn-sm btn-link text-decoration-none p-0" onclick="likeComment(event, ${r.commentNo}, this)">
                                    <i class="${r.likedByMe ? 'fas' : 'far'} fa-heart" style="font-size: 0.8rem;"></i>
                                    <span class="like-count ms-1 small text-muted" style="font-size: 0.7rem;">${empty r.commentThumb ? 0 : r.commentThumb}</span>
                                </button>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </div>
        <hr class="my-2" style="opacity: 0.05;">
    </c:if>
</c:forEach>
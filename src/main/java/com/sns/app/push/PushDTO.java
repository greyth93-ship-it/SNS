package com.sns.app.push;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class PushDTO {
    private Long pushNo;
    private Long receiverNo;
    private Long senderNo;
    private String pushType;
    private String pushMsg;
    private boolean isRead;
    private LocalDateTime pushDate;
    private Long feedNo;
    
    // 조인을 통해 가져올 데이터 (필요시)
    private String senderNickname;
    private String senderProfileFileName;
    private Boolean followedByMe;
    
    // 편의: 날짜 및 시분초 문자열 반환 (예: 2026-05-22 15:04:05)
    public String getPushTime() {
        if (this.pushDate == null) return "";
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        return this.pushDate.format(fmt);
    }

}
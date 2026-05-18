package com.sns.app.push;

import java.time.LocalDateTime;
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
    private Long postNo;
    
    // 조인을 통해 가져올 데이터 (필요시)
    private String senderNickname;
}
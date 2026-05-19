package com.sns.app.chatroom;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ChatroomMessageDTO {

	private Long messageNo;
	private Long roomNo;
	private Long userNo;
	private String messageContent;
	private String messageType;
	private LocalDateTime messageDate;
	private Long readCount;
}

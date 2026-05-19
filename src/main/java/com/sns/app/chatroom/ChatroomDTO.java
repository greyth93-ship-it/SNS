package com.sns.app.chatroom;

import java.time.LocalDateTime;
import java.util.List;

import com.sns.app.pager.Pager;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ChatroomDTO {

	private Long roomNo;
	private LocalDateTime roomDate;
	private String roomType;
	
	private List<ChatroomMemberDTO> members;
	private List<ChatroomMessageDTO> messages;
	
	private Pager pager;
}

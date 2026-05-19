package com.sns.app.chatroom;

import java.time.LocalDateTime;

import com.sns.app.member.MemberDTO;
import com.sns.app.member.ProfileDTO;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ChatroomMemberDTO {
	
	private Long messageNo;
	private Long userNo;
	private Long roomNo;
	private Long roleNo;
	private LocalDateTime joinDate;
	private LocalDateTime readDate;
	private Boolean alarm;
	
	private MemberDTO memberDTO;
	private ProfileDTO profileDTO;
	
}

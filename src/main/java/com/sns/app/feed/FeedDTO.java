package com.sns.app.feed;

import java.time.LocalDateTime;
import java.util.List;

import com.sns.app.file.FileDTO;
import com.sns.app.member.MemberDTO;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class FeedDTO {
	
	private Long feedNo;
	private LocalDateTime feedDate;
	private Long userNo;
	private Long feedThumb;
	private Boolean likedByMe;
	private Boolean followedByMe;
	private Long currentUserNo;
	
	private MemberDTO memberDTO;
	
	private List<FileDTO> list;

	
}

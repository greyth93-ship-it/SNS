package com.sns.app.chatroom;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.web.bind.annotation.RequestParam;

@Mapper
public interface ChatroomMapper {

	public int room(ChatroomDTO chatroomDTO) throws Exception;
	
	public int roomMember(ChatroomMemberDTO chatroomMemberDTO) throws Exception;

	public int chat(ChatroomMessageDTO chatroomMessageDTO) throws Exception;
	
	public ChatroomDTO findRoom(@Param("myUserNo") Long myUserNo, @Param("targetUserNo") Long targetUserNo, @Param("roomNo") Long roomNo) throws Exception;
	
	public List<ChatroomMessageDTO> getMessages(@Param("roomNo") Long roomNo,
            @Param("startNum") Long startNum,
            @Param("perPage") Long perPage);
	
	public Long totalMessages(@Param("roomNo") Long roomNo);
}

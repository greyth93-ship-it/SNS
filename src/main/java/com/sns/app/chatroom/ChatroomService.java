package com.sns.app.chatroom;

import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.springframework.web.bind.annotation.RequestParam;



public interface ChatroomService {
	
	public ChatroomDTO findRoom(Long myUserNo, Long targetUserNo, String roomType, Long roomNo) throws Exception;
	public int chat(ChatroomMessageDTO chatroomMessageDTO) throws Exception;
	public Map<String, Object> getMessages(@RequestParam("roomNo") Long roomNo, @RequestParam("page") Long page) throws Exception;
}

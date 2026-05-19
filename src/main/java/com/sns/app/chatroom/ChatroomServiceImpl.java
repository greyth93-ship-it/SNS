package com.sns.app.chatroom;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestParam;

import com.sns.app.pager.Pager;

@Service
public class ChatroomServiceImpl implements ChatroomService {
	
	@Autowired
	private ChatroomMapper chatroomMapper;
	
	@Override
	@Transactional(rollbackFor = Exception.class)
	public ChatroomDTO findRoom(Long myUserNo, Long targetUserNo, String roomType, Long roomNo) throws Exception {
		
		ChatroomDTO room = chatroomMapper.findRoom(myUserNo, targetUserNo, roomNo);
		
		if (room != null) {
			return room;
		}
		ChatroomDTO createRoom = new ChatroomDTO();
		createRoom.setRoomType(roomType);
		chatroomMapper.room(createRoom);
		Long createRoomNo = createRoom.getRoomNo();
		
		
		ChatroomMemberDTO me = new ChatroomMemberDTO();
		me.setRoomNo(createRoomNo);
		me.setUserNo(myUserNo);
		me.setRoleNo(3L);
		me.setAlarm(true);
		chatroomMapper.roomMember(me);
		
		ChatroomMemberDTO you = new ChatroomMemberDTO();
		you.setRoomNo(createRoomNo);
		you.setUserNo(targetUserNo);
		you.setRoleNo(4L);
		you.setAlarm(true);
		chatroomMapper.roomMember(you);
		
		
		return chatroomMapper.findRoom(myUserNo, targetUserNo, roomNo);
	}
	
	
	
	@Override
	@Transactional(rollbackFor = Exception.class)
	public int chat(ChatroomMessageDTO chatroomMessageDTO) throws Exception {
		int result = chatroomMapper.chat(chatroomMessageDTO);
		
		return result;
	}
	
	@Override
	public Map<String, Object> getMessages(@RequestParam("roomNo") Long roomNo,
            @RequestParam("page") Long page) throws Exception {

		Pager pager = new Pager();
		pager.setPage(page);
		pager.setPerPage(10L);
		pager.makeStartNum();
		
		Long totalCount = chatroomMapper.totalMessages(roomNo);
		pager.makePageNum(totalCount);
		
		List<ChatroomMessageDTO> messages = chatroomMapper.getMessages(roomNo, pager.getStartNum(), pager.getPerPage());
		
		Map<String, Object> res = new HashMap<>();
		res.put("messages", messages);
		res.put("pager", pager);
		return res;
}
	
	
}

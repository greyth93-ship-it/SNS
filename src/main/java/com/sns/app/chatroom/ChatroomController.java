package com.sns.app.chatroom;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.sns.app.follow.FollowDTO;
import com.sns.app.follow.FollowService;
import com.sns.app.member.MemberDTO;
import com.sns.app.pager.Pager;

@Controller
@RequestMapping("/chat/*")
public class ChatroomController {

	@Autowired
	private ChatroomServiceImpl chatroomServiceImpl;
	
	@Autowired
	private FollowService followService;
	
	
	@GetMapping("create")
	public String findRoom(@RequestParam(value="targetUserNo", required=false) Long targetUserNo, @AuthenticationPrincipal MemberDTO loginUserNo, @RequestParam(value="roomNo", required=false) Long roomNo,Model model, Pager page) throws Exception{
		Long myUserNo = loginUserNo.getUserNo();
		
		if (roomNo == null && targetUserNo != null) {

	        List<FollowDTO> followList =
	                followService.isMatchedFollow(targetUserNo, myUserNo,page);

	        boolean isMatched = !followList.isEmpty();

	        if (!isMatched) {
	            throw new IllegalStateException(
	                    "맞팔로우 관계인 회원과만 채팅방을 개설할 수 있습니다."
	            );
	        }
	    }
		
		  if (roomNo != null) {

		        ChatroomDTO room =
		                chatroomServiceImpl.findRoom(
		                        myUserNo,
		                        null,
		                        "1:1",
		                        roomNo
		                );

		        model.addAttribute("room", room);
		        model.addAttribute("myUserNo",myUserNo);
				
				String you ="";
				String targetProfile = null;
				for(ChatroomMemberDTO m : room.getMembers()) {
					if(!m.getUserNo().equals(myUserNo)){
						you = m.getMemberDTO().getUserNickname();
					}
					if(m.getProfileDTO() != null && m.getProfileDTO().getFileName() != null) {
		                targetProfile = m.getProfileDTO().getFileName();
		            }
				}
				model.addAttribute("you",you);
				model.addAttribute("targetProfile", targetProfile);

		        return "chat/detail";
		    }
		  ChatroomDTO room =
		            chatroomServiceImpl.findRoom(
		                    myUserNo,
		                    targetUserNo,
		                    "1:1",
		                    null
		            );

		    return "redirect:/chat/create?roomNo=" + room.getRoomNo();
	}
	
	@PostMapping("create")
	@ResponseBody
	public int chat(ChatroomMessageDTO chatroomMessageDTO, @AuthenticationPrincipal MemberDTO loginUserNo) throws Exception {
		
		chatroomMessageDTO.setUserNo(loginUserNo.getUserNo());
		
		int result = chatroomServiceImpl.chat(chatroomMessageDTO);

		
		return result;
	}
	
	
	@GetMapping("message")
	@ResponseBody
	public Map<String, Object> getMessages(
	        @RequestParam("roomNo") Long roomNo,
	        @RequestParam("page") Long page) throws Exception {

	    return chatroomServiceImpl.getMessages(roomNo, page);
	}
	
//	@GetMapping("list")
//	public String list()throws Exception{
//		
//		
//		
//	}
}

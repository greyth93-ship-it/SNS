package com.sns.app.chatroom;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

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
	                followService.isMatchedFollow(targetUserNo, myUserNo, page);

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
						if(m.getProfileDTO() != null && m.getProfileDTO().getFileName() != null) {
						    targetProfile = m.getProfileDTO().getFileName();
						}
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
	
	@GetMapping("list")
	public String list(@AuthenticationPrincipal MemberDTO loginUser,
	                   @RequestParam(value="page", defaultValue="1") Long page, 
	                   Model model) throws Exception {
	    
	    // 1. 로그인한 유저 번호 (나)
	    Long loginUserNo = loginUser.getUserNo(); 
	    
	    // 2. Pager 객체 생성 및 페이지 세팅 (나머지 계산은 서비스가 알아서 해줍니다)
	    Pager pager = new Pager();
	    pager.setPage(page);
	    pager.setPerPage(10L); 
	    
	    // 3. 💡 질문하신 에러 구간 해결! 
	    // 서비스 메서드 정의에 맞춰 파라미터를 순서대로 전달합니다.
	    // 여기서 첫 번째 인자인 userNo(상대방번호) 자리에 null을 주어 '전체 맞팔 목록'을 조회함을 명시합니다.
	    List<FollowDTO> matchedList = followService.isMatchedFollow(loginUserNo, null, pager);
	    
	    // 4. JSP 화면으로 데이터 토스
	    model.addAttribute("matchedList", matchedList);
	    model.addAttribute("pager", pager);
	    
	    return "chat/list"; 
	}
}

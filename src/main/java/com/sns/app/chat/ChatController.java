package com.sns.app.chat;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class ChatController {
	
	@GetMapping("/chat/detail")
	public String chatDetail(@RequestParam("userNo") String userNo, 
	                         @RequestParam("currentUserNo") String currentUserNo, 
	                         Model model) {
	    
	    System.out.println("서버로 넘어온 내 번호: " + currentUserNo);
	    System.out.println("서버로 넘어온 상대 번호: " + userNo);
	    
	    // JSP로 다시 보낸다면
	    model.addAttribute("userNo", userNo);
	    model.addAttribute("currentUserNo", currentUserNo);
	    
	    return "chat/detail";
	}

}

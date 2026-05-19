package com.sns.app.member;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.sns.app.feed.FeedDTO;
import com.sns.app.feed.FeedService;
import com.sns.app.feed.post.PostDTO;
import com.sns.app.feed.post.PostService;
import com.sns.app.follow.FollowDTO;
import com.sns.app.follow.FollowService;
import com.sns.app.pager.Pager;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/member/*")
public class MemberController {
	
	@Autowired
	private MemberServiceImpl memberServiceImpl;
	
	@Autowired
	private PostService postService;
	
	@Autowired
	private FollowService followService;
	
	@GetMapping("mypage")
	public void mypage(
	        @RequestParam(value = "userNo", required = false) Long targetUserNo,
	        @AuthenticationPrincipal MemberDTO loginMember, 
	        Model model, 
	        Pager pager) throws Exception {
	    
	    // 1. 기준이 될 userNo 결정 (파라미터가 없으면 로그인한 본인의 userNo 사용)
	    if (targetUserNo == null) {
	        targetUserNo = loginMember.getUserNo();
	    }
	    
	    // 2. 페이징 처리에 대상 userNo 설정 (그 사람의 글 목록을 가져옴)
	    pager.setUserNo(targetUserNo);
	    pager.setPerPage(5L);
	    List<FeedDTO> list = postService.list(pager);
	    
	   
	    
	    // 현재 로그인한 사람과 페이지 주인의 userNo가 같은지 여부 (JSP에서 버튼 분기 처리용)
	    boolean isMine = targetUserNo.equals(loginMember.getUserNo());
	    
	    model.addAttribute("myposts", list);
	    model.addAttribute("pager", pager);
	    model.addAttribute("isMine", isMine); 
	    model.addAttribute("targetUserNo",targetUserNo);
	    // 만약 타인 정보 조회 로직을 안 넣는다면 임시로 targetUserNo를 가진 DTO나 id를 넘겨서 jsp에서 활용 가능합니다.
	}
	
	@GetMapping("myposts")
	public void myposts(HttpSession session, Model model) throws Exception{}
	
	@GetMapping("update")
	public void update(HttpSession session, Model model) throws Exception{
		MemberDTO memberDTO = (MemberDTO)session.getAttribute("member");
		model.addAttribute("memberDTO", memberDTO);
	}
	
	@PostMapping("update")
	public String update(@Validated(GroupUpdate.class) MemberDTO memberDTO, BindingResult bindingResult, HttpSession session, Model model) throws Exception{
		
		if(bindingResult.hasErrors()) {
			return "member/update";
		}
		
		MemberDTO s = (MemberDTO)session.getAttribute("member");
		memberDTO.setUserId(s.getUserId());
		
		int result = memberServiceImpl.update(memberDTO);
		if(result>0) {
			s = memberServiceImpl.detail(s);
			session.setAttribute("member", s);
		}
		return "redirect:/member/mypage";
	}
	
	@GetMapping("join")
	public void join(@ModelAttribute MemberDTO memberDTO) throws Exception{}
	
	@PostMapping("join")
	public String join(@Validated(GroupAdd.class) MemberDTO memberDTO, BindingResult bindingResult, @RequestParam("attach") MultipartFile attach) throws Exception{
		if(memberServiceImpl.doubleCheck(memberDTO, bindingResult)) {
			return "member/join";
		}
		int result = memberServiceImpl.join(memberDTO, attach);
		
		return "redirect:/member/login";
	}
	
	@GetMapping("idCheck")
	public String idCheck(MemberDTO memberDTO, Model model) throws Exception{
		memberDTO = memberServiceImpl.idCheck(memberDTO);
		int result = 0;
		if(memberDTO == null) {
			result=1;
		}
		model.addAttribute("result",result);
		
		return "commons/ajaxResult";
	}
	
	@GetMapping("login")
	public void login() throws Exception{}
	
	
	@PostMapping("follow")
	@ResponseBody
	public Map<String, Object> follow(@RequestParam("targetUserNo") Long targetUserNo,
		@AuthenticationPrincipal MemberDTO loginUser,FollowDTO followDTO) throws Exception{

	    Map<String, Object> result = new HashMap<>();

	    // 로그인 사용자 확인
	    if (loginUser == null ) {
	        result.put("success", false);
	        result.put("message", "로그인이 필요합니다.");
	        return result;
	    }
	    

	    Long followerUserNo = loginUser.getUserNo();
	    System.out.println(followerUserNo.valueOf(0));

	    // 자기 자신 팔로우 방지
	    if (followerUserNo.equals(targetUserNo)) {
	        result.put("success", false);
	        result.put("message", "자기 자신은 팔로우할 수 없습니다.");
	        return result;
	    }

	    followDTO.setUserFollower(followerUserNo);
	    followDTO.setUserFollowing(targetUserNo);
	    // 서비스 호출
	    int success = followService.follow(followDTO);

	    result.put("success", success);

	    return result;
	}
	
	

}

package com.sns.app.follow;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sns.app.member.MemberDTO;
import com.sns.app.pager.Pager;

@Controller
@RequestMapping("/follow/*")
public class FollowController {

	@Autowired
	private FollowService followService;

	@PostMapping("follow")
	public String follow(FollowDTO followDTO, @AuthenticationPrincipal MemberDTO memberDTO) throws Exception {

	    followDTO.setUserFollower(memberDTO.getUserNo());

	    if (followDTO.getMemberDTO() != null && followDTO.getUserFollowing() == null) {
	        followDTO.setUserFollowing(followDTO.getMemberDTO().getUserNo());
	    }
	    
	    followService.follow(followDTO);

	    if (followDTO.getFeedNo() != null) {
	        return "redirect:/feed/detail/post/" + followDTO.getFeedNo();
	    }

	    if (followDTO.getMemberDTO() != null && followDTO.getMemberDTO().getUserNo() != null) {
	        Long userNo = followDTO.getMemberDTO().getUserNo();
	        
	        if (userNo.equals(memberDTO.getUserNo())) {
	            return "redirect:/member/mypage";
	        }

	        return "redirect:/feed/mypage?userNo=" + userNo;
	    }

	    return "redirect:/member/mypage";
	}

	@GetMapping("detail")
	public FollowDTO detail(@RequestParam String username) throws Exception {
		FollowDTO followDTO = new FollowDTO();
		followDTO.setUsername(username);
		return followService.detail(followDTO);
	}

	@PostMapping("delete")
	public int delete(@RequestParam Long userFollower, @RequestParam Long userFollowing) throws Exception {

		FollowDTO followDTO = new FollowDTO();
		followDTO.setUserFollower(userFollower);
		followDTO.setUserFollowing(userFollowing);

		return followService.delete(followDTO);
	}

	@GetMapping("following")
	public String following(@AuthenticationPrincipal MemberDTO memberDTO, Model model, Pager pager) throws Exception {
		if(memberDTO == null) {
			return "redirect:/member/login";
		}

		pager.setUserNo(memberDTO.getUserNo());
		List<FollowDTO> list = followService.followingList(pager);
 		model.addAttribute("followingList", list);
 		model.addAttribute("currentUserNo", memberDTO.getUserNo());

		return "follow/following";
	}

	@GetMapping("follower")
	public String follower(@AuthenticationPrincipal MemberDTO memberDTO, Model model, Pager pager) throws Exception {
        if(memberDTO == null) {
            return "redirect:/member/login";
        }
		
		pager.setUserNo(memberDTO.getUserNo());
		List<FollowDTO> list = followService.followerList(pager);
		model.addAttribute("followerList", list);
		model.addAttribute("currentUserNo", memberDTO.getUserNo());
		return "follow/follower";
	}

}

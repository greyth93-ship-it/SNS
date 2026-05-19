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
import org.springframework.web.bind.annotation.ResponseBody;

import com.sns.app.member.MemberDTO;
import com.sns.app.pager.Pager;
import com.sns.app.push.PushDTO;
import com.sns.app.push.PushService;

@Controller
@RequestMapping("/follow/*")
public class FollowController {

	@Autowired
	private FollowService followService;

	@Autowired
	private PushService pushService;

	@PostMapping("follow")
	public String follow(FollowDTO followDTO, @AuthenticationPrincipal MemberDTO memberDTO) throws Exception {

	    followDTO.setUserFollower(memberDTO.getUserNo());

	    if (followDTO.getMemberDTO() != null && followDTO.getUserFollowing() == null) {
	        followDTO.setUserFollowing(followDTO.getMemberDTO().getUserNo());
	    }
	    
	    followService.follow(followDTO);

		// 알림 발송
		try {
			PushDTO push = new PushDTO();

			Long receiver = null;
			
			if (followDTO.getMemberDTO() != null && followDTO.getMemberDTO().getUserNo() != null) {
				receiver = followDTO.getMemberDTO().getUserNo();
			} else if (followDTO.getUserFollowing() != null) {
				receiver = followDTO.getUserFollowing();
			}

			if (receiver != null && !receiver.equals(memberDTO.getUserNo())) {
				push.setReceiverNo(receiver);
				push.setSenderNo(memberDTO.getUserNo());
				push.setPushType("FOLLOW");
				push.setPushMsg(memberDTO.getUserNickname() + "님이 회원님을 팔로우합니다.");
				pushService.sendPush(push);
			}
		} catch (Exception e) {
			System.err.println("팔로우 알림 발송 실패: " + e.getMessage());
		}

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
	@ResponseBody
	public int delete(@RequestParam("userFollowing") Long userFollowing, @AuthenticationPrincipal MemberDTO memberDTO) throws Exception {

		FollowDTO followDTO = new FollowDTO();
		followDTO.setUserFollower(memberDTO.getUserNo());
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

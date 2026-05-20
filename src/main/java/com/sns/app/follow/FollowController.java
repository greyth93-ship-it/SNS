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
	public String following(@RequestParam(value = "userNo", required = false) Long userNo,
							@AuthenticationPrincipal MemberDTO memberDTO,
							Model model, Pager pager) throws Exception {

		// 로그인하지 않은 사용자가 접속한 경우, userNo가 없으면 로그인 페이지로 이동
		if (memberDTO == null && userNo == null) {
			return "redirect:/member/login";
		}

		Long targetUserNo = (userNo != null) ? userNo : memberDTO.getUserNo();

		pager.setUserNo(targetUserNo);
		List<FollowDTO> list = followService.followingList(pager);

		model.addAttribute("followingList", list);
		// currentUserNo는 이 페이지에서 보고자 하는 유저의 번호
		model.addAttribute("currentUserNo", targetUserNo);
		// loginUserNo는 현재 로그인한 사용자의 번호(없을 수 있음)
		model.addAttribute("loginUserNo", (memberDTO != null ? memberDTO.getUserNo() : null));

		return "follow/following";
	}

	@GetMapping("follower")
	public String follower(@RequestParam(value = "userNo", required = false) Long userNo,
						   @AuthenticationPrincipal MemberDTO memberDTO,
						   Model model, Pager pager) throws Exception {

		if (memberDTO == null && userNo == null) {
			return "redirect:/member/login";
		}

		Long targetUserNo = (userNo != null) ? userNo : memberDTO.getUserNo();

		pager.setUserNo(targetUserNo);
		List<FollowDTO> list = followService.followerList(pager);
		model.addAttribute("followerList", list);
		model.addAttribute("currentUserNo", targetUserNo);
		model.addAttribute("loginUserNo", (memberDTO != null ? memberDTO.getUserNo() : null));
		return "follow/follower";
	}

}

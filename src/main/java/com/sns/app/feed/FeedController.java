package com.sns.app.feed;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sns.app.feed.post.PostService;
import com.sns.app.feed.story.StoryService;
import com.sns.app.member.MemberDTO;
import com.sns.app.member.MemberService;
import com.sns.app.pager.Pager;

@Controller
@RequestMapping("/feed/*")
public class FeedController {

	@Autowired
	private StoryService storyService;

	@Autowired
	private PostService postService;

	@Autowired
	private MemberService memberService;

	@GetMapping("list")
	public String list(Pager pager, Model model, @AuthenticationPrincipal MemberDTO memberDTO) throws Exception {

		if (memberDTO != null) {
			pager.setCurrentUserNo(memberDTO.getUserNo());
		}

		Pager storyPager = new Pager();
		storyPager.setCurrentUserNo(pager.getCurrentUserNo());
		List<FeedDTO> storyList = storyService.list(storyPager);
		// 현재 사용자가 있다면, 해당 사용자의 스토리를 리스트 맨 앞으로 이동
		if (memberDTO != null && storyList != null) {
			for (int i = 0; i < storyList.size(); i++) {
				FeedDTO s = storyList.get(i);
				if (s != null && s.getUserNo() != null && s.getUserNo().equals(memberDTO.getUserNo())) {
					// 이미 맨 앞이면 변경 불필요
					if (i != 0) {
						FeedDTO me = storyList.remove(i);
						storyList.add(0, me);
					}
					break;
				}
			}
		}

		List<FeedDTO> postList = postService.list(pager);

		model.addAttribute("storyList", storyList);
		model.addAttribute("postList", postList);

		return "feed/list";

	}

	@GetMapping("mypage")
	public String myPage(Pager pager, Model model, @AuthenticationPrincipal MemberDTO memberDTO, Long userNo)
			throws Exception {

		if (memberDTO != null) {
			pager.setCurrentUserNo(memberDTO.getUserNo());

			if (userNo == null) {
				userNo = memberDTO.getUserNo();
			}
		}

		pager.setUserNo(userNo);

		List<FeedDTO> postList = postService.myList(pager);

		model.addAttribute("postList", postList);
		model.addAttribute("userNo", userNo);

		return "member/mypage";
	}

	@GetMapping("/detail/story/user/{userNo}")
	@ResponseBody
	public List<FeedDTO> getStoryListByUser(@PathVariable("userNo") Long userNo,
			@AuthenticationPrincipal MemberDTO memberDTO) throws Exception {
		if (memberDTO != null) {
			return storyService.listByUser(userNo, memberDTO.getUserNo());
		}
		return storyService.listByUser(userNo);
	}

	// ===== HTML 페이지 (직접 방문용) - 더 구체적인 패턴 먼저 정의 =====
	// 포스트 디테일 페이지
	@GetMapping("/detail/post/{feedNo}")
	public String postDetail(@PathVariable("feedNo") Long feedNo, Model model,
			@AuthenticationPrincipal MemberDTO memberDTO) throws Exception {

		FeedDTO feedDTO = new FeedDTO();
		feedDTO.setFeedNo(feedNo);

		if (memberDTO != null) {
			feedDTO.setCurrentUserNo(memberDTO.getUserNo());
		}

		FeedDTO post = postService.detail(feedDTO);

		model.addAttribute("post", post);

		return "feed/post-detail";
	}

	// 스토리 디테일 페이지
	@GetMapping("/detail/story/{feedNo}")
	public String storyDetail(@PathVariable("feedNo") Long feedNo, Model model,
			@AuthenticationPrincipal MemberDTO memberDTO) throws Exception {
		FeedDTO feedDTO = new FeedDTO();
		feedDTO.setFeedNo(feedNo);
		if (memberDTO != null) {
			feedDTO.setCurrentUserNo(memberDTO.getUserNo());
		}
		FeedDTO story = storyService.detail(feedDTO);
		model.addAttribute("story", story);
		return "feed/story-detail";
	}

	// ===== JSON API (모달용) =====
	// 포스트 디테일 JSON API (모달)
	@GetMapping("/api/post/{feedNo}")
	@ResponseBody
	public FeedDTO apiPostDetail(@PathVariable("feedNo") Long feedNo, @AuthenticationPrincipal MemberDTO memberDTO)
			throws Exception {
		FeedDTO feedDTO = new FeedDTO();
		feedDTO.setFeedNo(feedNo);
		if (memberDTO != null) {
			feedDTO.setCurrentUserNo(memberDTO.getUserNo());
		}
		return postService.detail(feedDTO);
	}

	// 스토리 디테일 JSON API (모달)
	@GetMapping("/api/story/{feedNo}")
	@ResponseBody
	public FeedDTO apiStoryDetail(@PathVariable("feedNo") Long feedNo, @AuthenticationPrincipal MemberDTO memberDTO)
			throws Exception {
		FeedDTO feedDTO = new FeedDTO();
		feedDTO.setFeedNo(feedNo);
		if (memberDTO != null) {
			feedDTO.setCurrentUserNo(memberDTO.getUserNo());
		}
		return storyService.detail(feedDTO);
	}

	// 기존 호환성용 JSON API (generic 패턴은 마지막에 정의)
	@GetMapping("/detail/{type}/{feedNo}")
	@ResponseBody
	public FeedDTO getFeedDetail(@PathVariable("type") String type, @PathVariable("feedNo") Long feedNo,
			@AuthenticationPrincipal MemberDTO memberDTO) throws Exception {
		FeedDTO feedDTO = new FeedDTO();
		feedDTO.setFeedNo(feedNo);
		if (memberDTO != null) {
			feedDTO.setCurrentUserNo(memberDTO.getUserNo());
		}

		if ("story".equals(type)) {
			return storyService.detail(feedDTO);
		}

		if ("post".equals(type)) {
			return postService.detail(feedDTO);
		}

		throw new Exception();
	}

	@GetMapping("userSearch")
	public String userSearch(@RequestParam(value = "keyword", required = false) String keyword, Model model)
			throws Exception {

		// 회원 검색 서비스 호출
		List<MemberDTO> memberList = memberService.search(keyword);

		model.addAttribute("memberList", memberList);
		model.addAttribute("keyword", keyword);

		return "feed/userSearch";
	}

	@GetMapping("goMypage")
	public String goMypage(@RequestParam(value = "userNo", required = false) Long userNo,
			@AuthenticationPrincipal MemberDTO memberDTO, Pager pager, Model model) throws Exception {

		if (userNo == null) {
			return "redirect:/feed/list";
		}

		pager.setUserNo(userNo);
		if (memberDTO != null) {
			pager.setCurrentUserNo(memberDTO.getUserNo());
		}

		List<FeedDTO> postList = postService.myList(pager);
		
		MemberDTO m = new MemberDTO();
		m.setUserNo(userNo);

		// 3. 결과 전달
		model.addAttribute("postList", postList);
		// member/mypage 뷰는 MemberController에서 사용하는 `myposts`와 `pager`를 참조하므로 호환을 위해 동일한 속성도 추가
		model.addAttribute("myposts", postList);
		model.addAttribute("pager", pager);


		return "member/mypage";
	}

}

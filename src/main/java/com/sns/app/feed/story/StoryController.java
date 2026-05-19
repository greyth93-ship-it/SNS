package com.sns.app.feed.story;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.sns.app.feed.FeedDTO;
import com.sns.app.member.MemberDTO;

@Controller
@RequestMapping("/story/*")
@CrossOrigin("*")
public class StoryController {

	@Autowired
	private StoryService storyService;

	@Value("${app.feed.story}")
	private String name;

	@ModelAttribute("name")
	public String getName() {
		return this.name;
	}
	
	

	// 2. 등록 폼 이동
	@GetMapping("create")
	public String create() throws Exception {
		return "feed/create";
	}

	// 3. 등록 처리 
	@PostMapping("create")
	public String create(StoryDTO storyDTO, @RequestParam(value="attach", required = false) MultipartFile[] attach,
			@AuthenticationPrincipal MemberDTO memberDTO) throws Exception {

		if (memberDTO != null) {
			storyDTO.setUserNo(memberDTO.getUserNo());
		}

		storyService.create(storyDTO, attach);

		return "redirect:/feed/list";
	}

	// 4. 상세 조회 
	@GetMapping("detail")
	public String detail(StoryDTO storyDTO, Model model) throws Exception {
		FeedDTO feedDTO = storyService.detail(storyDTO);
		model.addAttribute("dto", feedDTO);
		return "feed/detail";
	}
	
	// 5. 삭제 처리
	@PostMapping("delete")
	public String delete(StoryDTO storyDTO) throws Exception {
		storyService.delete(storyDTO);
		return "redirect:/feed/list";
	}


	// Ajax 전용 상세 데이터 조회 (JSON 리턴)
	@GetMapping("getDetail")
	@ResponseBody // 페이지 이동이 아닌 데이터를 직접 응답바디에 담음
	public FeedDTO getDetail(StoryDTO storyDTO) throws Exception {
	    // 기존 detail 로직 재활용
	    return storyService.detail(storyDTO); 
	}

	@PostMapping("thumb")
	@ResponseBody
	public java.util.Map<String, Object> thumb(FeedDTO feedDTO, @AuthenticationPrincipal MemberDTO memberDTO) throws Exception {
		java.util.Map<String, Object> result = new java.util.HashMap<>();

		if (memberDTO == null) {
			result.put("result", -1);
			return result;
		}

		feedDTO.setCurrentUserNo(memberDTO.getUserNo());

		try {
			FeedDTO updated = storyService.toggleThumb(feedDTO, memberDTO);
			result.put("result", 1);
			result.put("feedThumb", updated.getFeedThumb());
			result.put("likedByMe", updated.getLikedByMe());
		} catch (Exception e) {
			System.err.println("StoryController.thumb - toggleThumb failed for feedNo=" + feedDTO.getFeedNo() + ": " + e.getMessage());
			result.put("result", -2);
			return result;
		}
		// done
		return result;
	}
}
package com.sns.app.feed.post;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import com.sns.app.pager.Pager;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/post/*")
@CrossOrigin("*")
public class PostController {

	@Autowired
	private PostService postService;

	@Value("${app.feed.post}")
	private String name;

	@ModelAttribute("name")
	public String getName() {
		return this.name;
	}


	// 피드 상세 조회
	@GetMapping("detail")
	public String detail(PostDTO postDTO, Model model, @AuthenticationPrincipal MemberDTO memberDTO) throws Exception {
		if (memberDTO != null) {
			postDTO.setCurrentUserNo(memberDTO.getUserNo());
		}
		FeedDTO feedDTO = postService.detail(postDTO);
		model.addAttribute("dto", feedDTO);
		return "feed/detail";
	}

	@GetMapping("search")
	public String search(Pager pager, Model model, @AuthenticationPrincipal MemberDTO memberDTO) throws Exception {

		if (memberDTO != null) {
			pager.setCurrentUserNo(memberDTO.getUserNo());
		}

		pager.setPerPage(100L);

		List<FeedDTO> postList = postService.searchList(pager);

		model.addAttribute("postList", postList);
		model.addAttribute("pager", pager);

		return "feed/search";
	}
	
	@GetMapping("userSearch")
	public String userSearch(Pager pager, Model model, @AuthenticationPrincipal MemberDTO memberDTO) throws Exception {

		if (memberDTO != null) {
			pager.setCurrentUserNo(memberDTO.getUserNo());
		}

		pager.setPerPage(1000L);

		List<FeedDTO> postList = postService.searchList(pager);

		model.addAttribute("postList", postList);
		model.addAttribute("pager", pager);

		return "feed/search";
	}

	// 2. 등록 폼 이동
	@GetMapping("create")
	public String create() throws Exception {
		return "feed/create";
	}

	@PostMapping("create")
	public String create(PostDTO postDTO,
	                     @RequestParam("attach") MultipartFile[] attach,
	                     @AuthenticationPrincipal MemberDTO memberDTO) throws Exception {

	    // 현재 로그인한 사용자 번호 세팅
	    postDTO.setUserNo(memberDTO.getUserNo());

	    // 서비스 호출
	    postService.create(postDTO, attach);

	    return "redirect:/feed/list";
	}
	
	// 피드 수정 폼 이동
	@GetMapping("update")
	public String update(PostDTO postDTO, Model model) throws Exception {
		FeedDTO feedDTO = postService.detail(postDTO);
		model.addAttribute("dto", feedDTO);
		return "feed/update";
	}

	// 피드 수정 처리
	@PostMapping("update")
	public String update(PostDTO postDTO, @RequestParam(value="attach", required=false) MultipartFile[] attach) throws Exception {
		postService.update(postDTO, attach);
		return "redirect:/feed/list";
	}

	// 피드 삭제 처리
	@PostMapping("delete")
	public String delete(PostDTO postDTO) throws Exception {
		postService.delete(postDTO);
		return "redirect:/feed/list";
	}

	@GetMapping("getDetail")
	@ResponseBody
	public FeedDTO getDetail(PostDTO postDTO, @AuthenticationPrincipal MemberDTO memberDTO) throws Exception {
		if (memberDTO != null) {
			postDTO.setCurrentUserNo(memberDTO.getUserNo());
		}
		return postService.detail(postDTO);
	}

	@PostMapping("thumb")
	@ResponseBody
	public Map<String, Object> thumb(PostDTO postDTO, @AuthenticationPrincipal MemberDTO memberDTO) throws Exception {
		Map<String, Object> result = new HashMap<>();

		if (memberDTO == null) {
			result.put("result", -1);
			return result;
		}

		postDTO.setCurrentUserNo(memberDTO.getUserNo());
		FeedDTO originalPost = postService.detail(postDTO);
		
		if(originalPost != null) {
		    // FeedDTO(또는 상속받은 PostDTO)의 userNo 필드에 작성자 번호 주입
		    postDTO.setUserNo(originalPost.getUserNo()); 
		}
		

		FeedDTO feedDTO = postService.toggleThumb(postDTO,memberDTO);
		result.put("result", 1);
		result.put("feedThumb", feedDTO.getFeedThumb());
		result.put("likedByMe", feedDTO.getLikedByMe());
		return result;
	}

}
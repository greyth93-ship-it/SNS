package com.sns.app.follow;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/follow/*")
public class FollowController {

	@Autowired
	private FollowService followService;

	@PostMapping("follow")
	public int follow(@RequestParam Long userFollower,
			@RequestParam Long userFollowing) throws Exception {

		FollowDTO followDTO = new FollowDTO();
		followDTO.setUserFollower(userFollower);
		followDTO.setUserFollowing(userFollowing);
		followDTO.setFollowDate(new Date());

		return followService.follow(followDTO);
	}

	@GetMapping("detail")
	public FollowDTO detail(@RequestParam String username) throws Exception {
		FollowDTO followDTO = new FollowDTO();
		followDTO.setUsername(username);
		return followService.detail(followDTO);
	}

}

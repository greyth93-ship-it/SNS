package com.sns.app.follow;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class FollowService {

	@Autowired
	private FollowMapper followMapper;

	public FollowDTO detail(FollowDTO followDTO) throws Exception {
		return followMapper.detail(followDTO);
	}

	public int follow(FollowDTO followDTO) throws Exception {
		return followMapper.follow(followDTO);
	}

}

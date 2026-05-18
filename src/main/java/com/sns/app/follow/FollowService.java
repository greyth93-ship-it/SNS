package com.sns.app.follow;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sns.app.pager.Pager;

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

	public int delete(FollowDTO followDTO) throws Exception {
		return followMapper.delete(followDTO);
	}

	public List<FollowDTO> followingList(Pager pager) throws Exception {
		pager.makePageNum(followMapper.followingCount(pager));

		pager.makeStartNum();
		return followMapper.followingList(pager);
	}

	public List<FollowDTO> followerList(Pager pager) throws Exception {
		pager.makePageNum(followMapper.followerCount(pager));
		pager.makeStartNum();
		return followMapper.followerList(pager);
	}


}

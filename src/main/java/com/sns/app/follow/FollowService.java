package com.sns.app.follow;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sns.app.member.MemberDTO;

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

	public List<MemberDTO> followingList(Long userNo) throws Exception {
		return followMapper.followingList(userNo);
	}

	public List<MemberDTO> followerList(Long userNo) throws Exception {
		return followMapper.followerList(userNo);
	}

	public List<MemberDTO> mutualList(Long userNo) throws Exception {
		return followMapper.mutualList(userNo);
	}
 
}

package com.sns.app.follow;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sns.app.pager.Pager;
import com.sns.app.member.MemberDTO;

@Service
public class FollowService {

	@Autowired
	private FollowMapper followMapper;

	public Long followingCount(Long userNo) throws Exception {
		Pager pager = new Pager();
		pager.setUserNo(userNo);
		return followMapper.followingCount(pager);
	}

	public Long followerCount(Long userNo) throws Exception {
		Pager pager = new Pager();
		pager.setUserNo(userNo);
		return followMapper.followerCount(pager);
	}

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

	public List<FollowDTO> isMatchedFollow(Long currentUserNo, Long userNo, Pager pager) throws Exception {
		
		pager.makePageNum(followMapper.isMatchedFollowCount(pager));
		pager.makeStartNum();
		FollowDTO followDTO = new FollowDTO();
		followDTO.setUserFollower(currentUserNo);
		followDTO.setUserFollowing(userNo);
		

		return followMapper.isMatchedFollow(followDTO, pager);
	}

	public boolean isFollowing(Long userFollower, Long userFollowing) throws Exception {
		FollowDTO followDTO = new FollowDTO();
		followDTO.setUserFollower(userFollower);
		followDTO.setUserFollowing(userFollowing);
		Boolean result = followMapper.isFollowing(followDTO);
		
		if (result != null && result) {
			return true;
		} else {
			return false;
		}
	}

	public MemberDTO getMemberByUserNo(Long userNo) throws Exception {
		return followMapper.getMemberByUserNo(userNo);
	}

}
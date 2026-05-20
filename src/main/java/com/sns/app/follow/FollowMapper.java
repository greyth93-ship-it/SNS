package com.sns.app.follow;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.sns.app.pager.Pager;
import com.sns.app.member.MemberDTO;

@Mapper
public interface FollowMapper {

	public Long followingCount(Pager pager) throws Exception;

	public Long followerCount(Pager pager) throws Exception;

	public Long mutualCount(Pager pager) throws Exception;

	public int follow(FollowDTO followDTO) throws Exception;

	public FollowDTO detail(FollowDTO followDTO) throws Exception;

	public int delete(FollowDTO followDTO) throws Exception;

	public List<FollowDTO> followingList(Pager pager) throws Exception;

	public List<FollowDTO> followerList(Pager pager) throws Exception;

	public Boolean isFollowing(FollowDTO followDTO) throws Exception;

	public MemberDTO getMemberByUserNo(Long userNo) throws Exception;

	public List<FollowDTO> isMatchedFollow(@Param("userFollower") Long userFollower,
			@Param("userFollowing") Long userFollowing, @Param("pager") Pager pager) throws Exception;

	public Long isMatchedFollowCount(Pager pager) throws Exception;

}

package com.sns.app.follow;

import org.apache.ibatis.annotations.Mapper;

import com.sns.app.pager.Pager;

@Mapper
public interface FollowMapper {
	
	public Long getCount(Pager pager)throws Exception;
	
	public int follow(FollowDTO followDTO) throws Exception;
	
	public FollowDTO detail(FollowDTO followDTO) throws Exception;
	
	public int delete(FollowDTO followDTO) throws Exception;

}

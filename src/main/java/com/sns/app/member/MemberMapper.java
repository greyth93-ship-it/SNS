package com.sns.app.member;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.validation.BindingResult;

@Mapper
public interface MemberMapper {

	public int join(MemberDTO memberDTO) throws Exception;
	
	public int addProfile(ProfileDTO profileDTO) throws Exception;
	
	public MemberDTO detail(MemberDTO memberDTO) throws Exception;
	
	public int update(MemberDTO memberDTO) throws Exception;
	
	public List<MemberDTO> search(String keyword) throws Exception;
	
	
	
	
}

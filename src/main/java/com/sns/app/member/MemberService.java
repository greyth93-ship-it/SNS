package com.sns.app.member;

import java.util.List;

import org.springframework.validation.BindingResult;
import org.springframework.web.multipart.MultipartFile;

public interface MemberService {
	
	public int join(MemberDTO memberDTO,MultipartFile file) throws Exception;
	
	
	public MemberDTO detail(MemberDTO memberDTO) throws Exception;
	
	public int update(MemberDTO memberDTO) throws Exception;
	
	public boolean doubleCheck(MemberDTO memberDTO, BindingResult bindingResult) throws Exception;
	
	public MemberDTO idCheck(MemberDTO memberDTO) throws Exception;

	public List<MemberDTO> search(String keyword) throws Exception;

}

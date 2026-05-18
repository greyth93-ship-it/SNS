package com.sns.app.member;

import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;
import org.springframework.web.multipart.MultipartFile;

import com.sns.app.file.FileManager;

import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class MemberServiceImpl implements MemberService, UserDetailsService{
	
	@Autowired
	private MemberMapper memberMapper;
	
	@Autowired
	private FileManager fileManager;
	
	@Value("${app.member}")
	private String name;
	
	@Autowired
	private PasswordEncoder encoder;
	
	@Override
	public List<MemberDTO> search(String keyword) throws Exception {
		
		if (keyword == null || keyword.trim().isEmpty()) {
			return Collections.emptyList();
		}
		
		return memberMapper.search(keyword);
	}
	
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		MemberDTO memberDTO = new MemberDTO();
		memberDTO.setUserId(username);
		try {
			memberDTO = memberMapper.detail(memberDTO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return memberDTO;
	}
	
	public boolean doubleCheck(MemberDTO memberDTO, BindingResult bindingResult) throws Exception {
		
		boolean result= false;
		
		result= bindingResult.hasErrors();
		
		if(!memberDTO.getPassword().equals(memberDTO.getUserPwCheck())) {
			bindingResult.rejectValue("userPwCheck", "member.userPwCheck.notEqual");
			result=true;
		}
		
		MemberDTO m = memberMapper.detail(memberDTO);
		
		if(m != null) {
			result=true;
			bindingResult.rejectValue("userId", "member.userId.eqaul");
		}
		return result;
	}
	
	@Override
	public MemberDTO idCheck(MemberDTO memberDTO) throws Exception {
		
		return memberMapper.detail(memberDTO);
	}
	
	
	
	@Override
	public int update(MemberDTO memberDTO) throws Exception {
		// TODO Auto-generated method stub
		return memberMapper.update(memberDTO);
	}

	@Override
	public int join(MemberDTO memberDTO, MultipartFile file) throws Exception {
		memberDTO.setUserPw(encoder.encode(memberDTO.getPassword()));
		int result = memberMapper.join(memberDTO);
		
		if(file != null && !file.isEmpty()) {
			String fileName = fileManager.fileSave(name, file);
			
			ProfileDTO profileDTO = new ProfileDTO();
			profileDTO.setFileName(fileName);;
			profileDTO.setOriName(file.getOriginalFilename());
			profileDTO.setUserNo(memberDTO.getUserNo());
			result = memberMapper.addProfile(profileDTO);
			
		}
		return result;
	}
	
	
	
	@Override
	public MemberDTO detail(MemberDTO memberDTO) throws Exception {
		MemberDTO check = memberMapper.detail(memberDTO);
		
		if(check != null) {
			if(check.getPassword().equals(memberDTO.getPassword())) {
				return check;
			}
				
		}
		return null;
	}
	
	
}

package com.sns.app.member;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import com.sns.app.feed.FeedDTO;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Past;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MemberDTO implements UserDetails{

	private Long userNo;
	@NotBlank(groups = GroupAdd.class, message="ID는 필수입니다.")
	private String userId;
	
	@NotBlank(groups = {GroupAdd.class, GroupUpdate.class})
	private String userNickname;
	
	@Size(groups = GroupAdd.class, min=2, max = 10)
	@NotBlank(groups = GroupAdd.class)
	private String userPw;
	private String userPwCheck;
	
	@Email(groups = {GroupAdd.class, GroupUpdate.class})
	private String userEmail;
	
	@Past(groups = {GroupAdd.class, GroupUpdate.class})
	private LocalDate userBirth;
	private boolean userAgr;
	
	private boolean accountNonExpired;
	
	private boolean accountNonLocked;
	
	private boolean credentialsNonExpired;
	
	private boolean enabled;
	
	private ProfileDTO profileDTO;
	
	private FeedDTO feedDTO;
	
	
	
	private List<RoleDTO> roles;
	
	
	
	
	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		
		List<GrantedAuthority> ar = new ArrayList<>();
		
		for(RoleDTO roleDTO:roles) {
			GrantedAuthority g = new SimpleGrantedAuthority(roleDTO.getRoleName());
			ar.add(g);
		}
		return ar;
	}
	
	
	
	
	
	@Override
	public String getPassword() {
	    // 내가 선언한 변수명(memPw)을 리턴하여 
	    // 시큐리티가 요구하는 getPassword() 역할을 수행하게 합니다.
		return this.userPw; 
	}
	
	@Override
	public String getUsername() {
	    // 내가 선언한 변수명(memPw)을 리턴하여 
	    // 시큐리티가 요구하는 getPassword() 역할을 수행하게 합니다.
	    return this.userId; 
	}
	
	@Override
	public boolean isAccountNonExpired() {
		// TODO Auto-generated method stub
		return UserDetails.super.isAccountNonExpired();
	}


	@Override
	public boolean isAccountNonLocked() {
		// TODO Auto-generated method stub
		return UserDetails.super.isAccountNonLocked();
	}


	@Override
	public boolean isCredentialsNonExpired() {
		// TODO Auto-generated method stub
		return UserDetails.super.isCredentialsNonExpired();
	}


	@Override
	public boolean isEnabled() {
		// TODO Auto-generated method stub
		return UserDetails.super.isEnabled();
	}

	
	
}

package com.sns.app.follow;

import java.util.Date;

import com.sns.app.member.MemberDTO;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class FollowDTO {
    
	private MemberDTO memberDTO;

	private Long userFollower;

	private Long userFollowing;

	private Date followDate;

	private String username;

}

package com.sns.app.member;

import java.time.LocalDate;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class FollowDTO {

	private Long followNo;
	private Long userFollower;
	private LocalDate followDate;
	private Long userFollowing;
}

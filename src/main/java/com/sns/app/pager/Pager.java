package com.sns.app.pager;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class Pager {

	private Long totalCount;
	
	private String search = "";

	private String kind; // v1:title, v2:contents, v3:writer

	private Long page;

	private Long perPage;

	private Long startNum;
	
	private Long userNo;

	private boolean pre = true;// true 이전블럭이 존재

	private boolean next = true;// true 다음 블럭이 존재

	private Long start;

	private Long end;
	private Long currentUserNo;

	public Long getPage() {
		if (page == null || page < 1) {
			this.page = 1L;
		}
		return this.page;
	}

	public Long getPerPage() {
		if (this.perPage == null || this.perPage < 1) {
			this.perPage = 5L;
		}
		return this.perPage;
	}

	public void makePageNum(Long totalCount) {

		this.totalCount = totalCount;  // ✅ totalCount 저장
		
		Long totalPage = (long) (Math.ceil((double) totalCount / this.getPerPage()));

		if (totalCount == 0) {
			this.start = 1L;
			this.end = 1L;
			this.pre = false;
			this.next = false;
			return;
		}

		Long perBlock = 5L;
		Long totalBlock = totalPage / perBlock;
		if (totalPage % perBlock != 0) {
			totalBlock++;
		}

		Long curBlock = this.getPage() / perBlock;
		if (this.getPage() % perBlock != 0) {
			curBlock++;
		}

		this.start = (curBlock - 1) * perBlock + 1;
		this.end = curBlock * perBlock;

		if (curBlock.equals(totalBlock)) {
			this.end = totalPage;
			this.next = false;
		}

		if (curBlock < 2) {
			this.pre = false;
		}
	}

	public void makeStartNum() {

		this.startNum = (this.getPage() - 1) * this.getPerPage();
	}

}

package com.sns.app.feed.post;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.sns.app.feed.FeedMapper;
import com.sns.app.feed.FeedDTO;
import com.sns.app.file.FileDTO;
import com.sns.app.pager.Pager;

@Mapper
public interface PostMapper extends FeedMapper {

	public int fileDelete(FileDTO fileDTO) throws Exception;

	public int fileDeleteFor(List<FileDTO> list) throws Exception;

	public Long countThumbByUser(FeedDTO feedDTO) throws Exception;

	public int insertThumb(FeedDTO feedDTO) throws Exception;

	public int deleteThumb(FeedDTO feedDTO) throws Exception;

	public int syncThumbCount(FeedDTO feedDTO) throws Exception;
	
	public Long getMyCount(Pager pager) throws Exception;
	
	public List<FeedDTO> myList(Pager pager) throws Exception;
	
	public List<FeedDTO> searchList(Pager pager) throws Exception;

	
}
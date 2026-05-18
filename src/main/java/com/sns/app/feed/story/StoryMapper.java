package com.sns.app.feed.story;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.sns.app.feed.FeedDTO;
import com.sns.app.feed.FeedMapper;

@Mapper
public interface StoryMapper extends FeedMapper {

	public List<FeedDTO> listByUser(FeedDTO feedDTO) throws Exception;
	public Long countThumbByUser(FeedDTO feedDTO) throws Exception;
	public int insertThumb(FeedDTO feedDTO) throws Exception;
	public int deleteThumb(FeedDTO feedDTO) throws Exception;
	public int syncThumbCount(FeedDTO feedDTO) throws Exception;
	
}

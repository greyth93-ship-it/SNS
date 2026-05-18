package com.sns.app.feed;

import java.util.List;
import com.sns.app.file.FileDTO;
import com.sns.app.pager.Pager;

public interface FeedMapper {

	public Long getCount(Pager pager)throws Exception;
    
    public List<FeedDTO> list(Pager pager) throws Exception;

    public FeedDTO detail(FeedDTO feedDTO) throws Exception;

    public int create(FeedDTO feedDTO) throws Exception;

    public int createFile(FileDTO fileDTO) throws Exception;
    
    public int update(FeedDTO feedDTO) throws Exception;

    public int delete(FeedDTO feedDTO) throws Exception;

    public FileDTO fileDetail(FileDTO fileDTO) throws Exception;

    
}
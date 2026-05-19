package com.sns.app.feed.story;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.sns.app.feed.FeedDTO;
import com.sns.app.feed.FeedService; // FeedService 인터페이스가 있다고 가정
import com.sns.app.file.FileDTO;
import com.sns.app.file.FileManager;
import com.sns.app.member.MemberDTO;
import com.sns.app.pager.Pager;
import com.sns.app.push.PushDTO;
import com.sns.app.push.PushService;

@Service
@Transactional
public class StoryService implements FeedService {

	@Autowired
	private StoryMapper storyMapper;

	@Autowired
	private FileManager fileManager;

	@Autowired
	private PushService pushService;

	@Value("${app.feed.story}")
	private String name;

	@Override
	public List<FeedDTO> list(Pager pager) throws Exception {

		Long totalCount = storyMapper.getCount(pager);
		pager.setPage(1L);
		pager.setPerPage(totalCount);
		pager.makePageNum(totalCount);
		pager.makeStartNum();

		return storyMapper.list(pager);
	}
	

	@Override
	public int create(FeedDTO feedDTO, MultipartFile[] attach) throws Exception {
		// 1. 피드(스토리) 테이블에 글 추가
		int result = storyMapper.create(feedDTO);

		if (attach == null) {
			return result;
		}

		// 2. 첨부 파일을 Base64 문자열로 변환해서 DB에 저장
		for (MultipartFile f : attach) {
			if (f.isEmpty()) {
				continue;
			}

			String fileName = fileManager.fileSave(name, f);

			// 3. 파일의 정보들을 DB에 저장
			StoryFileDTO fileDTO = new StoryFileDTO();
            fileDTO.setFeedNo(feedDTO.getFeedNo()); 
            fileDTO.setOriName(f.getOriginalFilename());
            fileDTO.setFileName(fileName);

			result = storyMapper.createFile(fileDTO);
		}

		return result;
	}

	@Override
	public int delete(FeedDTO feedDTO) throws Exception {
		// 1. 파일명 및 정보 조회를 위해 상세 정보 가져오기
		feedDTO = storyMapper.detail(feedDTO);

		if (feedDTO == null) {
			return 0;
		}

		if (feedDTO.getList() != null) {
			for (FileDTO fileDTO : feedDTO.getList()) {
				fileManager.fileDelete(name, fileDTO);
				}
			}

		storyMapper.deleteThumbForStory(feedDTO);

		int result = storyMapper.delete(feedDTO);
		return result;
		
		}

	@Override
	public FileDTO fileDetail(FileDTO fileDTO) throws Exception {
		return storyMapper.fileDetail(fileDTO);
	}

	@Override
	public FeedDTO detail(FeedDTO feedDTO) throws Exception {
		return storyMapper.detail(feedDTO);
	}

	public FeedDTO toggleThumb(FeedDTO feedDTO, MemberDTO memberDTO) throws Exception {
		FeedDTO originalStory = storyMapper.detail(feedDTO);
		Long thumbCount = storyMapper.countThumbByUser(feedDTO);
		if (thumbCount != null && thumbCount > 0) {
			storyMapper.deleteThumb(feedDTO);
		} else {
			storyMapper.insertThumb(feedDTO);

			try {
				PushDTO push = new PushDTO();
				push.setReceiverNo(originalStory.getUserNo());
				push.setSenderNo(memberDTO.getUserNo());
				push.setPushType("LIKE");
				push.setPostNo(feedDTO.getFeedNo());

				String senderName = memberDTO.getUserNickname();
				push.setPushMsg(senderName + "님이 회원님의 스토리를 좋아합니다.");

				if (originalStory.getUserNo() != null && !originalStory.getUserNo().equals(memberDTO.getUserNo())) {
					pushService.sendPush(push);
				}
			} catch (Exception e) {
				System.err.println("스토리 알림 처리 실패: " + e.getMessage());
			}
		}

		storyMapper.syncThumbCount(feedDTO);
		return storyMapper.detail(feedDTO);
	}

	public List<FeedDTO> listByUser(Long userNo) throws Exception {
		FeedDTO feedDTO = new FeedDTO();
		feedDTO.setUserNo(userNo);
		return storyMapper.listByUser(feedDTO);
	}

	// Overload to accept currentUserNo so SQL can use currentUserNo for LIKED_BY_ME
	public List<FeedDTO> listByUser(Long userNo, Long currentUserNo) throws Exception {
		FeedDTO feedDTO = new FeedDTO();
		feedDTO.setUserNo(userNo);
		feedDTO.setCurrentUserNo(currentUserNo);
		return storyMapper.listByUser(feedDTO);
	}

	@Override
	public int update(FeedDTO feedDTO, MultipartFile[] attach) throws Exception {
		// 기본적으로 Mapper의 update 호출로 처리
		return storyMapper.update(feedDTO);
	}

	

}
package com.sns.app.feed.post;

import java.util.Base64;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.sns.app.feed.FeedDTO;
import com.sns.app.feed.FeedService;
import com.sns.app.file.FileDTO;
import com.sns.app.file.FileManager;
import com.sns.app.member.MemberDTO;
import com.sns.app.pager.Pager;
import com.sns.app.push.PushDTO;
import com.sns.app.push.PushService;

@Service
@Transactional
public class PostService implements FeedService {

	@Autowired
    private PushService pushService;

    @Autowired
    private PostMapper postMapper;

    @Autowired
    private FileManager fileManager;

    @Value("${app.feed.post}")
    private String name;

    @Override
    public List<FeedDTO> list(Pager pager) throws Exception {

        pager.makePageNum(postMapper.getCount(pager));
        
        pager.makeStartNum();
        
        return postMapper.list(pager);
    }
    
    public List<FeedDTO> myList(Pager pager) throws Exception {
    	
        pager.makePageNum(postMapper.getMyCount(pager));
        
        pager.makeStartNum();
        
        return postMapper.myList(pager);
    }
    
    public List<FeedDTO> searchList(Pager pager) throws Exception {
		pager.makePageNum(postMapper.getCount(pager));
		pager.makeStartNum();
		return postMapper.searchList(pager);
	}

    @Override
    public FeedDTO detail(FeedDTO feedDTO) throws Exception {
        return postMapper.detail(feedDTO);
    }

    @Transactional
    public FeedDTO toggleThumb(FeedDTO feedDTO, MemberDTO memberDTO) throws Exception {
        // 1. 좋아요 상태 확인
        Long thumbCount = postMapper.countThumbByUser(feedDTO);
        
        if (thumbCount != null && thumbCount > 0) {
            // 좋아요 취소
            postMapper.deleteThumb(feedDTO);
        } else {
            // 좋아요 추가
            postMapper.insertThumb(feedDTO);

            // --- 실시간 및 DB 알림 로직 추가 ---
            try {
                // 1. 알림 데이터 생성 (PushDTO 활용)
                PushDTO push = new PushDTO();
                
                // 받는 사람: 게시글 작성자 (feedDTO.getUserNo())
                push.setReceiverNo(feedDTO.getUserNo()); 
                
                // 보낸 사람: 현재 로그인 유저 (memberDTO.getUserNo())
                push.setSenderNo(memberDTO.getUserNo());
                
                // 데이터 세팅
                push.setPushType("LIKE");
                push.setPostNo(feedDTO.getFeedNo()); // 클릭 시 이동할 게시글 번호
                
                String senderName = memberDTO.getUserNickname();
                push.setPushMsg(senderName + "님이 회원님의 게시물을 좋아합니다.");

                if (feedDTO.getUserNo() != null && !feedDTO.getUserNo().equals(memberDTO.getUserNo())) {
                    pushService.sendPush(push);
                } else {
                    System.out.println("본인 게시글이므로 알림을 발송하지 않습니다.");
                }
                
            } catch (Exception e) {
                // 알림 실패가 "좋아요" 자체에 영향을 주지 않도록 예외 처리
                System.err.println("알림 처리 실패: " + e.getMessage());
            }
        }

        postMapper.syncThumbCount(feedDTO);
        return postMapper.detail(feedDTO);
    }

    @Transactional
    public int create(PostDTO postDTO, MultipartFile[] attach) throws Exception {
        // 1. 부모 테이블(FEED) 및 자식 테이블(POST) 데이터 저장
        // Mapper의 create(feedDTO)가 실행되면서 postDTO의 정보가 저장됨
        int result = postMapper.create(postDTO);

        // 2. 파일 처리 및 저장
        if (attach != null) {
            for (MultipartFile file : attach) {
                if (file.isEmpty()) continue;

                // 파일을 Base64 문자열로 변환
                byte[] fileBytes = file.getBytes();
                String base64String = "data:" + file.getContentType() + ";base64," 
                                      + Base64.getEncoder().encodeToString(fileBytes);

                // PostFileDTO 생성 및 데이터 세팅
                PostFileDTO fileDTO = new PostFileDTO();
                fileDTO.setFeedNo(postDTO.getFeedNo()); // 생성된 피드 번호 사용
                fileDTO.setOriName(file.getOriginalFilename());
                fileDTO.setFileName(base64String); // fileName 컬럼에 Base64 주입

                // Mapper의 createFile 호출 (DB에 INSERT)
                postMapper.createFile(fileDTO);
            }
        }
        return result;
    }

    @Override
    public int update(FeedDTO feedDTO, MultipartFile[] attach) throws Exception {
        return postMapper.update(feedDTO);
    }

    @Override
    public int delete(FeedDTO feedDTO) throws Exception {
        // HDD 파일 삭제를 위해 상세 정보 조회
        feedDTO = postMapper.detail(feedDTO);

        if (feedDTO.getList() != null) {
            for (FileDTO fileDTO : feedDTO.getList()) {
                fileManager.fileDelete(name, fileDTO);
            }

            // 기존에 이미 있는 매퍼를 사용해서 POST_IMG 먼저 삭제
            postMapper.fileDeleteFor(feedDTO.getList());
        }

        return postMapper.delete(feedDTO);
    }

    @Override
    public FileDTO fileDetail(FileDTO fileDTO) throws Exception {
        return postMapper.fileDetail(fileDTO);
    }

	@Override
	public int create(FeedDTO feedDTO, MultipartFile[] attach) throws Exception {
		// TODO Auto-generated method stub
		return 0;
	}


}
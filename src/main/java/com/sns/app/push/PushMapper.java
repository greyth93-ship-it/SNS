package com.sns.app.push;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.sns.app.pager.Pager;

@Mapper
public interface PushMapper {
    void insertPush(PushDTO push);
    
    List<PushDTO> selectPushListByReceiver(Long receiverNo);
    int countUnreadByReceiver(Long receiverNo);
    List<PushDTO> selectAllPushListByReceiver(Long receiverNo);
    long countAllPushByReceiverPager(Pager pager);
    List<PushDTO> selectAllPushListByReceiverPager(Pager pager);
    
    void updateReadStatus(Long pushNo);
}


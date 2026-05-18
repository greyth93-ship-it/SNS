package com.sns.app.push;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface PushMapper {
    void insertPush(PushDTO push);
    
    List<PushDTO> selectPushListByReceiver(Long receiverNo);
    
    void updateReadStatus(Long pushNo);
}


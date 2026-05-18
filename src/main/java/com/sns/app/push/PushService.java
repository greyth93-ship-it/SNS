package com.sns.app.push;

import com.pusher.rest.Pusher;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class PushService {

	@Autowired
	private PushMapper pushMapper;

	@Autowired
	private Pusher pusher;

	public void sendPush(PushDTO pushDTO) {

		// 1. DB 저장
		pushMapper.insertPush(pushDTO);

		// 2. Pusher 발송용 데이터 구성
		Map<String, String> data = new HashMap<>();
		data.put("message", pushDTO.getPushMsg());
		data.put("type", pushDTO.getPushType());

		// 3. 실시간 알림 전송
		String channelName = "sns-alarm-" + pushDTO.getReceiverNo(); 
	    
	    pusher.trigger(channelName, "new-post", data);
	}

	public List<PushDTO> getPushListByReceiver(Long receiverNo) {
		return pushMapper.selectPushListByReceiver(receiverNo);
	}

	public void markAsRead(Long pushNo) {
		pushMapper.updateReadStatus(pushNo);
	}

}
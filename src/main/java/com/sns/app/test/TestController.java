package com.sns.app.test;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.pusher.rest.Pusher;

import java.util.HashMap;
import java.util.Map;

@RestController
public class TestController {

    @Autowired
    private Pusher pusher; // Config에서 만든 그 Pusher

    @GetMapping("/send-test")
    public String sendTest(@RequestParam("msg") String msg) {
        // 전송할 데이터 담기
        Map<String, String> data = new HashMap<>();
        data.put("message", msg);

        // Pusher로 발송! 
        // (채널명: sns-alarm, 이벤트명: new-post) -> JS 코드와 일치해야 함
        pusher.trigger("sns-alarm", "new-post", data);

        return "전송 성공: " + msg;
    }
}
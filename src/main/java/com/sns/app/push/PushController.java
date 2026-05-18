package com.sns.app.push;

import java.util.List;
import java.util.Map;
import java.util.HashMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import com.sns.app.member.MemberDTO;

@Controller
@RequestMapping("/push")
public class PushController {

    @Autowired
    private PushService pushService;

   
    @GetMapping("/list")
    @ResponseBody
    public List<PushDTO> getPushList(@AuthenticationPrincipal MemberDTO memberDTO) {
        if (memberDTO == null) return null;
        
        // 현재 로그인한 유저(Receiver)의 알림 목록을 가져옵니다.
        return pushService.getPushListByReceiver(memberDTO.getUserNo());
    }

   
    @PostMapping("/read")
    @ResponseBody
    public Map<String, Object> markAsRead(@RequestParam("pushNo") Long pushNo) {
        Map<String, Object> result = new HashMap<>();
        try {
            pushService.markAsRead(pushNo);
            result.put("status", "success");
        } catch (Exception e) {
            result.put("status", "error");
        }
        return result;
    }
}
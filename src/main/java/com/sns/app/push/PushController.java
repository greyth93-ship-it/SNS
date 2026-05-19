package com.sns.app.push;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sns.app.member.MemberDTO;
import com.sns.app.pager.Pager;
import org.springframework.ui.Model;

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

    @GetMapping("/unreadCount")
    @ResponseBody
    public Map<String, Object> getUnreadCount(@AuthenticationPrincipal MemberDTO memberDTO) {
        Map<String, Object> result = new HashMap<>();
        if (memberDTO == null) {
            result.put("count", 0);
            return result;
        }

        int count = pushService.countUnreadByReceiver(memberDTO.getUserNo());
        result.put("count", count);
        return result;
    }

    @GetMapping("/allList")
    public String allList(@AuthenticationPrincipal MemberDTO memberDTO, Pager pager, Model model) {
        if (memberDTO == null) {
            return "redirect:/member/login";
        }

        pager.setUserNo(memberDTO.getUserNo());
        int unreadCount = pushService.countUnreadByReceiver(memberDTO.getUserNo());
        List<PushDTO> list = pushService.getAllPushListByReceiver(pager);
        model.addAttribute("pager", pager);
        model.addAttribute("unreadCount", unreadCount);
        model.addAttribute("pushList", list);
        return "push/allList";
    }
}
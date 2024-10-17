package com.friedchicken.task;


import com.friedchicken.pojo.vo.Order.OrderMessageVO;
import com.friedchicken.service.SseService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.Map;

@Slf4j
@Configuration
public class HeartBeatTask {
    @Autowired
    private SseService sseService;

    @Scheduled(fixedRate = 5000)
    public void sendMessageTask() {
        OrderMessageVO orderMessageVO = new OrderMessageVO();
        orderMessageVO.setOrderId("ping");
        sseService.sendMessage(orderMessageVO);
        Map<String, SseEmitter> sseEmitterMap = sseService.getSseEmitterMap();
        log.info("SSE connections:{}",sseEmitterMap.toString());
    }
}

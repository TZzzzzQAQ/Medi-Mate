package com.friedchicken.service;

import com.friedchicken.pojo.vo.Order.OrderMessageVO;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.Map;

public interface SseService {
    SseEmitter connect(String uuid);

    void sendMessage(OrderMessageVO orderMessageVO);

    boolean hasActiveConnections();

    public Map<String, SseEmitter> getSseEmitterMap();
}

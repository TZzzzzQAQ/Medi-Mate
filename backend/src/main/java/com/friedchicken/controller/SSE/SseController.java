package com.friedchicken.controller.SSE;

import com.friedchicken.pojo.vo.Order.OrderMessageVO;
import com.friedchicken.service.SseService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.UUID;

@RestController
@RequestMapping("/api/sse")
@Tag(name = "SSE", description = "API for Server-Sent Events (SSE) connection management.")
@Slf4j
public class SseController {
    @Autowired
    private SseService sseService;

    @GetMapping(path = "/connect", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    @Operation(summary = "Establish a new SSE connection",
            description = "Opens a new SSE connection and returns an SseEmitter. Each connection is identified by a unique UUID.")
    @ApiResponse(responseCode = "200", description = "SSE connection established successfully",
            content = @Content(mediaType = "text/event-stream"))
    public SseEmitter sse() {
        String uuid = UUID.randomUUID().toString();
        log.info("SSE connection established with uuid: {}", uuid);
        return sseService.connect(uuid);
    }

    @PostMapping("/sendMessage")
    @Operation(summary = "Send a message to all SSE clients",
            description = "Sends a broadcast message to all connected SSE clients.")
    @ApiResponse(responseCode = "200", description = "Message sent successfully")
    @ApiResponse(responseCode = "500", description = "Error sending the message",
            content = @Content(schema = @Schema(implementation = Error.class)))
    @ResponseBody
    public void sendMessage(@RequestBody OrderMessageVO orderMessageVO) {
        sseService.sendMessage(orderMessageVO);
    }
}

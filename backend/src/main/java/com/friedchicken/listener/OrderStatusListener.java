package com.friedchicken.listener;

import com.friedchicken.listener.Exception.NoStaffException;
import com.friedchicken.pojo.entity.Order.OrderEmail;
import com.friedchicken.service.OrderService;
import com.friedchicken.service.SseService;
import jakarta.mail.internet.MimeMessage;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.core.ExchangeTypes;
import org.springframework.amqp.rabbit.annotation.Exchange;
import org.springframework.amqp.rabbit.annotation.Queue;
import org.springframework.amqp.rabbit.annotation.QueueBinding;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Component;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;


@Component
@Slf4j
public class OrderStatusListener {
    @Autowired
    private OrderService orderService;
    @Autowired
    private SseService sseService;
    @Autowired
    private JavaMailSender mailSender;
    @Autowired
    private TemplateEngine templateEngine;

    @RabbitListener(bindings = @QueueBinding(
            value = @Queue(name = "mark.order.pay.queue", durable = "true"),
            exchange = @Exchange(name = "pay.topic", type = ExchangeTypes.TOPIC),
            key = "pay.success"
    ))
    public void listenOrderPay(String orderId) {
        if (!sseService.hasActiveConnections()) {
            throw new NoStaffException("NO STAFF CONNECTIONS");
        } else {
            orderService.handleOrderPaymentSuccess(orderId);
            log.info("Payment success for order: {}", orderId);
        }
    }

    @RabbitListener(bindings = @QueueBinding(
            value = @Queue(name = "mark.order.pick.queue", durable = "true"),
            exchange = @Exchange(name = "pick.topic", type = ExchangeTypes.TOPIC),
            key = "pick.success"
    ))
    public void listenOrderPick(OrderEmail orderEmail) throws Exception {
        log.info("Order picked: {}", orderEmail);

        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true);

        helper.setTo(orderEmail.getEmail());
        helper.setSubject("Order Completion Notification");

        Context context = new Context();
        context.setVariable("nickname", orderEmail.getNickname());
        context.setVariable("orderId", orderEmail.getOrderId());
        context.setVariable("pharmacyAddress", orderEmail.getPharmacyAddress());
        context.setVariable("userId", orderEmail.getUserId());

        String htmlContent = templateEngine.process("orderConfirmation", context);

        helper.setText(htmlContent, true);

        mailSender.send(mimeMessage);
    }
}

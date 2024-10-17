package com.friedchicken.service.impl;

import com.friedchicken.constant.MessageConstant;
import com.friedchicken.constant.OrderStatusConstant;
import com.friedchicken.mapper.OrderMapper;
import com.friedchicken.mapper.ProductMapper;
import com.friedchicken.pojo.dto.Order.*;
import com.friedchicken.pojo.entity.Order.Order;
import com.friedchicken.pojo.entity.Order.OrderEmail;
import com.friedchicken.pojo.entity.Order.OrderItem;
import com.friedchicken.pojo.vo.Medicine.MedicineDetailVO;
import com.friedchicken.pojo.vo.Order.DetailOrderVO;
import com.friedchicken.pojo.vo.Order.OrderItemDetailVO;
import com.friedchicken.pojo.vo.Order.OrderMessageVO;
import com.friedchicken.service.OrderService;
import com.friedchicken.service.SseService;
import com.friedchicken.service.exception.NoCancelReasonException;
import com.friedchicken.service.exception.NoProductException;
import com.friedchicken.service.exception.NoQuantityException;
import com.friedchicken.utils.UniqueIdUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.concurrent.TimeUnit;

@Slf4j
@Service
public class OrderServiceImpl implements OrderService {
    @Autowired
    private SseService sseService;
    @Autowired
    private OrderMapper orderMapper;
    @Autowired
    private ProductMapper productMapper;
    @Autowired
    private UniqueIdUtil uniqueIdUtil;
    @Autowired
    private RabbitTemplate rabbitTemplate;
    @Autowired
    private RedisTemplate<String, MedicineDetailVO> medicineDetailRedisTemplate;

    @Override
    @Transactional
    public void orderProduct(OrderDTO orderDTO) {
        Order order = new Order();
        BeanUtils.copyProperties(orderDTO, order);
        String orderId = uniqueIdUtil.generateUniqueId();
        order.setOrderId(orderId);
        order.setStatus(OrderStatusConstant.FINISH_ORDER_STATUS);
        orderMapper.insertOrder(order);
        for (OrderItemDTO item : orderDTO.getOrderItem()) {
            OrderItem orderItem = new OrderItem();
            BeanUtils.copyProperties(item, orderItem);
            if (orderItem.getQuantity() <= 0) {
                throw new NoQuantityException(MessageConstant.NO_QUANTITY);
            }
            MedicineDetailVO medicineDetailVO = medicineDetailRedisTemplate.opsForValue().get(orderItem.getProductId());
            if (medicineDetailVO == null) {
                MedicineDetailVO productById = productMapper.getProductById(orderItem.getProductId());
                if (productById == null) {
                    throw new NoProductException(MessageConstant.NO_SUCH_PRODUCT);
                }
                medicineDetailRedisTemplate.opsForValue().set(orderItem.getProductId(), productById, 10, TimeUnit.MINUTES);
            }
            orderItem.setOrderId(orderId);
            orderItem.setItemId(uniqueIdUtil.generateUniqueId());
            orderMapper.insertOrderItem(orderItem);
        }
        rabbitTemplate.convertAndSend("pay.topic", "pay.success", orderId);
    }

    @Override
    public void handleOrderPaymentSuccess(String orderId) {
        OrderMessageVO orderMessageVO = new OrderMessageVO();
        orderMessageVO.setOrderId(orderId);
        sseService.sendMessage(orderMessageVO);
    }

    @Override
    public List<DetailOrderVO> getOrderDetailByUserId(DetailOrderPageDTO detailOrderPageDTO) {
        return orderMapper.getOrderByUserId(detailOrderPageDTO.getUserId());
    }

    @Override
    public List<OrderItemDetailVO> getOrderItemDetailByOrderId(String orderId) {
        return orderMapper.getOrderItemDetailByOrderId(orderId);
    }

    @Override
    public List<DetailOrderVO> getOrderByPharmacyId(String pharmacyId) {
        return orderMapper.getOrderByPharmacyId(pharmacyId);
    }

    @Override
    @Transactional
    public void updateOrderStatus(UpdateOrderDTO updateOrderDTO) {
        int status = updateOrderDTO.getStatus();
        if (status == OrderStatusConstant.FINISH_PICKING) {
            OrderEmail orderEmail = orderMapper.getOrderDetailByOrderId(updateOrderDTO);
            log.info("orderEmail:{}", orderEmail);
            rabbitTemplate.convertAndSend("pick.topic", "pick.success", orderEmail);
        } else if (status == OrderStatusConstant.CANCEL_ORDER_STATUS) {
            if (updateOrderDTO.getCancelReason().isEmpty()) {
                throw new NoCancelReasonException(MessageConstant.NO_CANCEL_REASON);
            }
        }
        orderMapper.updateOrder(updateOrderDTO);
    }

    @Override
    public void deleteOrder(DeleteOrderDTO deleteOrderDTO) {
        orderMapper.deleteOrder(deleteOrderDTO);
    }
}

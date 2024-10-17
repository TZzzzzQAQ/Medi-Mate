package com.friedchicken.service;

import com.friedchicken.pojo.dto.Order.DeleteOrderDTO;
import com.friedchicken.pojo.dto.Order.DetailOrderPageDTO;
import com.friedchicken.pojo.dto.Order.OrderDTO;
import com.friedchicken.pojo.dto.Order.UpdateOrderDTO;
import com.friedchicken.pojo.vo.Order.DetailOrderVO;
import com.friedchicken.pojo.vo.Order.OrderItemDetailVO;

import java.util.List;

public interface OrderService {

    void orderProduct(OrderDTO orderDTO);

    void handleOrderPaymentSuccess(String orderId);

    List<DetailOrderVO> getOrderDetailByUserId(DetailOrderPageDTO detailOrderPageDTO);

    List<OrderItemDetailVO> getOrderItemDetailByOrderId(String orderId);

    List<DetailOrderVO> getOrderByPharmacyId(String pharmacyId);

    void updateOrderStatus(UpdateOrderDTO orderDTO);

    void deleteOrder(DeleteOrderDTO deleteOrderDTO);
}

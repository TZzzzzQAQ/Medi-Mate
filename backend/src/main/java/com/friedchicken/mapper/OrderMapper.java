package com.friedchicken.mapper;

import com.friedchicken.annotation.AutoFillDateTime;
import com.friedchicken.enumeration.OperationType;
import com.friedchicken.pojo.dto.Order.DeleteOrderDTO;
import com.friedchicken.pojo.dto.Order.UpdateOrderDTO;
import com.friedchicken.pojo.entity.Order.Order;
import com.friedchicken.pojo.entity.Order.OrderEmail;
import com.friedchicken.pojo.entity.Order.OrderItem;
import com.friedchicken.pojo.vo.Order.DetailOrderVO;
import com.friedchicken.pojo.vo.Order.OrderItemDetailVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface OrderMapper {

    void insertOrderItem(OrderItem orderItem);

    @AutoFillDateTime(OperationType.INSERT)
    void insertOrder(Order order);

    Order getOrderByOrderId(String orderId);

    List<DetailOrderVO> getOrderByUserId(String userId);

    List<OrderItemDetailVO> getOrderItemDetailByOrderId(String orderId);

    List<DetailOrderVO> getOrderByPharmacyId(String pharmacyId);

    @AutoFillDateTime(OperationType.UPDATE)
    void updateOrder(UpdateOrderDTO updateOrderDTO);

    void deleteOrder(DeleteOrderDTO deleteOrderDTO);

    OrderEmail getOrderDetailByOrderId(UpdateOrderDTO updateOrderDTO);
}

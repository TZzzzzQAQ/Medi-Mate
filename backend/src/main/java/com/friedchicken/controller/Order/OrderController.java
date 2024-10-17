package com.friedchicken.controller.Order;

import com.friedchicken.pojo.dto.Order.DeleteOrderDTO;
import com.friedchicken.pojo.dto.Order.DetailOrderPageDTO;
import com.friedchicken.pojo.dto.Order.OrderDTO;
import com.friedchicken.pojo.dto.Order.UpdateOrderDTO;
import com.friedchicken.pojo.vo.Order.DetailOrderVO;
import com.friedchicken.pojo.vo.Order.OrderItemDetailVO;
import com.friedchicken.result.Result;
import com.friedchicken.service.OrderService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/order")
@Tag(name = "Order", description = "API for User to order product.")
@Slf4j
public class OrderController {
    @Autowired
    private OrderService orderService;

    @PostMapping("/orderProduct")
    @Operation(summary = "Order products.",
            description = "Order products at one pharmacy.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Buy successfully.",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = String.class)))
    })
    public Result<String> orderProduct(@RequestBody OrderDTO orderDTO) {
        log.info("Order product request{}", orderDTO);

        orderService.orderProduct(orderDTO);

        return Result.success("Order product successfully.");
    }

    @PostMapping("/allOrder")
    @Operation(summary = "Get order details.",
            description = "Use user id to retrieval user's orders.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Get successfully.",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = List.class)))
    })
    public Result<List<DetailOrderVO>> getOrderDetail(@RequestBody DetailOrderPageDTO detailOrderPageDTO) {
        log.info("Order detail request{}", detailOrderPageDTO);

        List<DetailOrderVO> detailOrderVO = orderService.getOrderDetailByUserId(detailOrderPageDTO);

        return Result.success(detailOrderVO);
    }

    @GetMapping("/detailOrder/{orderId}")
    @Operation(summary = "Get order details.",
            description = "Use order id to retrival user's orders.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Get successfully.",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = List.class)))
    })
    public Result<List<OrderItemDetailVO>> getOrderItemDetail(@PathVariable String orderId) {
        log.info("Order Item detail request{}", orderId);

        List<OrderItemDetailVO> orderItemDetailVO = orderService.getOrderItemDetailByOrderId(orderId);

        return Result.success(orderItemDetailVO);
    }

    @GetMapping("/pharmacyOrder/{pharmacyId}")
    @Operation(summary = "Get order details.",
            description = "Get order details by using pharmacy Id.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Get successfully.",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = List.class)))
    })
    public Result<List<DetailOrderVO>> getOrderDetailByPharmacyId(@PathVariable String pharmacyId) {
        log.info("Order detail request by pharmacyId {}", pharmacyId);

        List<DetailOrderVO> detailOrderVOList = orderService.getOrderByPharmacyId(pharmacyId);

        return Result.success(detailOrderVOList);
    }

    @PatchMapping("/updateOrderStatus")
    @Operation(summary = "Update order details.",
            description = "Update order details by using order Id.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Get successfully.",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = String.class)))
    })
    public Result<String> updateOrderStatus(@RequestBody UpdateOrderDTO updateOrderDTO) {
        log.info("Order update request{}", updateOrderDTO);

        orderService.updateOrderStatus(updateOrderDTO);

        return Result.success("Order update successfully.");
    }

    @DeleteMapping("/order")
    @Operation(summary = "Delete order.",
            description = "Delete order by using order Id and user Id.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Delete successfully.",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = String.class)))
    })
    public Result<String> deleteOrder(@RequestBody DeleteOrderDTO deleteOrderDTO){
        log.info("Delete order request{}", deleteOrderDTO);

        orderService.deleteOrder(deleteOrderDTO);

        return Result.success("Delete successfully.");
    }
}

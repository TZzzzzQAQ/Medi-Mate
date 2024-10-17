package com.friedchicken.pojo.dto.Order;

import java.io.Serial;
import java.io.Serializable;

public class DeleteOrderDTO implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;

    private String orderId;
    private String userId;
}

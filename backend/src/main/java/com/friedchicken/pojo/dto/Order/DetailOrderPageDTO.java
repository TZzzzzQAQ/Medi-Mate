package com.friedchicken.pojo.dto.Order;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serial;
import java.io.Serializable;


@Data
@AllArgsConstructor
@NoArgsConstructor
public class DetailOrderPageDTO implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;

    private String userId;
}

package com.friedchicken.pojo.vo.Inventory;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

@Data
@AllArgsConstructor
public class DetailInventoryVO implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;
    private String productName;
    private Double productPrice;
    private String manufacturerName;
    private String imageSrc;
    private String stockQuantity;
    private String shelfNumber;
    private int shelfLevel;
}

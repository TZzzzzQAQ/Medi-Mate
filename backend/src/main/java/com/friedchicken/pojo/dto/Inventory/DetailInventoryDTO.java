package com.friedchicken.pojo.dto.Inventory;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serial;
import java.io.Serializable;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class DetailInventoryDTO implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;
    private int pharmacyId;
    private int page;
    private int pageSize;
    private String productName;
}

package com.friedchicken.pojo.vo.Medicine;

import lombok.Builder;
import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

@Data
@Builder
public class MedicineInfoVO implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;
    private String productId;
    private String productName;
    private String productPrice;
    private String manufactureName;
    private String imageSrc;
}

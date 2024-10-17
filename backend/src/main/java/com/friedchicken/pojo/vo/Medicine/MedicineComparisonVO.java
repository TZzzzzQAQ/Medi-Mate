package com.friedchicken.pojo.vo.Medicine;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

@Data
public class MedicineComparisonVO implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;

    private String productId;
    private String productName;
    private String productPrice;
    private String warnings;
    private String commonUse;
    private String difference;
    private String imageSrc;
}
